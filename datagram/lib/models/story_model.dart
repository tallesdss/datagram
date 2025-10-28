import 'user_model.dart';

class StoryModel {
  final String id;
  final String userId;
  final String mediaUrl;
  final DateTime timestamp;
  final bool isViewed;
  final Duration duration;
  final UserModel user;

  const StoryModel({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.timestamp,
    required this.isViewed,
    required this.duration,
    required this.user,
  });

  StoryModel copyWith({
    String? id,
    String? userId,
    String? mediaUrl,
    DateTime? timestamp,
    bool? isViewed,
    Duration? duration,
    UserModel? user,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      timestamp: timestamp ?? this.timestamp,
      isViewed: isViewed ?? this.isViewed,
      duration: duration ?? this.duration,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'StoryModel(id: $id, userId: $userId, isViewed: $isViewed)';
  }
  
  /// Criar modelo a partir de JSON
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      timestamp: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isViewed: json['is_viewed'] ?? false,
      duration: Duration(seconds: json['duration'] ?? 5),
      user: json['user'] != null 
          ? UserModel.fromJson(json['user']) 
          : UserModel(
              id: json['user_id'] ?? '',
              username: '',
              fullName: '',
              profileImageUrl: '',
              bio: '',
              postsCount: 0,
              followersCount: 0,
              followingCount: 0,
            ),
    );
  }
  
  /// Converter modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'media_url': mediaUrl,
      'created_at': timestamp.toIso8601String(),
      'duration': duration.inSeconds,
    };
  }
}
