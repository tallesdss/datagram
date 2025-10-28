import 'user_model.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime timestamp;
  final int likesCount;
  final bool isLiked;
  final User user;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.likesCount,
    required this.isLiked,
    required this.user,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? text,
    DateTime? timestamp,
    int? likesCount,
    bool? isLiked,
    User? user,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, text: $text)';
  }
}
