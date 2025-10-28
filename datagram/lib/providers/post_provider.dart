import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../data/mock_data.dart';

// Provider para todos os posts
final postsProvider = Provider<List<Post>>((ref) {
  return MockData.getPosts();
});

// Provider para posts ordenados por timestamp (mais recentes primeiro)
final sortedPostsProvider = Provider<List<Post>>((ref) {
  final posts = ref.watch(postsProvider);
  final sortedPosts = List<Post>.from(posts);
  sortedPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return sortedPosts;
});

// Provider para posts salvos pelo usuário atual
final savedPostsProvider = Provider<List<Post>>((ref) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.isSaved).toList();
});

// Provider para posts curtidos pelo usuário atual
final likedPostsProvider = Provider<List<Post>>((ref) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.isLiked).toList();
});

// Provider para posts de um usuário específico
final postsByUserProvider = Provider.family<List<Post>, String>((ref, userId) {
  return MockData.getPostsByUser(userId);
});

// Provider para um post específico por ID
final postByIdProvider = Provider.family<Post?, String>((ref, id) {
  return MockData.getPostById(id);
});

// Provider para comentários de um post específico
final commentsByPostProvider = Provider.family<List<Comment>, String>((ref, postId) {
  return MockData.getCommentsByPost(postId);
});

// Provider para comentários ordenados por timestamp
final sortedCommentsProvider = Provider.family<List<Comment>, String>((ref, postId) {
  final comments = ref.watch(commentsByPostProvider(postId));
  final sortedComments = List<Comment>.from(comments);
  sortedComments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sortedComments;
});

// Provider para estatísticas de um post
final postStatsProvider = Provider.family<Map<String, int>, String>((ref, postId) {
  final post = ref.watch(postByIdProvider(postId));
  if (post == null) return {'likes': 0, 'comments': 0};
  
  return {
    'likes': post.likesCount,
    'comments': post.commentsCount,
  };
});

// Provider para verificar se um post está curtido
final isPostLikedProvider = Provider.family<bool, String>((ref, postId) {
  final post = ref.watch(postByIdProvider(postId));
  return post?.isLiked ?? false;
});

// Provider para verificar se um post está salvo
final isPostSavedProvider = Provider.family<bool, String>((ref, postId) {
  final post = ref.watch(postByIdProvider(postId));
  return post?.isSaved ?? false;
});

// Provider para posts com mais curtidas
final topLikedPostsProvider = Provider<List<Post>>((ref) {
  final posts = ref.watch(postsProvider);
  final sortedPosts = List<Post>.from(posts);
  sortedPosts.sort((a, b) => b.likesCount.compareTo(a.likesCount));
  return sortedPosts.take(5).toList();
});

// Provider para posts recentes (últimas 24 horas)
final recentPostsProvider = Provider<List<Post>>((ref) {
  final posts = ref.watch(postsProvider);
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  
  return posts.where((post) => post.timestamp.isAfter(yesterday)).toList();
});

// Provider para posts por localização
final postsByLocationProvider = Provider.family<List<Post>, String>((ref, location) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.location?.contains(location) ?? false).toList();
});

// Provider para posts com hashtags específicas
final postsByHashtagProvider = Provider.family<List<Post>, String>((ref, hashtag) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.caption.contains('#$hashtag')).toList();
});

// Provider para feed personalizado (posts dos usuários seguidos)
final personalizedFeedProvider = Provider<List<Post>>((ref) {
  // Este provider será conectado com o UserProvider quando integrarmos
  final posts = ref.watch(sortedPostsProvider);
  return posts.take(10).toList(); // Por enquanto, retorna os 10 posts mais recentes
});

// Provider para busca de posts
final searchPostsProvider = Provider.family<List<Post>, String>((ref, query) {
  final posts = ref.watch(postsProvider);
  if (query.isEmpty) return [];
  
  return posts.where((post) {
    return post.caption.toLowerCase().contains(query.toLowerCase()) ||
           post.user.username.toLowerCase().contains(query.toLowerCase()) ||
           post.user.fullName.toLowerCase().contains(query.toLowerCase()) ||
           (post.location?.toLowerCase().contains(query.toLowerCase()) ?? false);
  }).toList();
});
