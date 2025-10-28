import 'user_model.dart';

/// Modelo de dados para notificações
class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String message;
  final String? relatedUserId;
  final String? relatedPostId;
  final bool isRead;
  final DateTime createdAt;
  final UserModel? relatedUser;
  
  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    this.relatedUserId,
    this.relatedPostId,
    required this.isRead,
    required this.createdAt,
    this.relatedUser,
  });
  
  /// Criar modelo a partir de JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      message: json['message'],
      relatedUserId: json['related_user_id'],
      relatedPostId: json['related_post_id'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      relatedUser: json['related_user'] != null
          ? UserModel.fromJson(json['related_user'])
          : null,
    );
  }
  
  /// Converter modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'message': message,
      'related_user_id': relatedUserId,
      'related_post_id': relatedPostId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
  
  /// Criar cópia do modelo com alterações
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? message,
    String? relatedUserId,
    String? relatedPostId,
    bool? isRead,
    DateTime? createdAt,
    UserModel? relatedUser,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      relatedUserId: relatedUserId ?? this.relatedUserId,
      relatedPostId: relatedPostId ?? this.relatedPostId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedUser: relatedUser ?? this.relatedUser,
    );
  }
}
