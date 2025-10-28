import 'user_model.dart';

class Story {
  final String id;
  final String userId;
  final String mediaUrl;
  final DateTime timestamp;
  final bool isViewed;
  final Duration duration;
  final User user;

  const Story({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.timestamp,
    required this.isViewed,
    required this.duration,
    required this.user,
  });

  Story copyWith({
    String? id,
    String? userId,
    String? mediaUrl,
    DateTime? timestamp,
    bool? isViewed,
    Duration? duration,
    User? user,
  }) {
    return Story(
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
    return other is Story && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Story(id: $id, userId: $userId, isViewed: $isViewed)';
  }
}
