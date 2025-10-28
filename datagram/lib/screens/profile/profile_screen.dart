import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final userStatsAsync = ref.watch(userStatsProvider);
    
    return currentUserAsync.when(
      data: (currentUser) {
        final userPostsAsync = ref.watch(postsByUserProvider(currentUser?.id ?? ''));
        
        return Scaffold(
      appBar: AppBar(
        title: Text(currentUser?.username ?? 'Usuário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _showProfileMenu(context);
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
                        backgroundImage: NetworkImage(currentUser?.profileImageUrl ?? ''),
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
                                  _buildStatColumn('Posts', stats['posts']!),
                                  _buildStatColumn('Seguidores', stats['followers']!),
                                  _buildStatColumn('Seguindo', stats['following']!),
                                ],
                              ),
                              loading: () => const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatColumn('Posts', 0),
                                  _buildStatColumn('Seguidores', 0),
                                  _buildStatColumn('Seguindo', 0),
                                ],
                              ),
                              error: (_, __) => const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatColumn('Posts', 0),
                                  _buildStatColumn('Seguidores', 0),
                                  _buildStatColumn('Seguindo', 0),
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
                          currentUser?.fullName ?? 'Nome não disponível',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (currentUser?.bio.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(currentUser!.bio),
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
              GridView.builder(
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
              )
            else
              const Padding(
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
              ),
          ],
        ),
      ),
    );
  }
  
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
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro ao carregar perfil: $error'),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showProfileMenu(BuildContext context) {
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
            leading: const Icon(Icons.qr_code),
            title: const Text('Código QR'),
            onTap: () {
              Navigator.pop(context);
              // Mostrar código QR
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              // Implementar logout
            },
          ),
        ],
      ),
    );
  }
}
