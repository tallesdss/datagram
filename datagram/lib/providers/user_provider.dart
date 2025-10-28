import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/services.dart';

// Provider para o usuário atual
final currentUserModelProvider = FutureProvider<UserModel>((ref) async {
  final userService = UserService();
  final currentUserId = SupabaseService().client.auth.currentUser?.id;
  if (currentUserId == null) throw Exception('Usuário não autenticado');
  final user = await userService.getUser(currentUserId);
  if (user == null) throw Exception('Usuário não encontrado');
  return user;
});

// Provider para buscar usuário por ID
final userByIdProvider = FutureProvider.family<UserModel?, String>((ref, id) async {
  final userService = UserService();
  return await userService.getUser(id);
});

// Provider para usuários seguidos pelo usuário atual
final followingUserModelsProvider = FutureProvider<List<UserModel>>((ref) async {
  final currentUserModel = await ref.watch(currentUserModelProvider.future);
  final userService = UserService();
  return await userService.getFollowing(currentUserModel.id);
});

// Provider para usuários sugeridos para seguir
final suggestedUserModelsProvider = FutureProvider<List<UserModel>>((ref) async {
  final currentUserModel = await ref.watch(currentUserModelProvider.future);
  final userService = UserService();
  // Por enquanto, retorna usuários aleatórios excluindo o atual
  final allUsers = await userService.searchUsers('');
  return allUsers.where((user) => user.id != currentUserModel.id).take(3).toList();
});

// Provider para estatísticas do usuário atual
final userStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final currentUserModel = await ref.watch(currentUserModelProvider.future);
  
  return {
    'posts': currentUserModel.postsCount,
    'followers': currentUserModel.followersCount,
    'following': currentUserModel.followingCount,
  };
});

// Provider para verificar se um usuário está sendo seguido
final isFollowingProvider = FutureProvider.family<bool, String>((ref, userId) async {
  final currentUserModel = await ref.watch(currentUserModelProvider.future);
  final userService = UserService();
  
  if (userId == currentUserModel.id) return false;
  
  return await userService.isFollowing(userId);
});

// Provider para o perfil de um usuário específico
final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  final userService = UserService();
  return await userService.getUser(userId);
});

// Provider para posts de um usuário específico
final userPostsProvider = Provider.family<List<dynamic>, String>((ref, userId) {
  // Este provider será conectado com o PostProvider quando criarmos
  return [];
});

// Provider para stories de um usuário específico
final userStoriesProvider = Provider.family<List<dynamic>, String>((ref, userId) {
  // Este provider será conectado com o StoryProvider quando criarmos
  return [];
});