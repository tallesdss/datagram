import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/services.dart';

// Provider para lista de usuários (simulado para mensagens)
final usersProvider = Provider<List<UserModel>>((ref) {
  // Lista simulada de usuários para demonstração
  return [
    UserModel(
      id: 'user_1',
      username: 'ana_silva',
      fullName: 'Ana Silva',
      bio: 'Desenvolvedora Flutter',
      profileImageUrl: 'https://via.placeholder.com/150',
      postsCount: 15,
      followersCount: 120,
      followingCount: 80,
      isVerified: false,
      isPrivate: false,
    ),
    UserModel(
      id: 'user_2',
      username: 'carlos_santos',
      fullName: 'Carlos Santos',
      bio: 'Designer UI/UX',
      profileImageUrl: 'https://via.placeholder.com/150',
      postsCount: 8,
      followersCount: 200,
      followingCount: 150,
      isVerified: true,
      isPrivate: false,
    ),
    UserModel(
      id: 'user_3',
      username: 'maria_oliveira',
      fullName: 'Maria Oliveira',
      bio: 'Fotógrafa',
      profileImageUrl: 'https://via.placeholder.com/150',
      postsCount: 25,
      followersCount: 500,
      followingCount: 300,
      isVerified: false,
      isPrivate: false,
    ),
    UserModel(
      id: 'user_4',
      username: 'joao_costa',
      fullName: 'João Costa',
      bio: 'Músico',
      profileImageUrl: 'https://via.placeholder.com/150',
      postsCount: 12,
      followersCount: 80,
      followingCount: 60,
      isVerified: false,
      isPrivate: true,
    ),
    UserModel(
      id: 'user_5',
      username: 'lucia_fernandes',
      fullName: 'Lúcia Fernandes',
      bio: 'Artista Digital',
      profileImageUrl: 'https://via.placeholder.com/150',
      postsCount: 30,
      followersCount: 1000,
      followingCount: 200,
      isVerified: true,
      isPrivate: false,
    ),
  ];
});

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