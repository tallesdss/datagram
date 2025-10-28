import 'user_model.dart';

class PostModel {
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
  final UserModel user;

  const PostModel({
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

  PostModel copyWith({
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
    UserModel? user,
  }) {
    return PostModel(
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
    return other is PostModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, caption: $caption)';
  }
  
  /// Criar modelo a partir de JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      caption: json['caption'] ?? '',
      location: json['location'],
      timestamp: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
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
      'image_url': imageUrl,
      'caption': caption,
      'location': location,
      'created_at': timestamp.toIso8601String(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
    };
  }
}
