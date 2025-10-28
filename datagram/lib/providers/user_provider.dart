import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';

// Provider para o usuário atual
final currentUserProvider = Provider<User>((ref) {
  return MockData.getCurrentUser();
});

// Provider para todos os usuários
final usersProvider = Provider<List<User>>((ref) {
  return MockData.users;
});

// Provider para usuários aleatórios
final randomUsersProvider = Provider.family<List<User>, int>((ref, count) {
  return MockData.getRandomUsers(count: count);
});

// Provider para buscar usuário por ID
final userByIdProvider = Provider.family<User?, String>((ref, id) {
  return MockData.getUserById(id);
});

// Provider para usuários seguidos pelo usuário atual
final followingUsersProvider = Provider<List<User>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final allUsers = ref.watch(usersProvider);
  
  // Simula usuários seguidos (excluindo o usuário atual)
  return allUsers
      .where((user) => user.id != currentUser.id)
      .take(5)
      .toList();
});

// Provider para usuários sugeridos para seguir
final suggestedUsersProvider = Provider<List<User>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final allUsers = ref.watch(usersProvider);
  
  // Simula usuários sugeridos (excluindo o usuário atual e seguidos)
  return allUsers
      .where((user) => user.id != currentUser.id)
      .skip(5)
      .take(3)
      .toList();
});

// Provider para estatísticas do usuário atual
final userStatsProvider = Provider<Map<String, int>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  
  return {
    'posts': currentUser.postsCount,
    'followers': currentUser.followersCount,
    'following': currentUser.followingCount,
  };
});

// Provider para verificar se um usuário está sendo seguido
final isFollowingProvider = Provider.family<bool, String>((ref, userId) {
  final currentUser = ref.watch(currentUserProvider);
  final followingUsers = ref.watch(followingUsersProvider);
  
  if (userId == currentUser.id) return false;
  
  return followingUsers.any((user) => user.id == userId);
});

// Provider para o perfil de um usuário específico
final userProfileProvider = Provider.family<User?, String>((ref, userId) {
  return ref.watch(userByIdProvider(userId));
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
