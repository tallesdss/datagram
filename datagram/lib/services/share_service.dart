import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Serviço para gerenciar operações de compartilhamento
class ShareService {
  
  /// Compartilhar texto simples
  Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject,
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar texto: $e');
    }
  }
  
  /// Compartilhar URL
  Future<void> shareUrl({
    required String url,
    String? text,
    String? subject,
  }) async {
    try {
      final shareText = text != null ? '$text\n$url' : url;
      await Share.share(
        shareText,
        subject: subject,
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar URL: $e');
    }
  }
  
  /// Compartilhar post do Datagram
  Future<void> sharePost({
    required String postId,
    required String username,
    String? caption,
    String? imageUrl,
  }) async {
    try {
      final postUrl = 'https://datagram.app/post/$postId';
      final shareText = caption != null 
          ? 'Confira este post de @$username no Datagram:\n\n$caption\n\n$postUrl'
          : 'Confira este post de @$username no Datagram:\n\n$postUrl';
      
      await Share.share(
        shareText,
        subject: 'Post do Datagram',
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar post: $e');
    }
  }
  
  /// Compartilhar story
  Future<void> shareStory({
    required String storyId,
    required String username,
  }) async {
    try {
      final storyUrl = 'https://datagram.app/story/$storyId';
      final shareText = 'Confira este story de @$username no Datagram:\n\n$storyUrl';
      
      await Share.share(
        shareText,
        subject: 'Story do Datagram',
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar story: $e');
    }
  }
  
  /// Compartilhar perfil de usuário
  Future<void> shareProfile({
    required String username,
    String? displayName,
  }) async {
    try {
      final profileUrl = 'https://datagram.app/profile/$username';
      final shareText = displayName != null
          ? 'Confira o perfil de $displayName (@$username) no Datagram:\n\n$profileUrl'
          : 'Confira o perfil de @$username no Datagram:\n\n$profileUrl';
      
      await Share.share(
        shareText,
        subject: 'Perfil do Datagram',
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar perfil: $e');
    }
  }
  
  /// Copiar texto para área de transferência
  Future<void> copyToClipboard({
    required String text,
    String? label,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
    } catch (e) {
      throw Exception('Erro ao copiar para área de transferência: $e');
    }
  }
  
  /// Copiar link do post
  Future<void> copyPostLink({
    required String postId,
  }) async {
    try {
      final postUrl = 'https://datagram.app/post/$postId';
      await Clipboard.setData(ClipboardData(text: postUrl));
    } catch (e) {
      throw Exception('Erro ao copiar link do post: $e');
    }
  }
  
  /// Copiar link do story
  Future<void> copyStoryLink({
    required String storyId,
  }) async {
    try {
      final storyUrl = 'https://datagram.app/story/$storyId';
      await Clipboard.setData(ClipboardData(text: storyUrl));
    } catch (e) {
      throw Exception('Erro ao copiar link do story: $e');
    }
  }
  
  /// Abrir URL no navegador
  Future<void> openUrl({
    required String url,
  }) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Não foi possível abrir a URL: $url');
      }
    } catch (e) {
      throw Exception('Erro ao abrir URL: $e');
    }
  }
  
  /// Abrir aplicativo de email
  Future<void> openEmail({
    required String email,
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        query: subject != null || body != null
            ? 'subject=${Uri.encodeComponent(subject ?? '')}&body=${Uri.encodeComponent(body ?? '')}'
            : null,
      );
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Não foi possível abrir o aplicativo de email');
      }
    } catch (e) {
      throw Exception('Erro ao abrir email: $e');
    }
  }
  
  /// Abrir aplicativo de telefone
  Future<void> openPhone({
    required String phoneNumber,
  }) async {
    try {
      final uri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Não foi possível abrir o aplicativo de telefone');
      }
    } catch (e) {
      throw Exception('Erro ao abrir telefone: $e');
    }
  }
  
  /// Mostrar opções de compartilhamento
  Future<void> showShareOptions({
    required BuildContext context,
    required String postId,
    required String username,
    String? caption,
    String? imageUrl,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => ShareOptionsBottomSheet(
        postId: postId,
        username: username,
        caption: caption,
        imageUrl: imageUrl,
      ),
    );
  }
}

/// Widget para mostrar opções de compartilhamento
class ShareOptionsBottomSheet extends StatelessWidget {
  final String postId;
  final String username;
  final String? caption;
  final String? imageUrl;
  
  const ShareOptionsBottomSheet({
    super.key,
    required this.postId,
    required this.username,
    this.caption,
    this.imageUrl,
  });
  
  @override
  Widget build(BuildContext context) {
    final shareService = ShareService();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compartilhar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Compartilhar no Datagram
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Compartilhar post'),
            onTap: () async {
              Navigator.pop(context);
              try {
                await shareService.sharePost(
                  postId: postId,
                  username: username,
                  caption: caption,
                  imageUrl: imageUrl,
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: $e')),
                  );
                }
              }
            },
          ),
          
          // Copiar link
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Copiar link'),
            onTap: () async {
              Navigator.pop(context);
              try {
                await shareService.copyPostLink(postId: postId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link copiado!')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro: $e')),
                  );
                }
              }
            },
          ),
          
          // Compartilhar texto
          if (caption != null)
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Compartilhar texto'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await shareService.shareText(
                    text: caption!,
                    subject: 'Post de @$username',
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro: $e')),
                    );
                  }
                }
              },
            ),
          
          const SizedBox(height: 8),
          
          // Botão cancelar
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }
}
