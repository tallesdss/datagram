class AppConstants {
  // URLs para imagens mock
  static const String placeholderImageUrl = 'https://picsum.photos/400/400';
  static const String profileImageUrl = 'https://picsum.photos/200/200';
  static const String storyImageUrl = 'https://picsum.photos/300/500';
  
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
  
  // Usuário padrão para autenticação mock
  static const String defaultUserId = 'current_user';
  static const String defaultUsername = 'usuario_atual';
  static const String defaultFullName = 'Usuário Atual';
}
