import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/story_circle.dart';
import '../../widgets/post_card.dart';
import '../../providers/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final stories = ref.watch(sortedStoriesProvider);
    final posts = ref.watch(sortedPostsProvider);
    final unreadNotifications = ref.watch(unreadNotificationsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datagram'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_outline),
                onPressed: () {},
              ),
              if (unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadNotifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simular refresh - em uma implementação real, aqui chamaríamos os providers para recarregar os dados
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            // Stories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: StoryCircle(
                        username: story.user.username,
                        imageUrl: story.user.profileImageUrl,
                        isViewed: story.isViewed,
                        onTap: () {
                          // Navegar para o visualizador de stories
                          // Navigator.push(context, ...);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Posts
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = posts[index];
                  return PostCard(
                    postId: post.id,
                    imageUrl: post.imageUrl,
                    username: post.user.username,
                    userImageUrl: post.user.profileImageUrl,
                    caption: post.caption,
                    likesCount: post.likesCount,
                    commentsCount: post.commentsCount,
                    timestamp: post.timestamp,
                    isLiked: post.isLiked,
                    isSaved: post.isSaved,
                  );
                },
                childCount: posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
