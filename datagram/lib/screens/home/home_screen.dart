import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/story_circle.dart';
import '../../widgets/post_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datagram'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simular refresh
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: StoryCircle(
                        username: 'usuario_$index',
                        imageUrl: 'https://picsum.photos/200/200?random=$index',
                        isViewed: false,
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
                  return PostCard(
                    postId: 'post_$index',
                    imageUrl: 'https://picsum.photos/400/400?random=${index + 100}',
                    username: 'usuario_$index',
                    userImageUrl: 'https://picsum.photos/200/200?random=$index',
                    caption: 'Este é um post de exemplo #$index',
                    likesCount: (index + 1) * 10,
                    commentsCount: (index + 1) * 3,
                    timestamp: DateTime.now().subtract(Duration(hours: index)),
                    isLiked: index % 3 == 0,
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
