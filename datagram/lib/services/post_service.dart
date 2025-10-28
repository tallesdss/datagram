import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import 'supabase_service.dart';
import 'storage_service.dart';
import 'user_service.dart';

/// Serviço para gerenciar operações relacionadas a posts
class PostService {
  final SupabaseClient _client = SupabaseService().client;
  final StorageService _storageService = StorageService();
  final UserService _userService = UserService();
  
  /// Obter todos os posts
  Future<List<PostModel>> getAllPosts() async {
    final response = await _client
        .from('posts')
        .select('*, users(*)')
        .order('created_at', ascending: false);
    
    return (response as List).map((post) {
      final userData = post['users'];
      post['user'] = userData;
      return PostModel.fromJson(post);
    }).toList();
  }
  
  /// Criar um novo post
  Future<PostModel> createPost({
    required String caption,
    required String imageUrl,
    String? location,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Criar o post no banco de dados
    final response = await _client.from('posts').insert({
      'user_id': userId,
      'image_url': imageUrl,
      'caption': caption,
      'location': location,
      'created_at': DateTime.now().toIso8601String(),
    }).select('*, users(*)').single();
    
    // Preparar dados do usuário
    final userData = response['users'];
    response['user'] = userData;
    
    // Atualizar estatísticas do usuário
    await _userService.updateUserStats(userId);
    
    return PostModel.fromJson(response);
  }
  
  /// Criar um novo post com upload de imagem usando bytes
  Future<PostModel> createPostWithImageBytes({
    required Uint8List imageBytes,
    String? caption,
    String? location,
  }) async {
    print('DEBUG PostService: Iniciando createPostWithImageBytes');
    
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      print('DEBUG PostService: Usuário não autenticado');
      throw Exception('Usuário não autenticado');
    }
    
    print('DEBUG PostService: Usuário autenticado: $userId');
    print('DEBUG PostService: Tamanho da imagem: ${imageBytes.length} bytes');
    print('DEBUG PostService: Legenda: $caption');
    print('DEBUG PostService: Localização: $location');
    
    try {
      // Upload da imagem usando bytes
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = 'posts/$userId/$timestamp';
      print('DEBUG PostService: Fazendo upload da imagem para: $imagePath');
      
      final imageUrl = await _storageService.uploadImageBytes(
        imageBytes: imageBytes,
        path: imagePath,
      );
      
      print('DEBUG PostService: Upload concluído. URL: $imageUrl');
      
      // Criar o post usando o método principal
      print('DEBUG PostService: Criando post no banco de dados...');
      final result = await createPost(
        caption: caption ?? '',
        imageUrl: imageUrl,
        location: location,
      );
      
      print('DEBUG PostService: Post criado com sucesso!');
      return result;
    } catch (e) {
      print('DEBUG PostService: Erro ao criar post: $e');
      rethrow;
    }
  }
  
  /// Obter posts com paginação
  Future<List<PostModel>> getPosts({
    required int limit,
    required int offset,
  }) async {
    final response = await _client
        .from('posts')
        .select('*, users(*)')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    
    return (response as List).map((post) {
      final userData = post['users'];
      post['user'] = userData;
      return PostModel.fromJson(post);
    }).toList();
  }
  
  /// Obter post pelo ID
  Future<PostModel?> getPostById(String postId) async {
    final response = await _client
        .from('posts')
        .select('*, users(*)')
        .eq('id', postId)
        .maybeSingle();
    
    if (response == null) return null;
    
    final userData = response['users'];
    response['user'] = userData;
    return PostModel.fromJson(response);
  }
  
  /// Obter posts de um usuário específico
  Future<List<PostModel>> getPostsByUser(String userId) async {
    final response = await _client
        .from('posts')
        .select('*, users(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (response as List).map((post) {
      final userData = post['users'];
      post['user'] = userData;
      return PostModel.fromJson(post);
    }).toList();
  }
  
  /// Deletar um post
  Future<void> deletePost(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Obter URL da imagem antes de deletar
    final post = await getPostById(postId);
    if (post == null) throw Exception('Post não encontrado');
    
    // Verificar se o usuário é o dono do post
    if (post.userId != userId) {
      throw Exception('Você não tem permissão para deletar este post');
    }
    
    // Deletar o post do banco de dados
    await _client.from('posts').delete().eq('id', postId);
    
    // Extrair o caminho da imagem da URL
    final imageUrl = post.imageUrl;
    final pathRegExp = RegExp(r'posts/[^?]+');
    final match = pathRegExp.firstMatch(imageUrl);
    
    if (match != null) {
      final imagePath = match.group(0);
      if (imagePath != null) {
        // Deletar a imagem do storage
        await _storageService.deleteImage(
          path: imagePath,
        );
      }
    }
    
    // Atualizar estatísticas do usuário
    await _userService.updateUserStats(userId);
  }
  
  /// Curtir um post
  Future<void> likePost(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Adicionar o like
    await _client.from('likes').insert({
      'user_id': userId,
      'post_id': postId,
    });
    
    // Atualizar contador de likes
    await _updatePostLikesCount(postId);
  }
  
  /// Descurtir um post
  Future<void> unlikePost(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Remover o like
    await _client
        .from('likes')
        .delete()
        .eq('user_id', userId)
        .eq('post_id', postId);
    
    // Atualizar contador de likes
    await _updatePostLikesCount(postId);
  }
  
  /// Verificar se o usuário atual curtiu o post
  Future<bool> isPostLiked(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    
    final response = await _client
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('post_id', postId)
        .maybeSingle();
    
    return response != null;
  }
  
  /// Salvar um post
  Future<void> savePost(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    await _client.from('saved_posts').insert({
      'user_id': userId,
      'post_id': postId,
    });
  }
  
  /// Remover um post dos salvos
  Future<void> unsavePost(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    await _client
        .from('saved_posts')
        .delete()
        .eq('user_id', userId)
        .eq('post_id', postId);
  }
  
  /// Verificar se o post está salvo pelo usuário atual
  Future<bool> isPostSaved(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    
    final response = await _client
        .from('saved_posts')
        .select()
        .eq('user_id', userId)
        .eq('post_id', postId)
        .maybeSingle();
    
    return response != null;
  }
  
  /// Obter posts salvos pelo usuário atual
  Future<List<PostModel>> getSavedPosts() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    final response = await _client
        .from('saved_posts')
        .select('posts(*, users(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    
    return (response as List).map((item) {
      final post = item['posts'];
      final userData = post['users'];
      post['user'] = userData;
      return PostModel.fromJson(post);
    }).toList();
  }
  
  /// Atualizar contador de likes de um post
  Future<void> _updatePostLikesCount(String postId) async {
    // Contar likes
    final likesResponse = await _client
        .from('likes')
        .select()
        .eq('post_id', postId);
    final likesCount = likesResponse.length;
    
    // Atualizar contador no post
    await _client.from('posts').update({
      'likes_count': likesCount,
    }).eq('id', postId);
  }
  
  /// Atualizar contador de comentários de um post
  Future<void> updatePostCommentsCount(String postId) async {
    // Contar comentários
    final commentsResponse = await _client
        .from('comments')
        .select()
        .eq('post_id', postId);
    final commentsCount = commentsResponse.length;
    
    // Atualizar contador no post
    await _client.from('posts').update({
      'comments_count': commentsCount,
    }).eq('id', postId);
  }
}
