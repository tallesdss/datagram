class AppConstants {
  // URLs para imagens de fallback
  static const String placeholderImageUrl = 'https://via.placeholder.com/400x400/cccccc/666666?text=Image';
  static const String profileImageUrl = 'https://via.placeholder.com/200x200/cccccc/666666?text=Profile';
  static const String storyImageUrl = 'https://via.placeholder.com/300x500/cccccc/666666?text=Story';
  
  // URLs de fallback para quando as imagens principais falharem
  static const String fallbackImageUrl = 'https://via.placeholder.com/400x400/f0f0f0/999999?text=No+Image';
  static const String fallbackProfileUrl = 'https://via.placeholder.com/200x200/f0f0f0/999999?text=User';
  
  // Configurações de UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double borderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
  
  // Tamanhos de imagem
  static const double profileImageSize = 40.0;
  static const double storyImageSize = 60.0;
  static const double postImageHeight = 400.0;
  
  // Animações
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Limites
  static const int maxPostsPerPage = 10;
  static const int maxCommentsPerPost = 50;
  static const int maxStoriesPerUser = 5;
  
  // Textos padrão
  static const String appName = 'Datagram';
  static const String defaultBio = 'Esta é minha bio no Datagram';
  static const String defaultLocation = 'São Paulo, Brasil';
}
