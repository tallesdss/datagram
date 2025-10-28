import 'user_model.dart';

class Post {
  final String id;
  final String userId;
  final String imageUrl;
  final String caption;
  final String? location;
  final DateTime timestamp;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final User user;

  const Post({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.caption,
    this.location,
    required this.timestamp,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isSaved,
    required this.user,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? caption,
    String? location,
    DateTime? timestamp,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    User? user,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, caption: $caption)';
  }
}
