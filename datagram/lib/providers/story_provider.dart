import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_model.dart';
import '../data/mock_data.dart';

// Provider para todos os stories
final storiesProvider = Provider<List<Story>>((ref) {
  return MockData.getStories();
});

// Provider para stories ordenados por timestamp (mais recentes primeiro)
final sortedStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storiesProvider);
  final sortedStories = List<Story>.from(stories);
  sortedStories.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return sortedStories;
});

// Provider para stories não visualizados
final unviewedStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storiesProvider);
  return stories.where((story) => !story.isViewed).toList();
});

// Provider para stories visualizados
final viewedStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storiesProvider);
  return stories.where((story) => story.isViewed).toList();
});

// Provider para stories de um usuário específico
final storiesByUserProvider = Provider.family<List<Story>, String>((ref, userId) {
  return MockData.getStoriesByUser(userId);
});

// Provider para um story específico por ID
final storyByIdProvider = Provider.family<Story?, String>((ref, id) {
  return MockData.getStoryById(id);
});

// Provider para stories recentes (últimas 24 horas)
final recentStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storiesProvider);
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  
  return stories.where((story) => story.timestamp.isAfter(yesterday)).toList();
});

// Provider para stories agrupados por usuário
final storiesGroupedByUserProvider = Provider<Map<String, List<Story>>>((ref) {
  final stories = ref.watch(sortedStoriesProvider);
  final Map<String, List<Story>> grouped = {};
  
  for (final story in stories) {
    if (!grouped.containsKey(story.userId)) {
      grouped[story.userId] = [];
    }
    grouped[story.userId]!.add(story);
  }
  
  return grouped;
});

// Provider para usuários com stories não visualizados
final usersWithUnviewedStoriesProvider = Provider<List<String>>((ref) {
  final unviewedStories = ref.watch(unviewedStoriesProvider);
  return unviewedStories.map((story) => story.userId).toSet().toList();
});

// Provider para usuários com stories visualizados
final usersWithViewedStoriesProvider = Provider<List<String>>((ref) {
  final viewedStories = ref.watch(viewedStoriesProvider);
  return viewedStories.map((story) => story.userId).toSet().toList();
});

// Provider para stories do usuário atual
final currentUserStoriesProvider = Provider<List<Story>>((ref) {
  // Este provider será conectado com o UserProvider quando integrarmos
  final stories = ref.watch(storiesProvider);
  return stories.where((story) => story.userId == 'current_user').toList();
});

// Provider para stories de usuários seguidos
final followingUsersStoriesProvider = Provider<List<Story>>((ref) {
  // Este provider será conectado com o UserProvider quando integrarmos
  final stories = ref.watch(storiesProvider);
  // Por enquanto, retorna todos os stories exceto do usuário atual
  return stories.where((story) => story.userId != 'current_user').toList();
});

// Provider para stories com duração específica
final storiesByDurationProvider = Provider.family<List<Story>, Duration>((ref, duration) {
  final stories = ref.watch(storiesProvider);
  return stories.where((story) => story.duration == duration).toList();
});

// Provider para stories de hoje
final todayStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storiesProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  
  return stories.where((story) {
    return story.timestamp.isAfter(today) && story.timestamp.isBefore(tomorrow);
  }).toList();
});

// Provider para stories de ontem
final yesterdayStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storiesProvider);
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final today = DateTime(now.year, now.month, now.day);
  
  return stories.where((story) {
    return story.timestamp.isAfter(yesterday) && story.timestamp.isBefore(today);
  }).toList();
});

// Provider para estatísticas de stories
final storyStatsProvider = Provider<Map<String, int>>((ref) {
  final stories = ref.watch(storiesProvider);
  final unviewed = ref.watch(unviewedStoriesProvider);
  final viewed = ref.watch(viewedStoriesProvider);
  
  return {
    'total': stories.length,
    'unviewed': unviewed.length,
    'viewed': viewed.length,
    'today': ref.watch(todayStoriesProvider).length,
  };
});

// Provider para stories por período
final storiesByPeriodProvider = Provider.family<List<Story>, String>((ref, period) {
  switch (period.toLowerCase()) {
    case 'today':
      return ref.watch(todayStoriesProvider);
    case 'yesterday':
      return ref.watch(yesterdayStoriesProvider);
    case 'recent':
      return ref.watch(recentStoriesProvider);
    default:
      return ref.watch(sortedStoriesProvider);
  }
});
