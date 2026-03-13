import 'dart:async';
import '../models/post.dart';
import '../models/user.dart';
import '../models/story.dart';

class PostRepository {
  final List<User> _mockUsers = [
    User(id: '1', username: 'sarthak_codes', profilePicUrl: 'https://i.pravatar.cc/150?u=1', isVerified: true),
    User(id: '2', username: 'flutter_dev', profilePicUrl: 'https://i.pravatar.cc/150?u=2'),
    User(id: '3', username: 'google_design', profilePicUrl: 'https://i.pravatar.cc/150?u=3', isVerified: true),
    User(id: '4', username: 'nature_pics', profilePicUrl: 'https://i.pravatar.cc/150?u=4'),
    User(id: '5', username: 'tech_crunch', profilePicUrl: 'https://i.pravatar.cc/150?u=5', isVerified: true),
  ];

  final List<String> _mockImages = [
    'https://images.pexels.com/photos/1172253/pexels-photo-1172253.jpeg',
    'https://images.pexels.com/photos/1036622/pexels-photo-1036622.jpeg',
    'https://images.pexels.com/photos/147411/italy-mountains-dawn-daybreak-147411.jpeg',
    'https://images.pexels.com/photos/414102/pexels-photo-414102.jpeg',
    'https://images.pexels.com/photos/709552/pexels-photo-709552.jpeg',
  ];

  Future<List<Story>> getStories() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.generate(10, (index) {
      final user = _mockUsers[index % _mockUsers.length];
      return Story(
        id: 'story_$index',
        user: user,
        imageUrl: 'https://picsum.photos/seed/story_$index/400/800',
        isViewed: index > 3,
      );
    });
  }

  Future<List<Post>> getPosts({int page = 0, int pageSize = 10}) async {
    // Simulate latency
    await Future.delayed(const Duration(milliseconds: 1500));

    return List.generate(pageSize, (index) {
      final globalIndex = page * pageSize + index;
      final user = _mockUsers[globalIndex % _mockUsers.length];
      
      // Some posts have carousels
      final imageUrls = globalIndex % 3 == 0 
          ? [_mockImages[globalIndex % _mockImages.length], _mockImages[(globalIndex + 1) % _mockImages.length]]
          : [_mockImages[globalIndex % _mockImages.length]];

      return Post(
        id: 'post_$globalIndex',
        user: user,
        imageUrls: imageUrls,
        caption: 'This is a beautiful post #instagram #flutter #pixelperfect',
        likes: (globalIndex + 1) * 123,
        commentCount: (globalIndex + 1) * 15,
        timestamp: DateTime.now().subtract(Duration(hours: globalIndex + 1)),
        location: globalIndex % 2 == 0 ? 'San Francisco, CA' : null,
      );
    });
  }
}
