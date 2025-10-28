import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';

class PostCard extends ConsumerStatefulWidget {
  final String postId;
  final String imageUrl;
  final String username;
  final String userImageUrl;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final DateTime timestamp;
  final bool isLiked;
  final bool isSaved;

  const PostCard({
    super.key,
    required this.postId,
    required this.imageUrl,
    required this.username,
    required this.userImageUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.timestamp,
    this.isLiked = false,
    this.isSaved = false,
  });

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late bool _isLiked;
  late bool _isSaved;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isSaved = widget.isSaved;
    _likesCount = widget.likesCount;
  }

  void _toggleLike() async {
    try {
      if (_isLiked) {
        await ref.read(postProvider.notifier).unlikePost(widget.postId);
      } else {
        await ref.read(postProvider.notifier).likePost(widget.postId);
      }
      
      setState(() {
        _isLiked = !_isLiked;
        _likesCount += _isLiked ? 1 : -1;
      });
    } catch (e) {
      // Mostrar erro para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao curtir post: $e')),
        );
      }
    }
  }

  void _toggleSave() async {
    try {
      if (_isSaved) {
        await ref.read(postProvider.notifier).unsavePost(widget.postId);
      } else {
        await ref.read(postProvider.notifier).savePost(widget.postId);
      }
      
      setState(() {
        _isSaved = !_isSaved;
      });
    } catch (e) {
      // Mostrar erro para o usuário
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar post: $e')),
        );
      }
    }
  }

  void _sharePost() {
    // Implementar compartilhamento nativo
    // Por enquanto, apenas mostrar um diálogo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartilhar'),
        content: const Text('Funcionalidade de compartilhamento será implementada em breve.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToPostDetail() {
    context.push('/post/${widget.postId}');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do post
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(widget.userImageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.username,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          
          // Imagem do post
          GestureDetector(
            onDoubleTap: _toggleLike,
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
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
          ),
          
          // Ações do post
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : null,
                      ),
                      onPressed: _toggleLike,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: _navigateToPostDetail,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_outlined),
                      onPressed: _sharePost,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: _toggleSave,
                    ),
                  ],
                ),
                
                // Contador de curtidas
                if (_likesCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '$_likesCount curtidas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                
                // Caption
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.username} ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: widget.caption,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                
                // Comentários
                if (widget.commentsCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: GestureDetector(
                      onTap: _navigateToPostDetail,
                      child: Text(
                        'Ver todos os ${widget.commentsCount} comentários',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                
                // Timestamp
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    timeago.format(widget.timestamp, locale: 'pt'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
