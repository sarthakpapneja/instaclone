import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/story.dart';
import '../services/post_repository.dart';

class FeedProvider with ChangeNotifier {
  final PostRepository _repository = PostRepository();
  
  List<Post> _posts = [];
  List<Story> _stories = [];
  bool _isLoadingStories = false;
  bool _isLoadingPosts = false;
  bool _isLazyLoading = false;
  int _currentPage = 0;
  bool _hasMorePosts = true;

  List<Post> get posts => _posts;
  List<Story> get stories => _stories;
  bool get isLoadingStories => _isLoadingStories;
  bool get isLoadingPosts => _isLoadingPosts;
  bool get isLazyLoading => _isLazyLoading;
  bool get hasMorePosts => _hasMorePosts;

  Future<void> init() async {
    await fetchStories();
    await fetchInitialPosts();
  }

  Future<void> fetchStories() async {
    _isLoadingStories = true;
    notifyListeners();
    try {
      _stories = await _repository.getStories();
    } catch (e) {
      debugPrint('Error fetching stories: $e');
    } finally {
      _isLoadingStories = false;
      notifyListeners();
    }
  }

  Future<void> fetchInitialPosts() async {
    _isLoadingPosts = true;
    _currentPage = 0;
    _posts = [];
    notifyListeners();
    try {
      _posts = await _repository.getPosts(page: _currentPage);
      _currentPage++;
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    } finally {
      _isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<void> fetchMorePosts() async {
    if (_isLazyLoading || !_hasMorePosts) return;

    _isLazyLoading = true;
    notifyListeners();

    try {
      final morePosts = await _repository.getPosts(page: _currentPage);
      if (morePosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        _posts.addAll(morePosts);
        _currentPage++;
      }
    } catch (e) {
      debugPrint('Error lazy loading posts: $e');
    } finally {
      _isLazyLoading = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final isLiked = !post.isLiked;
      _posts[index] = post.copyWith(
        isLiked: isLiked,
        likes: isLiked ? post.likes + 1 : post.likes - 1,
      );
      notifyListeners();
    }
  }

  void toggleSave(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(isSaved: !post.isSaved);
      notifyListeners();
    }
  }
}
