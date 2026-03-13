import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/story_tray.dart';
import '../widgets/shimmer_loading.dart';

class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger lazy loading when user is roughly 2 posts away from the bottom (approx 1200-1400px)
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 1400) {
      context.read<FeedProvider>().fetchMorePosts();
    }
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
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.string(
          '<svg height="32" viewBox="0 0 174 52" width="107" xmlns="http://www.w3.org/2000/svg"><path d="m40.5 3.3c-2.4 0-4.8.4-6.8 1.4-1.1.5-2 1.3-2.9 2.2-1 .9-1.9 2.1-2.5 3.5-.6 1.3-.9 2.8-.9 4.3v13.5c-.1 1.4.2 2.7.9 4 .6 1.2 1.5 2.4 2.5 3.3.9 1 2 1.7 3.1 2.3 1.2.5 2.5.8 3.8.8l10.8-.2c1.3 0 2.5-.2 3.8-.8 1.2-.5 2.2-1.3 3.1-2.2 1-.9 1.8-2 2.5-3.3.6-1.3.9-2.7.9-4.1v-13.4c.1-1.5-.2-3-.9-4.3-.6-1.3-1.5-2.5-2.5-3.5-.9-.9-1.9-1.6-3.1-2.1-2-1-4.4-1.5-6.8-1.5zm6.5 25.1c-.2.6-.5 1.1-.9 1.5-.4.4-.9.8-1.5.9-.6.2-1.2.3-1.8.3h-4.6c-.6 0-1.2-.1-1.8-.3-.6-.2-1-.5-1.5-.9-.4-.4-.7-.9-.9-1.5-.2-.5-.3-1.1-.3-1.7v-9.1c0-.6.1-1.2.3-1.8.2-.6.5-1 .9-1.4.4-.4.9-.8 1.5-1 .6-.2 1.2-.2 1.8-.2h4.6c.6 0 1.2.1 1.8.2.6.2 1.1.5 1.5 1 .4.4.7.9.9 1.4.2.6.3 1.2.3 1.8v9.1c0 .6-.1 1.2-.3 1.7zm11.2-15.6c-.7 0-1.4.3-1.9.8s-.8 1.2-.8 1.9.3 1.4.8 1.9.9.8 1.9.8 1.4-.3 1.9-.8.8-1.2.8-1.9-.3-1.4-.8-1.9-1.2-.8-1.9-.8z"/></svg>',
          colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color!, BlendMode.srcIn),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.heart, size: 24),
            onPressed: () => _showUnimplementedSnackbar(context),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.facebookMessenger, size: 24),
            onPressed: () => _showUnimplementedSnackbar(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FeedProvider>().init();
        },
        child: Consumer<FeedProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingPosts && provider.posts.isEmpty) {
              return const ShimmerFeedLoading();
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: provider.posts.length + 2, // Stories + Posts + Loading
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const StoryTray();
                }

                if (index == provider.posts.length + 1) {
                  return provider.hasMorePosts
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }

                final post = provider.posts[index - 1];
                return PostCard(post: post);
              },
            );
          },
        ),
      ),
    );
  }
}
