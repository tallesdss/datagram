import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/services.dart';

// Notifier para gerenciar posts com backend real
class PostNotifier extends StateNotifier<AsyncValue<List<PostModel>>> {
  PostNotifier(this._postService) : super(const AsyncValue.loading()) {
    _loadPosts();
  }

  final PostService _postService;

  Future<void> _loadPosts() async {
    try {
      state = const AsyncValue.loading();
      final posts = await _postService.getAllPosts();
      state = AsyncValue.data(posts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshPosts() async {
    await _loadPosts();
  }

  Future<void> likePost(String postId) async {
    try {
      await _postService.likePost(postId);
      // Atualizar estado local
      state.whenData((posts) {
        final updatedPosts = posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(
              isLiked: true,
              likesCount: post.likesCount + 1,
            );
          }
          return post;
        }).toList();
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      await _postService.unlikePost(postId);
      // Atualizar estado local
      state.whenData((posts) {
        final updatedPosts = posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(
              isLiked: false,
              likesCount: post.likesCount - 1,
            );
          }
          return post;
        }).toList();
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> savePost(String postId) async {
    try {
      await _postService.savePost(postId);
      // Atualizar estado local
      state.whenData((posts) {
        final updatedPosts = posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(isSaved: true);
          }
          return post;
        }).toList();
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> unsavePost(String postId) async {
    try {
      await _postService.unsavePost(postId);
      // Atualizar estado local
      state.whenData((posts) {
        final updatedPosts = posts.map((post) {
          if (post.id == postId) {
            return post.copyWith(isSaved: false);
          }
          return post;
        }).toList();
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createPost({
    required String caption,
    required String imageUrl,
    String? location,
  }) async {
    try {
      final newPost = await _postService.createPost(
        caption: caption,
        imageUrl: imageUrl,
        location: location,
      );
      
      // Adicionar novo post ao estado
      state.whenData((posts) {
        final updatedPosts = [newPost, ...posts];
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createPostWithImageBytes({
    required Uint8List imageBytes,
    String? caption,
    String? location,
  }) async {
    try {
      final newPost = await _postService.createPostWithImageBytes(
        imageBytes: imageBytes,
        caption: caption,
        location: location,
      );
      
      // Adicionar novo post ao estado
      state.whenData((posts) {
        final updatedPosts = [newPost, ...posts];
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _postService.deletePost(postId);
      // Remover post do estado
      state.whenData((posts) {
        final updatedPosts = posts.where((post) => post.id != postId).toList();
        state = AsyncValue.data(updatedPosts);
      });
    } catch (error) {
      rethrow;
    }
  }
}

// Provider principal para posts com backend real
final postProvider = StateNotifierProvider<PostNotifier, AsyncValue<List<PostModel>>>((ref) {
  return PostNotifier(PostService());
});

// Provider para todos os posts
final postsProvider = FutureProvider<List<PostModel>>((ref) async {
  final postService = PostService();
  return await postService.getAllPosts();
});

// Provider para posts ordenados por timestamp (mais recentes primeiro)
final sortedPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  final posts = await ref.watch(postsProvider.future);
  final sortedPosts = List<PostModel>.from(posts);
  sortedPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return sortedPosts;
});

// Provider para posts salvos pelo usuário atual
final savedPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  final postService = PostService();
  return await postService.getSavedPosts();
});

// Provider para posts de um usuário específico
final postsByUserProvider = FutureProvider.family<List<PostModel>, String>((ref, userId) async {
  final postService = PostService();
  return await postService.getPostsByUser(userId);
});

// Provider para um post específico por ID
final postByIdProvider = FutureProvider.family<PostModel?, String>((ref, id) async {
  final postService = PostService();
  return await postService.getPostById(id);
});

// Provider para comentários de um post específico
final commentsByPostProvider = FutureProvider.family<List<CommentModel>, String>((ref, postId) async {
  final commentService = CommentService();
  return await commentService.getCommentsByPost(postId);
});

// Provider para comentários ordenados por timestamp
final sortedCommentsProvider = FutureProvider.family<List<CommentModel>, String>((ref, postId) async {
  final comments = await ref.watch(commentsByPostProvider(postId).future);
  final sortedComments = List<CommentModel>.from(comments);
  sortedComments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sortedComments;
});

// Provider para estatísticas de um post
final postStatsProvider = FutureProvider.family<Map<String, int>, String>((ref, postId) async {
  final post = await ref.watch(postByIdProvider(postId).future);
  if (post == null) return {'likes': 0, 'comments': 0};
  
  return {
    'likes': post.likesCount,
    'comments': post.commentsCount,
  };
});

// Provider para verificar se um post está curtido
final isPostModelLikedProvider = FutureProvider.family<bool, String>((ref, postId) async {
  final postService = PostService();
  return await postService.isPostLiked(postId);
});

// Provider para verificar se um post está salvo
final isPostModelSavedProvider = FutureProvider.family<bool, String>((ref, postId) async {
  final postService = PostService();
  return await postService.isPostSaved(postId);
});

// Provider para posts com mais curtidas
final topLikedPostModelsProvider = FutureProvider<List<PostModel>>((ref) async {
  final posts = await ref.watch(postsProvider.future);
  final sortedPostModels = List<PostModel>.from(posts);
  sortedPostModels.sort((a, b) => b.likesCount.compareTo(a.likesCount));
  return sortedPostModels.take(5).toList();
});

// Provider para posts recentes (últimas 24 horas)
final recentPostModelsProvider = FutureProvider<List<PostModel>>((ref) async {
  final posts = await ref.watch(postsProvider.future);
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  
  return posts.where((post) => post.timestamp.isAfter(yesterday)).toList();
});

// Provider para posts por localização
final postsByLocationProvider = FutureProvider.family<List<PostModel>, String>((ref, location) async {
  final posts = await ref.watch(postsProvider.future);
  return posts.where((post) => post.location?.contains(location) ?? false).toList();
});

// Provider para posts com hashtags específicas
final postsByHashtagProvider = FutureProvider.family<List<PostModel>, String>((ref, hashtag) async {
  final posts = await ref.watch(postsProvider.future);
  return posts.where((post) => post.caption.contains('#$hashtag')).toList();
});

// Provider para feed personalizado (posts dos usuários seguidos)
final personalizedFeedProvider = FutureProvider<List<PostModel>>((ref) async {
  // Este provider será conectado com o UserProvider quando integrarmos
  final posts = await ref.watch(sortedPostsProvider.future);
  return posts.take(10).toList(); // Por enquanto, retorna os 10 posts mais recentes
});

// Provider para busca de posts
final searchPostsProvider = FutureProvider.family<List<PostModel>, String>((ref, query) async {
  final posts = await ref.watch(postsProvider.future);
  if (query.isEmpty) return [];
  
  return posts.where((post) {
    return post.caption.toLowerCase().contains(query.toLowerCase()) ||
           post.user.username.toLowerCase().contains(query.toLowerCase()) ||
           post.user.fullName.toLowerCase().contains(query.toLowerCase()) ||
           (post.location?.toLowerCase().contains(query.toLowerCase()) ?? false);
  }).toList();
});