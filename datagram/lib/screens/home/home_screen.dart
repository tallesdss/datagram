import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final postsAsync = ref.watch(postProvider);
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-post'),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(postProvider.notifier).refreshPosts();
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
                  itemCount: stories.when(
                    data: (storiesList) => storiesList.length,
                    loading: () => 0,
                    error: (_, __) => 0,
                  ),
                  itemBuilder: (context, index) {
                    return stories.when(
                      data: (storiesList) {
                        final story = storiesList[index];
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
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ),
            
            // Posts
            postsAsync.when(
              data: (posts) => SliverList(
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
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (error, stackTrace) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Erro ao carregar posts: $error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.read(postProvider.notifier).refreshPosts(),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
