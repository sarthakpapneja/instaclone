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

class _PostCardState extends State<PostCard> {
  int _currentImageIndex = 0;

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
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Stack(
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
                      placeholder: (context, url) => Container(color: Colors.grey[900]),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  );
                },
              ),
              if (widget.post.imageUrls.length > 1)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentImageIndex + 1}/${widget.post.imageUrls.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Post Actions Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              IconButton(
                icon: FaIcon(
                  widget.post.isLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  color: widget.post.isLiked ? Colors.red : theme.iconTheme.color,
                  size: 24,
                ),
                onPressed: () => context.read<FeedProvider>().toggleLike(widget.post.id),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.comment, size: 24),
                onPressed: () => _showUnimplementedSnackbar(context),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 24),
                onPressed: () => _showUnimplementedSnackbar(context),
              ),
              if (widget.post.imageUrls.length > 1)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.post.imageUrls.length,
                      (index) => Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? theme.colorScheme.primary == Colors.black ? Colors.blue : Colors.blueAccent
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
                '${widget.post.likes} likes',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '${widget.post.user.username} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: widget.post.caption),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _showUnimplementedSnackbar(context),
                child: Text(
                  'View all ${widget.post.commentCount} comments',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getTimeAgo(widget.post.timestamp),
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const SizedBox(height: 16),
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
