import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/providers.dart';
import '../../services/share_service.dart';
import 'dart:async';

class StoryViewerScreen extends ConsumerStatefulWidget {
  final String storyId;
  
  const StoryViewerScreen({super.key, required this.storyId});

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _timer;
  bool _isPlaying = true;
  final TextEditingController _replyController = TextEditingController();
  bool _isReplying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    
    // Iniciar a animação quando a tela for carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startStoryTimer();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _replyController.dispose();
    super.dispose();
  }

  void _startStoryTimer() {
    final story = ref.read(storyByIdProvider(widget.storyId));
    if (story == null) return;
    
    // Configurar a duração da animação baseada na duração do story
    _animationController.duration = story.duration;
    _animationController.forward();
    
    // Configurar o timer para navegar para o próximo story ou fechar a tela
    _timer = Timer(story.duration, () {
      // Aqui você pode implementar a navegação para o próximo story
      // Por enquanto, vamos apenas fechar a tela
      Navigator.of(context).pop();
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animationController.forward();
        _timer = Timer(
          _animationController.duration! * (1 - _animationController.value),
          () => Navigator.of(context).pop(),
        );
      } else {
        _animationController.stop();
        _timer?.cancel();
      }
    });
  }

  void _onTapDown(TapDownDetails details, Size size) {
    final double screenWidth = size.width;
    final double dx = details.globalPosition.dx;
    
    // Tap na parte esquerda (voltar) ou direita (avançar) da tela
    if (dx < screenWidth * 0.3) {
      // Voltar para o story anterior (não implementado)
      // Por enquanto, vamos apenas fechar a tela
      Navigator.of(context).pop();
    } else if (dx > screenWidth * 0.7) {
      // Avançar para o próximo story (não implementado)
      // Por enquanto, vamos apenas fechar a tela
      Navigator.of(context).pop();
    } else {
      // Tap no centro - pausar/continuar
      _togglePlayPause();
    }
  }

  void _toggleReply() {
    setState(() {
      _isReplying = !_isReplying;
      if (_isReplying) {
        _isPlaying = false;
        _animationController.stop();
        _timer?.cancel();
      } else {
        _isPlaying = true;
        _animationController.forward();
        _timer = Timer(
          _animationController.duration! * (1 - _animationController.value),
          () => Navigator.of(context).pop(),
        );
      }
    });
  }

  void _sendReply() {
    if (_replyController.text.trim().isEmpty) return;
    
    // Simular envio de resposta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resposta enviada!')),
    );
    
    // Limpar campo e fechar teclado
    _replyController.clear();
    _toggleReply();
  }

  @override
  Widget build(BuildContext context) {
    final story = ref.watch(storyByIdProvider(widget.storyId));
    final size = MediaQuery.of(context).size;
    
    if (story == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, size),
        child: Stack(
          children: [
            // Conteúdo do story
            CachedNetworkImage(
              imageUrl: story.mediaUrl,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
            
            // Barra de progresso
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _animationController.value,
                    backgroundColor: Colors.white.withAlpha(102), // ~0.4 opacity
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 2,
                  );
                },
              ),
            ),
            
            // Informações do usuário
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider(story.user.profileImageUrl),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    story.user.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getTimeAgo(story.timestamp),
                    style: TextStyle(
                      color: Colors.white.withAlpha(204), // ~0.8 opacity
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Ações na parte inferior
            if (!_isReplying)
              Positioned(
                bottom: 16 + MediaQuery.of(context).padding.bottom,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleReply,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withAlpha(102)), // ~0.4 opacity
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'Enviar mensagem',
                          style: TextStyle(
                            color: Colors.white.withAlpha(204), // ~0.8 opacity
                          ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Curtido!')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_outlined, color: Colors.white),
                      onPressed: () async {
                        final story = ref.read(storyByIdProvider(widget.storyId));
                        if (story != null) {
                          final shareService = ShareService();
                          try {
                            await shareService.shareStory(
                              storyId: story.id,
                              username: story.user.username,
                            );
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao compartilhar: $e')),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            
            // Campo de resposta
            if (_isReplying)
              Positioned(
                bottom: 16 + MediaQuery.of(context).padding.bottom,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: CachedNetworkImageProvider(
                        ref.watch(currentUserProvider)?.profileImageUrl ?? '',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26), // ~0.1 opacity
                        borderRadius: BorderRadius.circular(24),
                      ),
                        child: TextField(
                          controller: _replyController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Responder...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendReply,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
