// Exporta todos os providers do sistema
export 'user_provider.dart';
export 'post_provider.dart' hide commentsByPostProvider;
export 'story_provider.dart';
export 'comment_provider.dart' hide sortedCommentsProvider;
export 'auth_provider.dart';

// Providers principais para uso geral
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_provider.dart';
import 'story_provider.dart';
import 'auth_provider.dart';

// Provider para o estado geral da aplicação
final appStateProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authState = ref.watch(authProvider);
  final currentUser = authState.userProfile;
  final posts = await ref.watch(postsProvider.future);
  final stories = await ref.watch(storiesProvider.future);
  
  return {
    'currentUser': currentUser,
    'postsCount': posts.length,
    'storiesCount': stories.length,
    'commentsCount': 0, // Implementação temporária
    'isLoading': authState.isLoading,
    'isAuthenticated': authState.isAuthenticated,
    'lastUpdated': DateTime.now(),
  };
});

// Provider para notificações (simulado)
final notificationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': 'notif_1',
      'type': 'like',
      'message': 'Ana Silva curtiu sua foto',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'isRead': false,
    },
    {
      'id': 'notif_2',
      'type': 'comment',
      'message': 'Carlos Santos comentou em sua foto',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
    },
    {
      'id': 'notif_3',
      'type': 'follow',
      'message': 'Maria Oliveira começou a te seguir',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'isRead': true,
    },
    {
      'id': 'notif_4',
      'type': 'story',
      'message': 'João Costa postou um story',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
    },
  ];
});

// Provider para notificações não lidas
final unreadNotificationsProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((notif) => !notif['isRead']).length;
});

// Provider para configurações da aplicação
final appSettingsProvider = Provider<Map<String, dynamic>>((ref) {
  return {
    'theme': 'light',
    'language': 'pt',
    'notifications': true,
    'autoPlay': true,
    'dataSaver': false,
    'darkMode': false,
  };
});

// Provider para estatísticas gerais
final generalStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final posts = await ref.watch(postsProvider.future);
  final stories = await ref.watch(storiesProvider.future);
  
  return {
    'totalPosts': posts.length,
    'totalStories': stories.length,
    'totalComments': 0, // Implementação temporária
    'totalUsers': 0, // Implementação temporária
    'totalLikes': posts.fold(0, (sum, post) => sum + post.likesCount),
    'totalViews': stories.where((story) => story.isViewed).length,
  };
});

// Provider para dados do feed principal
final mainFeedProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final posts = await ref.watch(sortedPostsProvider.future);
  final stories = await ref.watch(sortedStoriesProvider.future);
  final authState = ref.watch(authProvider);
  final currentUser = authState.userProfile;
  
  return {
    'posts': posts.take(20).toList(),
    'stories': stories.take(10).toList(),
    'currentUser': currentUser,
    'hasMorePosts': posts.length > 20,
    'hasMoreStories': stories.length > 10,
    'isAuthenticated': authState.isAuthenticated,
  };
});

// Provider para busca global
final globalSearchProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, query) async {
  if (query.isEmpty) return [];
  
  final posts = await ref.watch(postsProvider.future);
  
  final results = <Map<String, dynamic>>[];
  
  // Buscar posts
  final matchingPosts = posts.where((post) {
    return post.caption.toLowerCase().contains(query.toLowerCase()) ||
           post.user.username.toLowerCase().contains(query.toLowerCase()) ||
           post.user.fullName.toLowerCase().contains(query.toLowerCase()) ||
           (post.location?.toLowerCase().contains(query.toLowerCase()) ?? false);
  }).toList();
  
  for (final post in matchingPosts) {
    results.add({
      'type': 'post',
      'data': post,
      'relevance': _calculateRelevance(post.caption, query),
    });
  }
  
  // Ordenar por relevância
  results.sort((a, b) => b['relevance'].compareTo(a['relevance']));
  
  return results.take(20).toList();
});

// Função auxiliar para calcular relevância da busca
double _calculateRelevance(String text, String query) {
  final textLower = text.toLowerCase();
  final queryLower = query.toLowerCase();
  
  if (textLower == queryLower) return 1.0;
  if (textLower.startsWith(queryLower)) return 0.8;
  if (textLower.contains(queryLower)) return 0.6;
  return 0.0;
}