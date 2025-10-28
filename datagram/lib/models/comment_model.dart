import 'user_model.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime timestamp;
  final int likesCount;
  final bool isLiked;
  final UserModel user;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.likesCount,
    required this.isLiked,
    required this.user,
  });

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? text,
    DateTime? timestamp,
    int? likesCount,
    bool? isLiked,
    UserModel? user,
  }) {
    return CommentModel(
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
    return other is CommentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CommentModel(id: $id, postId: $postId, text: $text)';
  }
  
  /// Criar modelo a partir de JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      postId: json['post_id'] ?? '',
      userId: json['user_id'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
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
      'post_id': postId,
      'user_id': userId,
      'text': text,
      'created_at': timestamp.toIso8601String(),
      'likes_count': likesCount,
    };
  }
}
