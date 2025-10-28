import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../models/post_model.dart';

// Provider para posts salvos (simulado)
final savedPostsProvider = Provider<List<Post>>((ref) {
  final allPosts = ref.watch(postsProvider);
  return allPosts.where((post) => post.isSaved).toList();
});

// Provider para coleções de posts salvos (simulado)
final savedCollectionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': 'collection_1',
      'name': 'Favoritos',
      'coverUrl': 'https://picsum.photos/200/200?random=301',
      'postsCount': 5,
    },
    {
      'id': 'collection_2',
      'name': 'Inspiração',
      'coverUrl': 'https://picsum.photos/200/200?random=302',
      'postsCount': 3,
    },
    {
      'id': 'collection_3',
      'name': 'Receitas',
      'coverUrl': 'https://picsum.photos/200/200?random=303',
      'postsCount': 2,
    },
  ];
});

class SavedPostsScreen extends ConsumerStatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  ConsumerState<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends ConsumerState<SavedPostsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedPosts = ref.watch(savedPostsProvider);
    final collections = ref.watch(savedCollectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salvos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Todos'),
            Tab(text: 'Coleções'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateCollectionDialog(context);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba de todos os posts salvos
          savedPosts.isEmpty
              ? _buildEmptyState('Nenhum post salvo', 'Salve posts para acessá-los mais tarde.')
              : GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: savedPosts.length,
                  itemBuilder: (context, index) {
                    final post = savedPosts[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/post/${post.id}');
                      },
                      child: CachedNetworkImage(
                        imageUrl: post.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),

          // Aba de coleções
          collections.isEmpty
              ? _buildEmptyState('Nenhuma coleção', 'Crie coleções para organizar seus posts salvos.')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          // Navegar para detalhes da coleção
                          _showCollectionDetails(context, collection);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: collection['coverUrl'] as String,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      collection['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${collection['postsCount']} posts',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  _showCollectionOptions(context, collection);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCollectionDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Coleção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da coleção',
                hintText: 'Ex: Favoritos, Receitas, etc.',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Coleção "${nameController.text}" criada!')),
                );
              }
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    ).then((_) => nameController.dispose());
  }

  void _showCollectionOptions(BuildContext context, Map<String, dynamic> collection) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Renomear'),
            onTap: () {
              Navigator.pop(context);
              _showRenameCollectionDialog(context, collection);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Excluir', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteCollectionConfirmation(context, collection);
            },
          ),
        ],
      ),
    );
  }

  void _showRenameCollectionDialog(BuildContext context, Map<String, dynamic> collection) {
    final TextEditingController nameController = TextEditingController(text: collection['name'] as String);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear Coleção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Novo nome',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Coleção renomeada para "${nameController.text}"!')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    ).then((_) => nameController.dispose());
  }

  void _showDeleteCollectionConfirmation(BuildContext context, Map<String, dynamic> collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Coleção'),
        content: Text('Tem certeza que deseja excluir a coleção "${collection['name']}"? Os posts salvos não serão excluídos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Coleção "${collection['name']}" excluída!')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCollectionDetails(BuildContext context, Map<String, dynamic> collection) {
    // Simular posts da coleção
    final posts = ref.read(savedPostsProvider).take(collection['postsCount'] as int).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(collection['name'] as String),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showCollectionOptions(context, collection);
                },
              ),
            ],
          ),
          body: posts.isEmpty
              ? _buildEmptyState('Nenhum post nesta coleção', 'Adicione posts a esta coleção.')
              : GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return GestureDetector(
                      onTap: () {
                        context.push('/post/${post.id}');
                      },
                      child: CachedNetworkImage(
                        imageUrl: post.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
