import 'user.dart';

class Post {
  final String id;
  final User user;
  final List<String> imageUrls;
  final String caption;
  final int likes;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime timestamp;
  final String? location;

  Post({
    required this.id,
    required this.user,
    required this.imageUrls,
    required this.caption,
    required this.likes,
    required this.commentCount,
    this.isLiked = false,
    this.isSaved = false,
    required this.timestamp,
    this.location,
  });

  Post copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likes,
  }) {
    return Post(
      id: id,
      user: user,
      imageUrls: imageUrls,
      caption: caption,
      likes: likes ?? this.likes,
      commentCount: commentCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      timestamp: timestamp,
      location: location,
    );
  }
}
