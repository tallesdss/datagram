import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../services/share_service.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(globalSearchProvider(_searchQuery));
    final users = ref.watch(usersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Pesquisar',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Focar no campo de busca
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ],
      ),
      body: _searchQuery.isEmpty ? _buildDefaultContent(users) : _buildSearchResults(searchResults),
    );
  }

  Widget _buildDefaultContent(List users) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Usuários sugeridos
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Usuários Sugeridos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.profileImageUrl),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.username,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Posts populares
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Posts Populares',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ref.watch(topLikedPostModelsProvider).isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Nenhum post encontrado'),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: ref.watch(topLikedPostModelsProvider).length,
                  itemBuilder: (context, index) {
                    final post = ref.watch(topLikedPostModelsProvider)[index];
                    return GestureDetector(
                      onTap: () {
                        // Navegar para detalhes do post
                      },
                      child: Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Map<String, dynamic>> results) {
    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tente pesquisar por usuários ou posts',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final type = result['type'] as String;
        final data = result['data'];

        if (type == 'user') {
          return _buildUserResult(data);
        } else if (type == 'post') {
          return _buildPostResult(data);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildUserResult(user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profileImageUrl),
      ),
      title: Text(user.username),
      subtitle: Text(user.fullName),
      trailing: OutlinedButton(
        onPressed: () {
          // Implementar seguir/deixar de seguir
        },
        child: const Text('Seguir'),
      ),
      onTap: () {
        // Navegar para perfil do usuário
      },
    );
  }

  Widget _buildPostResult(post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.user.profileImageUrl),
            ),
            title: Text(post.user.username),
            subtitle: Text(post.location ?? ''),
          ),
          Image.network(
            post.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        // Implementar curtir
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        // Navegar para comentários
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: () async {
                        final shareService = ShareService();
                        try {
                          await shareService.sharePost(
                            postId: post.id,
                            username: post.user.username,
                            caption: post.caption,
                            imageUrl: post.imageUrl,
                          );
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao compartilhar: $e')),
                            );
                          }
                        }
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () {
                        // Implementar salvar
                      },
                    ),
                  ],
                ),
                Text(
                  '${post.likesCount} curtidas',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: '${post.user.username} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
                if (post.commentsCount > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Ver todos os ${post.commentsCount} comentários',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
