import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../data/mock_data.dart';
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
final postsProvider = Provider<List<PostModel>>((ref) {
  return MockData.getPosts();
});

// Provider para posts ordenados por timestamp (mais recentes primeiro)
final sortedPostsProvider = Provider<List<PostModel>>((ref) {
  final posts = ref.watch(postsProvider);
  final sortedPosts = List<PostModel>.from(posts);
  sortedPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  return sortedPosts;
});

// Provider para posts salvos pelo usuário atual
final savedPostsProvider = Provider<List<PostModel>>((ref) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.isSaved).toList();
});

// Provider para posts curtidos pelo usuário atual
final likedPostsProvider = Provider<List<PostModel>>((ref) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.isLiked).toList();
});

// Provider para posts de um usuário específico
final postsByUserProvider = Provider.family<List<PostModel>, String>((ref, userId) {
  return MockData.getPostsByUserModel(userId);
});

// Provider para um post específico por ID
final postByIdProvider = Provider.family<PostModel?, String>((ref, id) {
  return MockData.getPostById(id);
});

// Provider para comentários de um post específico
final commentsByPostProvider = Provider.family<List<CommentModel>, String>((ref, postId) {
  return MockData.getCommentsByPostModel(postId);
});

// Provider para comentários ordenados por timestamp
final sortedCommentsProvider = Provider.family<List<CommentModel>, String>((ref, postId) {
  final comments = ref.watch(commentsByPostProvider(postId));
  final sortedComments = List<CommentModel>.from(comments);
  sortedComments.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sortedComments;
});

// Provider para estatísticas de um post
final postStatsProvider = Provider.family<Map<String, int>, String>((ref, postId) {
  final post = ref.watch(postByIdProvider(postId));
  if (post == null) return {'likes': 0, 'comments': 0};
  
  return {
    'likes': post.likesCount,
    'comments': post.commentsCount,
  };
});

// Provider para verificar se um post está curtido
final isPostModelLikedProvider = Provider.family<bool, String>((ref, postId) {
  final post = ref.watch(postByIdProvider(postId));
  return post?.isLiked ?? false;
});

// Provider para verificar se um post está salvo
final isPostModelSavedProvider = Provider.family<bool, String>((ref, postId) {
  final post = ref.watch(postByIdProvider(postId));
  return post?.isSaved ?? false;
});

// Provider para posts com mais curtidas
final topLikedPostModelsProvider = Provider<List<PostModel>>((ref) {
  final posts = ref.watch(postsProvider);
  final sortedPostModels = List<PostModel>.from(posts);
  sortedPostModels.sort((a, b) => b.likesCount.compareTo(a.likesCount));
  return sortedPostModels.take(5).toList();
});

// Provider para posts recentes (últimas 24 horas)
final recentPostModelsProvider = Provider<List<PostModel>>((ref) {
  final posts = ref.watch(postsProvider);
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  
  return posts.where((post) => post.timestamp.isAfter(yesterday)).toList();
});

// Provider para posts por localização
final postsByLocationProvider = Provider.family<List<PostModel>, String>((ref, location) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.location?.contains(location) ?? false).toList();
});

// Provider para posts com hashtags específicas
final postsByHashtagProvider = Provider.family<List<PostModel>, String>((ref, hashtag) {
  final posts = ref.watch(postsProvider);
  return posts.where((post) => post.caption.contains('#$hashtag')).toList();
});

// Provider para feed personalizado (posts dos usuários seguidos)
final personalizedFeedProvider = Provider<List<PostModel>>((ref) {
  // Este provider será conectado com o UserProvider quando integrarmos
  final posts = ref.watch(sortedPostsProvider);
  return posts.take(10).toList(); // Por enquanto, retorna os 10 posts mais recentes
});

// Provider para busca de posts
final searchPostsProvider = Provider.family<List<PostModel>, String>((ref, query) {
  final posts = ref.watch(postsProvider);
  if (query.isEmpty) return [];
  
  return posts.where((post) {
    return post.caption.toLowerCase().contains(query.toLowerCase()) ||
           post.user.username.toLowerCase().contains(query.toLowerCase()) ||
           post.user.fullName.toLowerCase().contains(query.toLowerCase()) ||
           (post.location?.toLowerCase().contains(query.toLowerCase()) ?? false);
  }).toList();
});
