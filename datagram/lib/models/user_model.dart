class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String profileImageUrl;
  final String bio;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isVerified;
  final bool isPrivate;
  final bool isFollowing;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profileImageUrl,
    required this.bio,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
    this.isVerified = false,
    this.isPrivate = false,
    this.isFollowing = false,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? profileImageUrl,
    String? bio,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    bool? isVerified,
    bool? isPrivate,
    bool? isFollowing,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, fullName: $fullName)';
  }
  
  /// Criar modelo a partir de JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
      bio: json['bio'] ?? '',
      postsCount: json['posts_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isPrivate: json['is_private'] ?? false,
      isFollowing: false, // Será calculado separadamente
    );
  }
  
  /// Converter modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'posts_count': postsCount,
      'followers_count': followersCount,
      'following_count': followingCount,
      'is_verified': isVerified,
      'is_private': isPrivate,
    };
  }
}
