import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../data/mock_data.dart';

// Provider para todos os comentários
final commentsProvider = Provider<List<CommentModel>>((ref) {
  return MockData.getComments();
});

// Provider para comentários ordenados por timestamp (mais recentes primeiro)
final sortedCommentsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  final sortedComments = List<CommentModel>.from(comments);
  sortedComments.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return sortedComments;
});

// Provider para comentários de um post específico
final commentsByPostProvider = Provider.family<List<CommentModel>, String>((ref, postId) {
  return MockData.getCommentsByPostModel(postId);
});

// Provider para comentários de um post ordenados por timestamp
final sortedCommentsByPostProvider = Provider.family<List<CommentModel>, String>((ref, postId) {
  final comments = ref.watch(commentsByPostProvider(postId));
  final sortedComments = List<CommentModel>.from(comments);
  sortedComments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sortedComments;
});

// Provider para um comentário específico por ID
final commentByIdProvider = Provider.family<CommentModel?, String>((ref, id) {
  return MockData.getCommentById(id);
});

// Provider para comentários curtidos pelo usuário atual
final likedCommentsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  return comments.where((comment) => comment.isLiked).toList();
});

// Provider para comentários de um usuário específico
final commentsByUserProvider = Provider.family<List<CommentModel>, String>((ref, userId) {
  final comments = ref.watch(commentsProvider);
  return comments.where((comment) => comment.userId == userId).toList();
});

// Provider para comentários recentes (últimas 24 horas)
final recentCommentModelsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  
  return comments.where((comment) => comment.timestamp.isAfter(yesterday)).toList();
});

// Provider para comentários com mais curtidas
final topLikedCommentModelsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  final sortedCommentModels = List<CommentModel>.from(comments);
  sortedCommentModels.sort((a, b) => b.likesCount.compareTo(a.likesCount));
  return sortedCommentModels.take(10).toList();
});

// Provider para comentários de hoje
final todayCommentModelsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  
  return comments.where((comment) {
    return comment.timestamp.isAfter(today) && comment.timestamp.isBefore(tomorrow);
  }).toList();
});

// Provider para comentários de ontem
final yesterdayCommentModelsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final today = DateTime(now.year, now.month, now.day);
  
  return comments.where((comment) {
    return comment.timestamp.isAfter(yesterday) && comment.timestamp.isBefore(today);
  }).toList();
});

// Provider para estatísticas de comentários
final commentStatsProvider = Provider<Map<String, int>>((ref) {
  final comments = ref.watch(commentsProvider);
  final liked = ref.watch(likedCommentsProvider);
  final recent = ref.watch(sortedCommentsProvider);
  final today = ref.watch(sortedCommentsProvider);
  
  return {
    'total': comments.length,
    'liked': liked.length,
    'recent': recent.length,
    'today': today.length,
  };
});

// Provider para comentários por período
final commentsByPeriodProvider = Provider.family<List<CommentModel>, String>((ref, period) {
  switch (period.toLowerCase()) {
    case 'today':
      return ref.watch(sortedCommentsProvider);
    case 'yesterday':
      return ref.watch(sortedCommentsProvider);
    case 'recent':
      return ref.watch(sortedCommentsProvider);
    case 'top':
      return ref.watch(topLikedCommentModelsProvider);
    default:
      return ref.watch(sortedCommentsProvider);
  }
});

// Provider para busca de comentários
final searchCommentsProvider = Provider.family<List<CommentModel>, String>((ref, query) {
  final comments = ref.watch(commentsProvider);
  if (query.isEmpty) return [];
  
  return comments.where((comment) {
    return comment.text.toLowerCase().contains(query.toLowerCase()) ||
           comment.user.username.toLowerCase().contains(query.toLowerCase()) ||
           comment.user.fullName.toLowerCase().contains(query.toLowerCase());
  }).toList();
});

// Provider para comentários com menções
final commentsWithMentionsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  return comments.where((comment) => comment.text.contains('@')).toList();
});

// Provider para comentários com hashtags
final commentsWithHashtagsProvider = Provider<List<CommentModel>>((ref) {
  final comments = ref.watch(commentsProvider);
  return comments.where((comment) => comment.text.contains('#')).toList();
});

// Provider para comentários do usuário atual
final currentUserCommentModelsProvider = Provider<List<CommentModel>>((ref) {
  // Este provider será conectado com o UserProvider quando integrarmos
  final comments = ref.watch(commentsProvider);
  return comments.where((comment) => comment.userId == 'current_user').toList();
});

// Provider para comentários em posts do usuário atual
final commentsOnCurrentUserPostsProvider = Provider<List<CommentModel>>((ref) {
  // Este provider será conectado com o PostProvider quando integrarmos
  final comments = ref.watch(commentsProvider);
  // Por enquanto, retorna comentários de alguns posts específicos
  return comments.where((comment) => 
    comment.postId == 'post_1' || 
    comment.postId == 'post_2' || 
    comment.postId == 'post_3'
  ).toList();
});
