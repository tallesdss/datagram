class User {
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

  const User({
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

  User copyWith({
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
    return User(
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
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, username: $username, fullName: $fullName)';
  }
}
