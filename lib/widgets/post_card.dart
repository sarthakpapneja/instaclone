import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/post.dart';
import '../providers/feed_provider.dart';
import 'pinch_to_zoom.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool _showHeartAnimation = false;
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_heartAnimationController);
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (!widget.post.isLiked) {
      context.read<FeedProvider>().toggleLike(widget.post.id);
    }
    setState(() {
      _showHeartAnimation = true;
    });
    _heartAnimationController.forward(from: 0).then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showHeartAnimation = false;
          });
        }
      });
    });
  }

  void _showUnimplementedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature not implemented yet!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Post Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.post.user.profilePicUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.post.user.username,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        if (widget.post.user.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(Icons.verified, color: Colors.blue, size: 14),
                          ),
                      ],
                    ),
                    if (widget.post.location != null)
                      Text(
                        widget.post.location!,
                        style: const TextStyle(fontSize: 11),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, size: 20),
                onPressed: () => _showUnimplementedSnackbar(context),
              ),
            ],
          ),
        ),

        // Post Media (Image or Carousel)
        GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: SizedBox(
            height: 480, // Refined height for better proportions
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  itemCount: widget.post.imageUrls.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return PinchToZoom(
                      child: CachedNetworkImage(
                        imageUrl: widget.post.imageUrls[index],
                        fit: BoxFit.cover,
                        memCacheHeight: 1200, // Optimize memory
                        placeholder: (context, url) => Container(color: Colors.grey[900]),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    );
                  },
                ),
                if (widget.post.imageUrls.length > 1)
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${widget.post.imageUrls.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (_showHeartAnimation)
                  ScaleTransition(
                    scale: _heartScaleAnimation,
                    child: const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Post Actions Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 150),
                tween: Tween(begin: 1.0, end: widget.post.isLiked ? 1.2 : 1.0),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: IconButton(
                      icon: FaIcon(
                        widget.post.isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                        color: widget.post.isLiked ? Colors.red : theme.iconTheme.color,
                        size: 26,
                      ),
                      onPressed: () => context.read<FeedProvider>().toggleLike(widget.post.id),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.comment, size: 24),
                onPressed: () => _showUnimplementedSnackbar(context),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 23),
                onPressed: () => _showUnimplementedSnackbar(context),
              ),
              if (widget.post.imageUrls.length > 1)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.post.imageUrls.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _currentImageIndex == index ? 7 : 6,
                        height: _currentImageIndex == index ? 7 : 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? const Color(0xFF0095F6)
                              : Colors.grey.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
              IconButton(
                icon: FaIcon(
                  widget.post.isSaved ? FontAwesomeIcons.solidBookmark : FontAwesomeIcons.bookmark,
                  size: 24,
                ),
                onPressed: () => context.read<FeedProvider>().toggleSave(widget.post.id),
              ),
            ],
          ),
        ),

        // Post Details
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.post.likes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} likes',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.5),
                  children: [
                    TextSpan(
                      text: '${widget.post.user.username} ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: widget.post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => _showUnimplementedSnackbar(context),
                child: Text(
                  'View all ${widget.post.commentCount} comments',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13.5),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _getTimeAgo(widget.post.timestamp).toUpperCase(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10, letterSpacing: 0.2),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) return '${diff.inDays} days ago';
    if (diff.inHours > 0) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }
}
