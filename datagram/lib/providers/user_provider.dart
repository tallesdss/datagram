import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../data/mock_data.dart';

// Provider para o usuário atual
final currentUserModelProvider = Provider<UserModel>((ref) {
  return MockData.getCurrentUserModel();
});

// Provider para todos os usuários
final usersProvider = Provider<List<UserModel>>((ref) {
  return MockData.users;
});

// Provider para usuários aleatórios
final randomUserModelsProvider = Provider.family<List<UserModel>, int>((ref, count) {
  return MockData.getRandomUserModels(count: count);
});

// Provider para buscar usuário por ID
final userByIdProvider = Provider.family<UserModel?, String>((ref, id) {
  return MockData.getUserModelById(id);
});

// Provider para usuários seguidos pelo usuário atual
final followingUserModelsProvider = Provider<List<UserModel>>((ref) {
  final currentUserModel = ref.watch(currentUserModelProvider);
  final allUserModels = ref.watch(usersProvider);
  
  // Simula usuários seguidos (excluindo o usuário atual)
  return allUserModels
      .where((user) => user.id != currentUserModel.id)
      .take(5)
      .toList();
});

// Provider para usuários sugeridos para seguir
final suggestedUserModelsProvider = Provider<List<UserModel>>((ref) {
  final currentUserModel = ref.watch(currentUserModelProvider);
  final allUserModels = ref.watch(usersProvider);
  
  // Simula usuários sugeridos (excluindo o usuário atual e seguidos)
  return allUserModels
      .where((user) => user.id != currentUserModel.id)
      .skip(5)
      .take(3)
      .toList();
});

// Provider para estatísticas do usuário atual
final userStatsProvider = Provider<Map<String, int>>((ref) {
  final currentUserModel = ref.watch(currentUserModelProvider);
  
  return {
    'posts': currentUserModel.postsCount,
    'followers': currentUserModel.followersCount,
    'following': currentUserModel.followingCount,
  };
});

// Provider para verificar se um usuário está sendo seguido
final isFollowingProvider = Provider.family<bool, String>((ref, userId) {
  final currentUserModel = ref.watch(currentUserModelProvider);
  final followingUserModels = ref.watch(followingUserModelsProvider);
  
  if (userId == currentUserModel.id) return false;
  
  return followingUserModels.any((user) => user.id == userId);
});

// Provider para o perfil de um usuário específico
final userProfileProvider = Provider.family<UserModel?, String>((ref, userId) {
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
