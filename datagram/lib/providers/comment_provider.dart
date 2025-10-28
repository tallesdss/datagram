import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../services/services.dart';

// Provider para comentários de um post específico
final commentsByPostProvider = FutureProvider.family<List<CommentModel>, String>((ref, postId) async {
  final commentService = CommentService();
  return await commentService.getCommentsByPost(postId);
});

// Provider para comentários ordenados por timestamp
final sortedCommentsProvider = FutureProvider.family<List<CommentModel>, String>((ref, postId) async {
  final comments = await ref.watch(commentsByPostProvider(postId).future);
  final sortedComments = List<CommentModel>.from(comments);
  sortedComments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sortedComments;
});

// Provider para comentários curtidos pelo usuário atual
final likedCommentsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Como não há método getAllComments, vamos usar uma implementação temporária
  return [];
});

// Provider para comentários de um usuário específico
final commentsByUserProvider = FutureProvider.family<List<CommentModel>, String>((ref, userId) async {
  // Implementação temporária
  return [];
});

// Provider para comentários recentes (últimas 24 horas)
final recentCommentModelsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para comentários com mais curtidas
final topLikedCommentModelsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para comentários de hoje
final todayCommentModelsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para comentários de ontem
final yesterdayCommentModelsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para estatísticas de comentários
final commentStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  // Implementação temporária
  return {
    'total': 0,
    'liked': 0,
    'recent': 0,
    'today': 0,
  };
});

// Provider para comentários por período
final commentsByPeriodProvider = FutureProvider.family<List<CommentModel>, String>((ref, period) async {
  // Implementação temporária
  return [];
});

// Provider para busca de comentários
final searchCommentsProvider = FutureProvider.family<List<CommentModel>, String>((ref, query) async {
  // Implementação temporária
  return [];
});

// Provider para comentários com menções
final commentsWithMentionsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para comentários com hashtags
final commentsWithHashtagsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para comentários do usuário atual
final currentUserCommentModelsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});

// Provider para comentários em posts do usuário atual
final commentsOnCurrentUserPostsProvider = FutureProvider<List<CommentModel>>((ref) async {
  // Implementação temporária
  return [];
});