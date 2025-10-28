import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_model.dart';
import '../services/services.dart';

// Provider para todos os stories
final storiesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final storyService = StoryService();
  return await storyService.getStories();
});

// Provider para stories ordenados por timestamp (mais recentes primeiro)
final sortedStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  final sortedStories = List<StoryModel>.from(stories);
  sortedStories.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return sortedStories;
});

// Provider para stories não visualizados
final unviewedStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  return stories.where((story) => !story.isViewed).toList();
});

// Provider para stories visualizados
final viewedStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  return stories.where((story) => story.isViewed).toList();
});

// Provider para stories de um usuário específico
final storiesByUserProvider = FutureProvider.family<List<StoryModel>, String>((ref, userId) async {
  final storyService = StoryService();
  return await storyService.getStoriesByUser(userId);
});

// Provider para um story específico por ID
final storyByIdProvider = FutureProvider.family<StoryModel?, String>((ref, id) async {
  final stories = await ref.watch(storiesProvider.future);
  try {
    return stories.firstWhere((story) => story.id == id);
  } catch (e) {
    return null;
  }
});

// Provider para stories recentes (últimas 24 horas)
final recentStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  
  return stories.where((story) => story.timestamp.isAfter(yesterday)).toList();
});

// Provider para stories agrupados por usuário
final storiesGroupedByUserProvider = FutureProvider<Map<String, List<StoryModel>>>((ref) async {
  final stories = await ref.watch(sortedStoriesProvider.future);
  final Map<String, List<StoryModel>> grouped = {};
  
  for (final story in stories) {
    if (!grouped.containsKey(story.userId)) {
      grouped[story.userId] = [];
    }
    grouped[story.userId]!.add(story);
  }
  
  return grouped;
});

// Provider para usuários com stories não visualizados
final usersWithUnviewedStoriesProvider = FutureProvider<List<String>>((ref) async {
  final unviewedStories = await ref.watch(unviewedStoriesProvider.future);
  return unviewedStories.map((story) => story.userId).toSet().toList();
});

// Provider para usuários com stories visualizados
final usersWithViewedStoriesProvider = FutureProvider<List<String>>((ref) async {
  final viewedStories = await ref.watch(viewedStoriesProvider.future);
  return viewedStories.map((story) => story.userId).toSet().toList();
});

// Provider para stories do usuário atual
final currentUserStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  // Este provider será conectado com o UserProvider quando integrarmos
  final stories = await ref.watch(storiesProvider.future);
  final currentUserId = SupabaseService().client.auth.currentUser?.id;
  if (currentUserId == null) return [];
  return stories.where((story) => story.userId == currentUserId).toList();
});

// Provider para stories de usuários seguidos
final followingUsersStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  // Este provider será conectado com o UserProvider quando integrarmos
  final stories = await ref.watch(storiesProvider.future);
  final currentUserId = SupabaseService().client.auth.currentUser?.id;
  if (currentUserId == null) return [];
  // Por enquanto, retorna todos os stories exceto do usuário atual
  return stories.where((story) => story.userId != currentUserId).toList();
});

// Provider para stories com duração específica
final storiesByDurationProvider = FutureProvider.family<List<StoryModel>, Duration>((ref, duration) async {
  final stories = await ref.watch(storiesProvider.future);
  return stories.where((story) => story.duration == duration).toList();
});

// Provider para stories de hoje
final todayStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  
  return stories.where((story) {
    return story.timestamp.isAfter(today) && story.timestamp.isBefore(tomorrow);
  }).toList();
});

// Provider para stories de ontem
final yesterdayStoriesProvider = FutureProvider<List<StoryModel>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  final now = DateTime.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final today = DateTime(now.year, now.month, now.day);
  
  return stories.where((story) {
    return story.timestamp.isAfter(yesterday) && story.timestamp.isBefore(today);
  }).toList();
});

// Provider para estatísticas de stories
final storyStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final stories = await ref.watch(storiesProvider.future);
  final unviewed = await ref.watch(unviewedStoriesProvider.future);
  final viewed = await ref.watch(viewedStoriesProvider.future);
  final today = await ref.watch(todayStoriesProvider.future);
  
  return {
    'total': stories.length,
    'unviewed': unviewed.length,
    'viewed': viewed.length,
    'today': today.length,
  };
});

// Provider para stories por período
final storiesByPeriodProvider = FutureProvider.family<List<StoryModel>, String>((ref, period) async {
  switch (period.toLowerCase()) {
    case 'today':
      return await ref.watch(todayStoriesProvider.future);
    case 'yesterday':
      return await ref.watch(yesterdayStoriesProvider.future);
    case 'recent':
      return await ref.watch(recentStoriesProvider.future);
    default:
      return await ref.watch(sortedStoriesProvider.future);
  }
});