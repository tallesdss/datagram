import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';
import 'supabase_service.dart';

/// Serviço para gerenciar operações relacionadas a notificações
class NotificationService {
  final SupabaseClient _client = SupabaseService().client;
  
  /// Tipos de notificação
  static const String typeLike = 'like';
  static const String typeComment = 'comment';
  static const String typeFollow = 'follow';
  static const String typeStory = 'story';
  
  /// Obter notificações do usuário atual
  Future<List<NotificationModel>> getNotifications() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    final response = await _client
        .from('notifications')
        .select('*, users!related_user_id(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    
    return (response as List).map((notification) {
      final userData = notification['users'];
      notification['related_user'] = userData;
      return NotificationModel.fromJson(notification);
    }).toList();
  }
  
  /// Marcar uma notificação como lida
  Future<void> markAsRead(String notificationId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .eq('user_id', userId);
  }
  
  /// Marcar todas as notificações como lidas
  Future<void> markAllAsRead() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }
  
  /// Criar uma nova notificação
  Future<void> createNotification({
    required String userId,
    required String type,
    required String message,
    String? relatedUserId,
    String? relatedPostId,
  }) async {
    // Não notificar o próprio usuário
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return;
    if (userId == currentUserId) return;
    
    await _client.from('notifications').insert({
      'user_id': userId,
      'type': type,
      'message': message,
      'related_user_id': relatedUserId ?? currentUserId,
      'related_post_id': relatedPostId,
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
  
  /// Obter contagem de notificações não lidas
  Future<int> getUnreadCount() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return 0;
    
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('is_read', false);
    
    return response.length;
  }
  
  /// Criar notificação de like em post
  Future<void> createLikeNotification({
    required String postId,
    required String postOwnerId,
  }) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return;
    
    await createNotification(
      userId: postOwnerId,
      type: typeLike,
      message: 'curtiu sua publicação',
      relatedUserId: currentUserId,
      relatedPostId: postId,
    );
  }
  
  /// Criar notificação de comentário em post
  Future<void> createCommentNotification({
    required String postId,
    required String postOwnerId,
    required String commentText,
  }) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return;
    
    final shortComment = commentText.length > 30
        ? '${commentText.substring(0, 30)}...'
        : commentText;
    
    await createNotification(
      userId: postOwnerId,
      type: typeComment,
      message: 'comentou: "$shortComment"',
      relatedUserId: currentUserId,
      relatedPostId: postId,
    );
  }
  
  /// Criar notificação de novo seguidor
  Future<void> createFollowNotification({
    required String followedUserId,
  }) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return;
    
    await createNotification(
      userId: followedUserId,
      type: typeFollow,
      message: 'começou a seguir você',
      relatedUserId: currentUserId,
    );
  }
}
