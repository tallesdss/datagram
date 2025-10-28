import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

/// Exemplo de como usar os providers do Datagram
/// Este arquivo demonstra as principais funcionalidades dos providers implementados
class ProviderExamplesScreen extends ConsumerWidget {
  const ProviderExamplesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Exemplos de como usar os diferentes providers
    
    // 1. Provider do usuário atual
    final currentUser = ref.watch(currentUserProvider);
    
    // 2. Provider de posts ordenados
    final posts = ref.watch(sortedPostsProvider);
    
    // 3. Provider de stories não visualizados
    final unviewedStories = ref.watch(unviewedStoriesProvider);
    
    // 4. Provider de comentários de um post específico
    final postComments = ref.watch(commentsByPostProvider('post_1'));
    
    // 5. Provider de busca global
    final searchResults = ref.watch(globalSearchProvider('flutter'));
    
    // 6. Provider de estatísticas gerais
    final generalStats = ref.watch(generalStatsProvider);
    
    // 7. Provider de notificações não lidas
    final unreadNotifications = ref.watch(unreadNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplos de Providers'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do usuário atual
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usuário Atual',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Nome: ${currentUser.fullName}'),
                    Text('Username: @${currentUser.username}'),
                    Text('Bio: ${currentUser.bio}'),
                    Text('Posts: ${currentUser.postsCount}'),
                    Text('Seguidores: ${currentUser.followersCount}'),
                    Text('Seguindo: ${currentUser.followingCount}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Estatísticas gerais
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estatísticas Gerais',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Total de Posts: ${generalStats['totalPosts']}'),
                    Text('Total de Stories: ${generalStats['totalStories']}'),
                    Text('Total de Comentários: ${generalStats['totalComments']}'),
                    Text('Total de Usuários: ${generalStats['totalUsers']}'),
                    Text('Total de Curtidas: ${generalStats['totalLikes']}'),
                    Text('Total de Visualizações: ${generalStats['totalViews']}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notificações
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notificações',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Não lidas: $unreadNotifications'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Stories não visualizados
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stories Não Visualizados',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Quantidade: ${unviewedStories.length}'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: unviewedStories.length,
                        itemBuilder: (context, index) {
                          final story = unviewedStories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(story.user.profileImageUrl),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  story.user.username,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Posts recentes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posts Recentes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Quantidade: ${posts.length}'),
                    const SizedBox(height: 8),
                    ...posts.take(3).map((post) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(post.user?.profileImageUrl ?? ''),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.user?.username ?? ''),
                                Text(
                                  post.caption ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Text('${post.likesCount ?? 0} ❤️'),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Comentários de um post específico
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comentários do Post 1',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Quantidade: ${postComments.length}'),
                    const SizedBox(height: 8),
                    ...postComments.take(3).map((comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(comment.user?.profileImageUrl ?? ''),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(comment.user?.username ?? ''),
                                Text(comment.text ?? ''),
                              ],
                            ),
                          ),
                          Text('${comment.likesCount ?? 0} ❤️'),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Resultados de busca
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultados de Busca por "flutter"',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('Quantidade: ${searchResults.length}'),
                    const SizedBox(height: 8),
                    ...searchResults.take(3).map((result) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            result['type'] == 'user' ? Icons.person : Icons.image,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              result['type'] == 'user' 
                                ? result['data'].username 
                                : result['data'].caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('${result['relevance']}'),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
