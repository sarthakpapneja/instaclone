class User {
  final String id;
  final String username;
  final String profilePicUrl;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.profilePicUrl,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      profilePicUrl: json['profilePicUrl'],
      isVerified: json['isVerified'] ?? false,
    );
  }
}
