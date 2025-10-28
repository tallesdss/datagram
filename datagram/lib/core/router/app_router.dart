import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/reels/reels_screen.dart';
import '../../screens/activity/activity_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/post/post_detail_screen.dart';
import '../../screens/post/create_post_screen.dart';
import '../../screens/story/story_viewer_screen.dart';
import '../../screens/story/create_story_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/saved/saved_posts_screen.dart';
import '../../screens/messages/direct_messages_screen.dart';

// Provider para o router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      // Rota principal com bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/reels',
            builder: (context, state) => const ReelsScreen(),
          ),
          GoRoute(
            path: '/activity',
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Rotas de posts
      GoRoute(
        path: '/post/:postId',
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailScreen(postId: postId);
        },
      ),
      
      GoRoute(
        path: '/create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      
      // Rotas de stories
      GoRoute(
        path: '/create-story',
        builder: (context, state) => const CreateStoryScreen(),
      ),
      
      GoRoute(
        path: '/story/:storyId',
        builder: (context, state) {
          final storyId = state.pathParameters['storyId']!;
          return StoryViewerScreen(storyId: storyId);
        },
      ),
      
      // Rotas de perfil
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      
      // Rotas de configurações
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      // Rotas de salvos
      GoRoute(
        path: '/saved',
        builder: (context, state) => const SavedPostsScreen(),
      ),
      
      // Rotas de mensagens
      GoRoute(
        path: '/direct-messages',
        builder: (context, state) => const DirectMessagesScreen(),
      ),
    ],
  );
});

// Shell com bottom navigation
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Criar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Reels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // AppBar personalizada para cada tela
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    
    // Não mostrar AppBar nas telas que já têm sua própria AppBar
    if (location == '/profile' || 
        location == '/search' || 
        location == '/reels' || 
        location == '/activity') {
      return null;
    }
    
    // AppBar da tela inicial
    if (location == '/home') {
      return AppBar(
        title: const Text(
          'Datagram',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              context.push('/activity');
            },
          ),
          IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {
              context.push('/direct-messages');
            },
          ),
        ],
      );
    }
    
    return null;
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/home':
        return 0;
      case '/search':
        return 1;
      case '/reels':
        return 3;
      case '/activity':
        return 0; // Atividade não tem tab própria
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        // Modal para criar post/story
        _showCreateModal(context);
        break;
      case 3:
        context.go('/reels');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  void _showCreateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_photo_alternate),
              title: const Text('Criar Post'),
              onTap: () {
                Navigator.pop(context);
                context.push('/create-post');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Criar Story'),
              onTap: () {
                Navigator.pop(context);
                context.push('/create-story');
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_call_outlined),
              title: const Text('Criar Reel'),
              onTap: () {
                Navigator.pop(context);
                // Simulação - na implementação real, isso levaria a uma tela de criação de reels
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidade de Reels em desenvolvimento')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: const Text('Criar Publicação'),
              onTap: () {
                Navigator.pop(context);
                // Simulação - na implementação real, isso levaria a uma tela de criação de publicação
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidade de Publicação em desenvolvimento')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
