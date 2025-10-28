import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showProfileMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              // Navegar para configurações
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('Salvos'),
            onTap: () {
              Navigator.pop(context);
              // Navegar para posts salvos
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutConfirmation(context, ref);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performLogout(ref);
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signOut();
      // O provider já atualiza o estado automaticamente
    } catch (e) {
      // Em caso de erro, mostrar mensagem
      // O erro será tratado pelo provider
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userStatsAsync = ref.watch(userStatsProvider);
    
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }
    
    final userPostsAsync = ref.watch(postsByUserProvider(currentUser.id));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showProfileMenu(context, ref);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header do perfil
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Foto do perfil
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(currentUser.profileImageUrl),
                      ),
                      const SizedBox(width: 20),
                      
                      // Estatísticas
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            userStatsAsync.when(
                              data: (stats) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatColumn('Posts', stats['posts'] ?? 0),
                                  _buildStatColumn('Seguidores', stats['followers'] ?? 0),
                                  _buildStatColumn('Seguindo', stats['following'] ?? 0),
                                ],
                              ),
                              loading: () => const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                ],
                              ),
                              error: (_, __) => const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  Text('0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Informações do usuário
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (currentUser.bio.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(currentUser.bio),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botão de editar perfil
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navegar para tela de editar perfil
                      },
                      child: const Text('Editar Perfil'),
                    ),
                  ),
                ],
              ),
            ),
            
            // Grid de posts
            userPostsAsync.when(
              data: (userPosts) {
                if (userPosts.isNotEmpty) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) {
                      final post = userPosts[index];
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
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum post ainda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Compartilhe fotos e vídeos com seus seguidores',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Erro ao carregar posts')),
            ),
          ],
        ),
      ),
    );
  }
}