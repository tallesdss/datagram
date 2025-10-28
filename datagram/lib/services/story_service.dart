import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/story_model.dart';
import 'supabase_service.dart';
import 'storage_service.dart';

/// Serviço para gerenciar operações relacionadas a stories
class StoryService {
  final SupabaseClient _client = SupabaseService().client;
  final StorageService _storageService = StorageService();
  
  /// Criar um novo story
  Future<String> createStory({
    required File mediaFile,
    int duration = 5,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Upload da mídia
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final mediaPath = 'stories/$userId/$timestamp';
    final mediaUrl = await _storageService.uploadImage(
      image: mediaFile,
      bucket: 'stories',
      path: mediaPath,
    );
    
    // Calcular data de expiração (24 horas)
    final expiresAt = DateTime.now().add(const Duration(hours: 24));
    
    // Criar o story no banco de dados
    final response = await _client.from('stories').insert({
      'user_id': userId,
      'media_url': mediaUrl,
      'duration': duration,
      'expires_at': expiresAt.toIso8601String(),
      'created_at': DateTime.now().toIso8601String(),
    }).select('id').single();
    
    return response['id'];
  }
  
  /// Obter todos os stories não expirados
  Future<List<StoryModel>> getStories() async {
    final now = DateTime.now().toIso8601String();
    
    final response = await _client
        .from('stories')
        .select('*, users(*)')
        .gte('expires_at', now)
        .order('created_at', ascending: false);
    
    return (response as List).map((story) {
      final userData = story['users'];
      story['user'] = userData;
      return StoryModel.fromJson(story);
    }).toList();
  }
  
  /// Obter stories de um usuário específico
  Future<List<StoryModel>> getStoriesByUser(String userId) async {
    final now = DateTime.now().toIso8601String();
    
    final response = await _client
        .from('stories')
        .select('*, users(*)')
        .eq('user_id', userId)
        .gte('expires_at', now)
        .order('created_at', ascending: false);
    
    return (response as List).map((story) {
      final userData = story['users'];
      story['user'] = userData;
      return StoryModel.fromJson(story);
    }).toList();
  }
  
  /// Marcar um story como visualizado pelo usuário atual
  Future<void> viewStory(String storyId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Verificar se já foi visualizado
    final existingView = await _client
        .from('story_views')
        .select()
        .eq('story_id', storyId)
        .eq('user_id', userId)
        .maybeSingle();
    
    // Se não foi visualizado ainda, registrar visualização
    if (existingView == null) {
      await _client.from('story_views').insert({
        'story_id': storyId,
        'user_id': userId,
        'viewed_at': DateTime.now().toIso8601String(),
      });
    }
  }
  
  /// Verificar se o story foi visualizado pelo usuário atual
  Future<bool> isStoryViewed(String storyId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    
    final response = await _client
        .from('story_views')
        .select()
        .eq('story_id', storyId)
        .eq('user_id', userId)
        .maybeSingle();
    
    return response != null;
  }
  
  /// Deletar stories expirados (cleanup automático)
  Future<void> deleteExpiredStories() async {
    final now = DateTime.now().toIso8601String();
    
    // Obter stories expirados
    final expiredStories = await _client
        .from('stories')
        .select('id, media_url')
        .lt('expires_at', now);
    
    if (expiredStories.isEmpty) return;
    
    // Extrair IDs dos stories expirados
    final expiredIds = (expiredStories as List)
        .map((story) => story['id'] as String)
        .toList();
    
    // Deletar stories expirados do banco de dados
    await _client.from('stories').delete().inFilter('id', expiredIds);
    
    // Deletar arquivos de mídia do storage
    for (final story in expiredStories) {
      final mediaUrl = story['media_url'] as String;
      final pathRegExp = RegExp(r'stories/[^?]+');
      final match = pathRegExp.firstMatch(mediaUrl);
      
      if (match != null) {
        final mediaPath = match.group(0);
        if (mediaPath != null) {
          try {
            await _storageService.deleteImage(
              bucket: 'stories',
              path: mediaPath,
            );
          } catch (e) {
            // Ignorar erros ao deletar arquivos
            // Ignorar erro ao deletar arquivo
            // print('Erro ao deletar arquivo de story: $e');
          }
        }
      }
    }
  }
}
