import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';
import 'supabase_service.dart';
import 'post_service.dart';

/// Serviço para gerenciar operações relacionadas a comentários
class CommentService {
  final SupabaseClient _client = SupabaseService().client;
  final PostService _postService = PostService();
  
  /// Criar um novo comentário
  Future<String> createComment({
    required String postId,
    required String text,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Inserir o comentário
    final response = await _client.from('comments').insert({
      'post_id': postId,
      'user_id': userId,
      'text': text,
      'created_at': DateTime.now().toIso8601String(),
    }).select('id').single();
    
    // Atualizar contador de comentários do post
    await _postService.updatePostCommentsCount(postId);
    
    return response['id'];
  }
  
  /// Obter comentários de um post
  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    final response = await _client
        .from('comments')
        .select('*, users(*)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);
    
    return (response as List).map((comment) {
      final userData = comment['users'];
      comment['user'] = userData;
      return CommentModel.fromJson(comment);
    }).toList();
  }
  
  /// Deletar um comentário
  Future<void> deleteComment(String commentId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Obter o comentário para verificar permissão
    final comment = await _client
        .from('comments')
        .select('user_id, post_id')
        .eq('id', commentId)
        .maybeSingle();
    
    if (comment == null) throw Exception('Comentário não encontrado');
    
    // Verificar se o usuário é o autor do comentário
    if (comment['user_id'] != userId) {
      throw Exception('Você não tem permissão para deletar este comentário');
    }
    
    // Deletar o comentário
    await _client.from('comments').delete().eq('id', commentId);
    
    // Atualizar contador de comentários do post
    await _postService.updatePostCommentsCount(comment['post_id']);
  }
  
  /// Curtir um comentário
  Future<void> likeComment(String commentId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Adicionar o like
    await _client.from('likes').insert({
      'user_id': userId,
      'comment_id': commentId,
    });
    
    // Atualizar contador de likes
    await _updateCommentLikesCount(commentId);
  }
  
  /// Descurtir um comentário
  Future<void> unlikeComment(String commentId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Remover o like
    await _client
        .from('likes')
        .delete()
        .eq('user_id', userId)
        .eq('comment_id', commentId);
    
    // Atualizar contador de likes
    await _updateCommentLikesCount(commentId);
  }
  
  /// Verificar se o usuário atual curtiu o comentário
  Future<bool> isCommentLiked(String commentId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    
    final response = await _client
        .from('likes')
        .select()
        .eq('user_id', userId)
        .eq('comment_id', commentId)
        .maybeSingle();
    
    return response != null;
  }
  
  /// Atualizar contador de likes de um comentário
  Future<void> _updateCommentLikesCount(String commentId) async {
    // Contar likes
    final likesResponse = await _client
        .from('likes')
        .select()
        .eq('comment_id', commentId);
    final likesCount = likesResponse.length;
    
    // Atualizar contador no comentário
    await _client.from('comments').update({
      'likes_count': likesCount,
    }).eq('id', commentId);
  }
}
