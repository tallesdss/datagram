import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../models/comment_model.dart';

class MockData {
  // Usuários mock
  static final List<UserModel> users = [
    const UserModel(
      id: 'current_user',
      username: 'usuario_atual',
      fullName: 'Usuário Atual',
      profileImageUrl: 'https://via.placeholder.com/200x200/4CAF50/FFFFFF?text=UA',
      bio: 'Desenvolvedor Flutter apaixonado por tecnologia 📱',
      postsCount: 42,
      followersCount: 1250,
      followingCount: 380,
      isVerified: true,
    ),
    const UserModel(
      id: 'user_1',
      username: 'ana_silva',
      fullName: 'Ana Silva',
      profileImageUrl: 'https://via.placeholder.com/200x200/2196F3/FFFFFF?text=AS',
      bio: 'Fotógrafa profissional 📸 | São Paulo',
      postsCount: 156,
      followersCount: 8900,
      followingCount: 420,
      isVerified: true,
    ),
    const UserModel(
      id: 'user_2',
      username: 'carlos_dev',
      fullName: 'Carlos Santos',
      profileImageUrl: 'https://via.placeholder.com/200x200/FF9800/FFFFFF?text=CS',
      bio: 'Desenvolvedor Mobile | Tech Enthusiast',
      postsCount: 78,
      followersCount: 2100,
      followingCount: 650,
    ),
    const UserModel(
      id: 'user_3',
      username: 'maria_fitness',
      fullName: 'Maria Oliveira',
      profileImageUrl: 'https://via.placeholder.com/200x200/E91E63/FFFFFF?text=MO',
      bio: 'Personal Trainer 💪 | Vida saudável',
      postsCount: 234,
      followersCount: 15600,
      followingCount: 890,
      isVerified: true,
    ),
    const UserModel(
      id: 'user_4',
      username: 'joao_travel',
      fullName: 'João Costa',
      profileImageUrl: 'https://via.placeholder.com/200x200/9C27B0/FFFFFF?text=JC',
      bio: 'Viajante 🌍 | Explorando o mundo',
      postsCount: 89,
      followersCount: 3200,
      followingCount: 1200,
    ),
    const UserModel(
      id: 'user_5',
      username: 'lucia_art',
      fullName: 'Lúcia Fernandes',
      profileImageUrl: 'https://via.placeholder.com/200x200/607D8B/FFFFFF?text=LF',
      bio: 'Artista Digital 🎨 | Criatividade sem limites',
      postsCount: 67,
      followersCount: 4500,
      followingCount: 320,
    ),
    const UserModel(
      id: 'user_6',
      username: 'pedro_food',
      fullName: 'Pedro Lima',
      profileImageUrl: 'https://via.placeholder.com/200x200/795548/FFFFFF?text=PL',
      bio: 'Chef de Cozinha 👨‍🍳 | Sabores únicos',
      postsCount: 123,
      followersCount: 7800,
      followingCount: 450,
    ),
    const UserModel(
      id: 'user_7',
      username: 'sofia_music',
      fullName: 'Sofia Rodrigues',
      profileImageUrl: 'https://via.placeholder.com/200x200/3F51B5/FFFFFF?text=SR',
      bio: 'Cantora e Compositora 🎵 | Música é vida',
      postsCount: 45,
      followersCount: 12000,
      followingCount: 280,
      isVerified: true,
    ),
    const UserModel(
      id: 'user_8',
      username: 'rafael_tech',
      fullName: 'Rafael Almeida',
      profileImageUrl: 'https://via.placeholder.com/200x200/009688/FFFFFF?text=RA',
      bio: 'Tech Lead | Inovação e tecnologia',
      postsCount: 91,
      followersCount: 3400,
      followingCount: 520,
    ),
    const UserModel(
      id: 'user_9',
      username: 'camila_design',
      fullName: 'Camila Barbosa',
      profileImageUrl: 'https://via.placeholder.com/200x200/CDDC39/FFFFFF?text=CB',
      bio: 'UI/UX Designer ✨ | Criando experiências incríveis',
      postsCount: 112,
      followersCount: 5600,
      followingCount: 380,
    ),
    const UserModel(
      id: 'user_10',
      username: 'lucas_gamer',
      fullName: 'Lucas Pereira',
      profileImageUrl: 'https://via.placeholder.com/200x200/FF5722/FFFFFF?text=LP',
      bio: 'Gamer Profissional 🎮 | Esports',
      postsCount: 78,
      followersCount: 8900,
      followingCount: 1200,
    ),
  ];

  // Método para obter usuário por ID
  static UserModel? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para obter usuário atual
  static UserModel getCurrentUserModel() {
    return getUserById('current_user') ?? users.first;
  }

  // Método para obter usuários aleatórios
  static List<UserModel> getRandomUsers({int count = 5}) {
    final shuffled = List<UserModel>.from(users)..shuffle();
    return shuffled.take(count).toList();
  }

  // Posts mock
  static final List<PostModel> posts = [
    PostModel(
      id: 'post_1',
      userId: 'ana_silva',
      imageUrl: 'https://via.placeholder.com/400x500/FF6B6B/FFFFFF?text=Sunset',
      caption: 'Pôr do sol incrível hoje! 🌅 A natureza sempre nos surpreende com sua beleza única. #fotografia #natureza #pordosol',
      location: 'Praia de Copacabana, Rio de Janeiro',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 245,
      commentsCount: 18,
      isLiked: false,
      isSaved: false,
      user: users[1], // ana_silva
    ),
    PostModel(
      id: 'post_2',
      userId: 'carlos_dev',
      imageUrl: 'https://via.placeholder.com/400x500/4ECDC4/FFFFFF?text=Flutter',
      caption: 'Novo projeto em Flutter! 🚀 Desenvolvendo um app incrível com as melhores práticas. #flutter #mobile #desenvolvimento',
      location: 'São Paulo, SP',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 89,
      commentsCount: 12,
      isLiked: true,
      isSaved: true,
      user: users[2], // carlos_dev
    ),
    PostModel(
      id: 'post_3',
      userId: 'maria_fitness',
      imageUrl: 'https://via.placeholder.com/400x500/45B7D1/FFFFFF?text=Fitness',
      caption: 'Treino matinal completo! 💪 Começar o dia com energia é fundamental. Quem mais ama acordar cedo para treinar?',
      location: 'Academia FitLife',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likesCount: 156,
      commentsCount: 24,
      isLiked: false,
      isSaved: false,
      user: users[3], // maria_fitness
    ),
    PostModel(
      id: 'post_4',
      userId: 'joao_travel',
      imageUrl: 'https://via.placeholder.com/400x500/96CEB4/FFFFFF?text=Travel',
      caption: 'Explorando as montanhas do Peru! 🏔️ Cada viagem é uma nova aventura e uma oportunidade de crescimento pessoal.',
      location: 'Machu Picchu, Peru',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 312,
      commentsCount: 31,
      isLiked: true,
      isSaved: false,
      user: users[4], // joao_travel
    ),
    PostModel(
      id: 'post_5',
      userId: 'lucia_art',
      imageUrl: 'https://via.placeholder.com/400x500/FFEAA7/FFFFFF?text=Art',
      caption: 'Nova obra digital! 🎨 Arte é expressão, é emoção, é vida. Cada pincelada conta uma história única.',
      location: 'Estúdio Artístico',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      likesCount: 178,
      commentsCount: 15,
      isLiked: false,
      isSaved: true,
      user: users[5], // lucia_art
    ),
    PostModel(
      id: 'post_6',
      userId: 'pedro_food',
      imageUrl: 'https://via.placeholder.com/400x500/DDA0DD/FFFFFF?text=Food',
      caption: 'Receita especial do dia: Risotto de camarão! 🍤 Cozinhar é uma arte que une pessoas e cria memórias deliciosas.',
      location: 'Restaurante Sabor & Arte',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      likesCount: 267,
      commentsCount: 28,
      isLiked: true,
      isSaved: false,
      user: users[6], // pedro_food
    ),
    PostModel(
      id: 'post_7',
      userId: 'sofia_music',
      imageUrl: 'https://via.placeholder.com/400x500/98D8C8/FFFFFF?text=Music',
      caption: 'Gravando meu novo single! 🎵 A música tem o poder de tocar corações e transformar vidas. Em breve nas plataformas!',
      location: 'Estúdio Musical',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      likesCount: 445,
      commentsCount: 42,
      isLiked: false,
      isSaved: true,
      user: users[7], // sofia_music
    ),
    PostModel(
      id: 'post_8',
      userId: 'rafael_tech',
      imageUrl: 'https://via.placeholder.com/400x500/F7DC6F/FFFFFF?text=AI',
      caption: 'Workshop de IA hoje! 🤖 Tecnologia e inovação caminhando juntas para um futuro melhor. #inteligenciaartificial #inovacao',
      location: 'Tech Conference 2024',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      likesCount: 123,
      commentsCount: 19,
      isLiked: true,
      isSaved: false,
      user: users[8], // rafael_tech
    ),
    PostModel(
      id: 'post_9',
      userId: 'camila_design',
      imageUrl: 'https://via.placeholder.com/400x500/BB8FCE/FFFFFF?text=Design',
      caption: 'Novo design de interface! ✨ UX/UI é sobre criar experiências que conectam pessoas e tecnologia de forma intuitiva.',
      location: 'Design Studio',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      likesCount: 198,
      commentsCount: 22,
      isLiked: false,
      isSaved: true,
      user: users[9], // camila_design
    ),
    PostModel(
      id: 'post_10',
      userId: 'lucas_gamer',
      imageUrl: 'https://via.placeholder.com/400x500/85C1E9/FFFFFF?text=Gaming',
      caption: 'Campeonato de eSports! 🎮 Gaming é mais que diversão, é estratégia, trabalho em equipe e superação de limites.',
      location: 'Arena Gaming',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      likesCount: 334,
      commentsCount: 35,
      isLiked: true,
      isSaved: false,
      user: users[10], // lucas_gamer
    ),
  ];

  // Stories mock
  static final List<StoryModel> stories = [
    StoryModel(
      id: 'story_1',
      userId: 'ana_silva',
      mediaUrl: 'https://via.placeholder.com/300x500/FF6B6B/FFFFFF?text=Story+1',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isViewed: false,
      duration: const Duration(seconds: 5),
      user: users[1], // ana_silva
    ),
    StoryModel(
      id: 'story_2',
      userId: 'carlos_dev',
      mediaUrl: 'https://via.placeholder.com/300x500/4ECDC4/FFFFFF?text=Story+2',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isViewed: true,
      duration: const Duration(seconds: 3),
      user: users[2], // carlos_dev
    ),
    StoryModel(
      id: 'story_3',
      userId: 'maria_fitness',
      mediaUrl: 'https://via.placeholder.com/300x500/45B7D1/FFFFFF?text=Story+3',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isViewed: false,
      duration: const Duration(seconds: 4),
      user: users[3], // maria_fitness
    ),
    StoryModel(
      id: 'story_4',
      userId: 'joao_travel',
      mediaUrl: 'https://via.placeholder.com/300x500/96CEB4/FFFFFF?text=Story+4',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isViewed: true,
      duration: const Duration(seconds: 6),
      user: users[4], // joao_travel
    ),
    StoryModel(
      id: 'story_5',
      userId: 'lucia_art',
      mediaUrl: 'https://via.placeholder.com/300x500/FFEAA7/FFFFFF?text=Story+5',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isViewed: false,
      duration: const Duration(seconds: 4),
      user: users[5], // lucia_art
    ),
    StoryModel(
      id: 'story_6',
      userId: 'pedro_food',
      mediaUrl: 'https://via.placeholder.com/300x500/DDA0DD/FFFFFF?text=Story+6',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isViewed: true,
      duration: const Duration(seconds: 5),
      user: users[6], // pedro_food
    ),
    StoryModel(
      id: 'story_7',
      userId: 'sofia_music',
      mediaUrl: 'https://via.placeholder.com/300x500/98D8C8/FFFFFF?text=Story+7',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
      isViewed: false,
      duration: const Duration(seconds: 3),
      user: users[7], // sofia_music
    ),
    StoryModel(
      id: 'story_8',
      userId: 'rafael_tech',
      mediaUrl: 'https://via.placeholder.com/300x500/F7DC6F/FFFFFF?text=Story+8',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isViewed: true,
      duration: const Duration(seconds: 4),
      user: users[8], // rafael_tech
    ),
    StoryModel(
      id: 'story_9',
      userId: 'camila_design',
      mediaUrl: 'https://via.placeholder.com/300x500/BB8FCE/FFFFFF?text=Story+9',
      timestamp: DateTime.now().subtract(const Duration(hours: 9)),
      isViewed: false,
      duration: const Duration(seconds: 5),
      user: users[9], // camila_design
    ),
    StoryModel(
      id: 'story_10',
      userId: 'lucas_gamer',
      mediaUrl: 'https://via.placeholder.com/300x500/85C1E9/FFFFFF?text=Story+10',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      isViewed: true,
      duration: const Duration(seconds: 6),
      user: users[10], // lucas_gamer
    ),
  ];

  // Comentários mock
  static final List<CommentModel> comments = [
    CommentModel(
      id: 'comment_1',
      postId: 'post_1',
      userId: 'carlos_dev',
      text: 'Que foto incrível! 📸 A luz ficou perfeita!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      likesCount: 5,
      isLiked: false,
      user: users[2], // carlos_dev
    ),
    CommentModel(
      id: 'comment_2',
      postId: 'post_1',
      userId: 'maria_fitness',
      text: 'Adoro esse lugar! 😍 Já estive lá várias vezes.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      likesCount: 3,
      isLiked: true,
      user: users[3], // maria_fitness
    ),
    CommentModel(
      id: 'comment_3',
      postId: 'post_2',
      userId: 'ana_silva',
      text: 'Parabéns pelo projeto! 🚀 Flutter é incrível mesmo!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      likesCount: 8,
      isLiked: false,
      user: users[1], // ana_silva
    ),
    CommentModel(
      id: 'comment_4',
      postId: 'post_2',
      userId: 'rafael_tech',
      text: 'Ótimo trabalho! Qual versão do Flutter você está usando?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      likesCount: 2,
      isLiked: false,
      user: users[8], // rafael_tech
    ),
    CommentModel(
      id: 'comment_5',
      postId: 'post_3',
      userId: 'joao_travel',
      text: 'Inspiração total! 💪 Preciso voltar a treinar.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 12,
      isLiked: true,
      user: users[4], // joao_travel
    ),
    CommentModel(
      id: 'comment_6',
      postId: 'post_4',
      userId: 'lucia_art',
      text: 'Que lugar mágico! 🏔️ Adoraria conhecer um dia.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      likesCount: 7,
      isLiked: false,
      user: users[5], // lucia_art
    ),
    CommentModel(
      id: 'comment_7',
      postId: 'post_5',
      userId: 'pedro_food',
      text: 'Arte incrível! 🎨 Você tem muito talento!',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      likesCount: 9,
      isLiked: true,
      user: users[6], // pedro_food
    ),
    CommentModel(
      id: 'comment_8',
      postId: 'post_6',
      userId: 'sofia_music',
      text: 'Que delícia! 🍤 Preciso dessa receita!',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 15,
      isLiked: false,
      user: users[7], // sofia_music
    ),
    CommentModel(
      id: 'comment_9',
      postId: 'post_7',
      userId: 'camila_design',
      text: 'Ansiosa pelo lançamento! 🎵 Sua voz é linda!',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      likesCount: 11,
      isLiked: true,
      user: users[9], // camila_design
    ),
    CommentModel(
      id: 'comment_10',
      postId: 'post_8',
      userId: 'lucas_gamer',
      text: 'IA é o futuro! 🤖 Workshop muito interessante!',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
      likesCount: 6,
      isLiked: false,
      user: users[10], // lucas_gamer
    ),
  ];

  // Métodos para obter dados específicos
  static List<PostModel> getPosts() => posts;
  static List<StoryModel> getStories() => stories;
  static List<CommentModel> getComments() => comments;
  
  static List<PostModel> getPostsByUserModel(String userId) {
    return posts.where((post) => post.userId == userId).toList();
  }
  
  static List<CommentModel> getCommentsByPostModel(String postId) {
    return comments.where((comment) => comment.postId == postId).toList();
  }
  
  static List<StoryModel> getStoriesByUserModel(String userId) {
    return stories.where((story) => story.userId == userId).toList();
  }
  
  static PostModel? getPostById(String id) {
    try {
      return posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static StoryModel? getStoryById(String id) {
    try {
      return stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static CommentModel? getCommentById(String id) {
    try {
      return comments.firstWhere((comment) => comment.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Métodos adicionais para compatibilidade
  static UserModel getCurrentUser() {
    return getCurrentUserModel();
  }
  
  static List<StoryModel> getStoriesByUser(String userId) {
    return getStoriesByUserModel(userId);
  }
  
  static StoryModel? getStoryModelById(String id) {
    return getStoryById(id);
  }
  
  static List<UserModel> getRandomUserModels({int count = 5}) {
    return getRandomUsers(count: count);
  }
  
  static UserModel? getUserModelById(String id) {
    return getUserById(id);
  }
}
