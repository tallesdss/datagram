import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/providers.dart';
import '../../models/comment_model.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;
  
  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingCommentModel = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _postCommentModel() {
    if (_commentController.text.trim().isEmpty) return;
    
    setState(() {
      _isPostingCommentModel = true;
    });
    
    // Simular envio de comentário
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      setState(() {
        _isPostingCommentModel = false;
        _commentController.clear();
      });
      
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentário adicionado!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postByIdProvider(widget.postId));
    final comments = ref.watch(commentsByPostProvider(widget.postId));
    
    if (post == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Post')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(post.user.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showPostOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Conteúdo do post
          Expanded(
            child: ListView(
              children: [
                // Header do post
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: CachedNetworkImageProvider(post.user.profileImageUrl),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.user.username,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (post.location != null)
                              Text(
                                post.location!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Imagem do post
                AspectRatio(
                  aspectRatio: 1,
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
                              post.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: post.isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              // Implementar curtir post
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat_bubble_outline),
                            onPressed: () {
                              // Focar no campo de comentário
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_outlined),
                            onPressed: () {
                              // Implementar compartilhar post
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                            ),
                            onPressed: () {
                              // Implementar salvar post
                            },
                          ),
                        ],
                      ),
                      
                      // Contador de curtidas
                      if (post.likesCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${post.likesCount} curtidas',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      
                      // Caption
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${post.user.username} ',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextSpan(
                              text: post.caption,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      
                      // Timestamp
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          timeago.format(post.timestamp, locale: 'pt'),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      
                      const Divider(height: 24),
                      
                      // Comentários
                      Text(
                        'Comentários',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                
                // Lista de comentários
                ...comments.map((comment) => _buildCommentModelItem(context, comment)),
              ],
            ),
          ),
          
          // Campo para adicionar comentário
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(
                    ref.watch(currentUserProvider)?.profileImageUrl ?? '',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Adicione um comentário...',
                      border: InputBorder.none,
                    ),
                    maxLines: 1,
                  ),
                ),
                _isPostingCommentModel
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: _commentController.text.trim().isEmpty
                            ? null
                            : _postCommentModel,
                        child: const Text('Publicar'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentModelItem(BuildContext context, CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(comment.user.profileImageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${comment.user.username} ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextSpan(
                        text: comment.text,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      timeago.format(comment.timestamp, locale: 'pt'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${comment.likesCount} curtidas',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Responder',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              comment.isLiked ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: comment.isLiked ? Colors.red : null,
            ),
            onPressed: () {
              // Implementar curtir comentário
            },
          ),
        ],
      ),
    );
  }
  
  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('Salvar'),
            onTap: () {
              Navigator.pop(context);
              // Implementar salvar post
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Copiar link'),
            onTap: () {
              Navigator.pop(context);
              // Implementar copiar link
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Compartilhar'),
            onTap: () {
              Navigator.pop(context);
              // Implementar compartilhar
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: const Text('Denunciar'),
            onTap: () {
              Navigator.pop(context);
              // Implementar denunciar
            },
          ),
        ],
      ),
    );
  }
}
