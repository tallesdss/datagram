import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

/// Serviço para gerenciar operações relacionadas a usuários
class UserService {
  final SupabaseClient _client = SupabaseService().client;
  
  /// Obter usuário pelo ID
  Future<UserModel?> getUser(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
    
    if (response == null) return null;
    
    return UserModel.fromJson(response);
  }
  
  /// Obter usuário pelo username
  Future<UserModel?> getUserByUsername(String username) async {
    final response = await _client
        .from('users')
        .select()
        .eq('username', username)
        .maybeSingle();
    
    if (response == null) return null;
    
    return UserModel.fromJson(response);
  }
  
  /// Buscar usuários por query (nome ou username)
  Future<List<UserModel>> searchUsers(String query) async {
    final response = await _client
        .from('users')
        .select()
        .or('username.ilike.%$query%,full_name.ilike.%$query%')
        .limit(20);
    
    return (response as List).map((user) => UserModel.fromJson(user)).toList();
  }
  
  /// Seguir um usuário
  Future<void> followUser(String userId) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) throw Exception('Usuário não autenticado');
    
    await _client.from('follows').insert({
      'follower_id': currentUserId,
      'following_id': userId,
    });
    
    // Atualizar contadores
    await updateUserStats(userId);
    await updateUserStats(currentUserId);
  }
  
  /// Deixar de seguir um usuário
  Future<void> unfollowUser(String userId) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) throw Exception('Usuário não autenticado');
    
    await _client
        .from('follows')
        .delete()
        .eq('follower_id', currentUserId)
        .eq('following_id', userId);
    
    // Atualizar contadores
    await updateUserStats(userId);
    await updateUserStats(currentUserId);
  }
  
  /// Obter seguidores de um usuário
  Future<List<UserModel>> getFollowers(String userId) async {
    final response = await _client
        .from('follows')
        .select('users!follower_id(*)')
        .eq('following_id', userId);
    
    return (response as List)
        .map((item) => UserModel.fromJson(item['users']))
        .toList();
  }
  
  /// Obter quem um usuário segue
  Future<List<UserModel>> getFollowing(String userId) async {
    final response = await _client
        .from('follows')
        .select('users!following_id(*)')
        .eq('follower_id', userId);
    
    return (response as List)
        .map((item) => UserModel.fromJson(item['users']))
        .toList();
  }
  
  /// Verificar se o usuário atual segue outro usuário
  Future<bool> isFollowing(String userId) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return false;
    
    final response = await _client
        .from('follows')
        .select()
        .eq('follower_id', currentUserId)
        .eq('following_id', userId)
        .maybeSingle();
    
    return response != null;
  }
  
  /// Atualizar estatísticas do usuário (contadores)
  Future<void> updateUserStats(String userId) async {
    // Contar posts
    final postsResponse = await _client
        .from('posts')
        .select()
        .eq('user_id', userId);
    final postsCount = postsResponse.length;
    
    // Contar seguidores
    final followersResponse = await _client
        .from('follows')
        .select()
        .eq('following_id', userId);
    final followersCount = followersResponse.length;
    
    // Contar seguindo
    final followingResponse = await _client
        .from('follows')
        .select()
        .eq('follower_id', userId);
    final followingCount = followingResponse.length;
    
    // Atualizar contadores no perfil do usuário
    await _client.from('users').update({
      'posts_count': postsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
    }).eq('id', userId);
  }
}
