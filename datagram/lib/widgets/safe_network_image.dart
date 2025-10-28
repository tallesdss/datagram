import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Widget personalizado para exibir imagens de rede com tratamento robusto de erros
class SafeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Se a URL estiver vazia ou inválida, mostrar widget de erro
    if (imageUrl.isEmpty || Uri.tryParse(imageUrl)?.hasAbsolutePath != true) {
      return _buildErrorWidget();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder != null ? (context, url) => placeholder! : (context, url) => _buildPlaceholder(),
      errorWidget: errorWidget != null ? (context, url, error) => errorWidget! : (context, url, error) => _buildErrorWidget(),
      // Configurações adicionais para melhor performance
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
    );

    // Aplicar border radius se especificado
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}

/// Widget para imagens de perfil com fallback para avatar padrão
class SafeProfileImage extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String? fallbackText;

  const SafeProfileImage({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty || Uri.tryParse(imageUrl)?.hasAbsolutePath != true) {
      return _buildFallbackAvatar();
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: ClipOval(
        child: SafeNetworkImage(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      child: fallbackText != null
          ? Text(
              fallbackText!.isNotEmpty ? fallbackText![0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: radius * 0.6,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            )
          : Icon(
              Icons.person,
              size: radius * 0.8,
              color: Colors.grey[600],
            ),
    );
  }
}

/// Widget para imagens de post com fallback
class SafePostImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SafePostImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SafeNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
