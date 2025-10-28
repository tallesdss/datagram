import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/story_model.dart';
import '../models/comment_model.dart';

class MockData {
  // Usuários mock
  static final List<User> users = [
    const User(
      id: 'current_user',
      username: 'usuario_atual',
      fullName: 'Usuário Atual',
      profileImageUrl: 'https://picsum.photos/200/200?random=1',
      bio: 'Desenvolvedor Flutter apaixonado por tecnologia 📱',
      postsCount: 42,
      followersCount: 1250,
      followingCount: 380,
      isVerified: true,
    ),
    const User(
      id: 'user_1',
      username: 'ana_silva',
      fullName: 'Ana Silva',
      profileImageUrl: 'https://picsum.photos/200/200?random=2',
      bio: 'Fotógrafa profissional 📸 | São Paulo',
      postsCount: 156,
      followersCount: 8900,
      followingCount: 420,
      isVerified: true,
    ),
    const User(
      id: 'user_2',
      username: 'carlos_dev',
      fullName: 'Carlos Santos',
      profileImageUrl: 'https://picsum.photos/200/200?random=3',
      bio: 'Desenvolvedor Mobile | Tech Enthusiast',
      postsCount: 78,
      followersCount: 2100,
      followingCount: 650,
    ),
    const User(
      id: 'user_3',
      username: 'maria_fitness',
      fullName: 'Maria Oliveira',
      profileImageUrl: 'https://picsum.photos/200/200?random=4',
      bio: 'Personal Trainer 💪 | Vida saudável',
      postsCount: 234,
      followersCount: 15600,
      followingCount: 890,
      isVerified: true,
    ),
    const User(
      id: 'user_4',
      username: 'joao_travel',
      fullName: 'João Costa',
      profileImageUrl: 'https://picsum.photos/200/200?random=5',
      bio: 'Viajante 🌍 | Explorando o mundo',
      postsCount: 89,
      followersCount: 3200,
      followingCount: 1200,
    ),
    const User(
      id: 'user_5',
      username: 'lucia_art',
      fullName: 'Lúcia Fernandes',
      profileImageUrl: 'https://picsum.photos/200/200?random=6',
      bio: 'Artista Digital 🎨 | Criatividade sem limites',
      postsCount: 67,
      followersCount: 4500,
      followingCount: 320,
    ),
    const User(
      id: 'user_6',
      username: 'pedro_food',
      fullName: 'Pedro Lima',
      profileImageUrl: 'https://picsum.photos/200/200?random=7',
      bio: 'Chef de Cozinha 👨‍🍳 | Sabores únicos',
      postsCount: 123,
      followersCount: 7800,
      followingCount: 450,
    ),
    const User(
      id: 'user_7',
      username: 'sofia_music',
      fullName: 'Sofia Rodrigues',
      profileImageUrl: 'https://picsum.photos/200/200?random=8',
      bio: 'Cantora e Compositora 🎵 | Música é vida',
      postsCount: 45,
      followersCount: 12000,
      followingCount: 280,
      isVerified: true,
    ),
    const User(
      id: 'user_8',
      username: 'rafael_tech',
      fullName: 'Rafael Almeida',
      profileImageUrl: 'https://picsum.photos/200/200?random=9',
      bio: 'Tech Lead | Inovação e tecnologia',
      postsCount: 91,
      followersCount: 3400,
      followingCount: 520,
    ),
    const User(
      id: 'user_9',
      username: 'camila_design',
      fullName: 'Camila Barbosa',
      profileImageUrl: 'https://picsum.photos/200/200?random=10',
      bio: 'UI/UX Designer ✨ | Criando experiências incríveis',
      postsCount: 112,
      followersCount: 5600,
      followingCount: 380,
    ),
    const User(
      id: 'user_10',
      username: 'lucas_gamer',
      fullName: 'Lucas Pereira',
      profileImageUrl: 'https://picsum.photos/200/200?random=11',
      bio: 'Gamer Profissional 🎮 | Esports',
      postsCount: 78,
      followersCount: 8900,
      followingCount: 1200,
    ),
  ];

  // Método para obter usuário por ID
  static User? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para obter usuário atual
  static User getCurrentUser() {
    return getUserById('current_user') ?? users.first;
  }

  // Método para obter usuários aleatórios
  static List<User> getRandomUsers({int count = 5}) {
    final shuffled = List<User>.from(users)..shuffle();
    return shuffled.take(count).toList();
  }

  // Posts mock
  static final List<Post> posts = [
    Post(
      id: 'post_1',
      userId: 'ana_silva',
      imageUrl: 'https://picsum.photos/400/500?random=101',
      caption: 'Pôr do sol incrível hoje! 🌅 A natureza sempre nos surpreende com sua beleza única. #fotografia #natureza #pordosol',
      location: 'Praia de Copacabana, Rio de Janeiro',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 245,
      commentsCount: 18,
      isLiked: false,
      isSaved: false,
      user: users[1], // ana_silva
    ),
    Post(
      id: 'post_2',
      userId: 'carlos_dev',
      imageUrl: 'https://picsum.photos/400/500?random=102',
      caption: 'Novo projeto em Flutter! 🚀 Desenvolvendo um app incrível com as melhores práticas. #flutter #mobile #desenvolvimento',
      location: 'São Paulo, SP',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 89,
      commentsCount: 12,
      isLiked: true,
      isSaved: true,
      user: users[2], // carlos_dev
    ),
    Post(
      id: 'post_3',
      userId: 'maria_fitness',
      imageUrl: 'https://picsum.photos/400/500?random=103',
      caption: 'Treino matinal completo! 💪 Começar o dia com energia é fundamental. Quem mais ama acordar cedo para treinar?',
      location: 'Academia FitLife',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likesCount: 156,
      commentsCount: 24,
      isLiked: false,
      isSaved: false,
      user: users[3], // maria_fitness
    ),
    Post(
      id: 'post_4',
      userId: 'joao_travel',
      imageUrl: 'https://picsum.photos/400/500?random=104',
      caption: 'Explorando as montanhas do Peru! 🏔️ Cada viagem é uma nova aventura e uma oportunidade de crescimento pessoal.',
      location: 'Machu Picchu, Peru',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      likesCount: 312,
      commentsCount: 31,
      isLiked: true,
      isSaved: false,
      user: users[4], // joao_travel
    ),
    Post(
      id: 'post_5',
      userId: 'lucia_art',
      imageUrl: 'https://picsum.photos/400/500?random=105',
      caption: 'Nova obra digital! 🎨 Arte é expressão, é emoção, é vida. Cada pincelada conta uma história única.',
      location: 'Estúdio Artístico',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      likesCount: 178,
      commentsCount: 15,
      isLiked: false,
      isSaved: true,
      user: users[5], // lucia_art
    ),
    Post(
      id: 'post_6',
      userId: 'pedro_food',
      imageUrl: 'https://picsum.photos/400/500?random=106',
      caption: 'Receita especial do dia: Risotto de camarão! 🍤 Cozinhar é uma arte que une pessoas e cria memórias deliciosas.',
      location: 'Restaurante Sabor & Arte',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      likesCount: 267,
      commentsCount: 28,
      isLiked: true,
      isSaved: false,
      user: users[6], // pedro_food
    ),
    Post(
      id: 'post_7',
      userId: 'sofia_music',
      imageUrl: 'https://picsum.photos/400/500?random=107',
      caption: 'Gravando meu novo single! 🎵 A música tem o poder de tocar corações e transformar vidas. Em breve nas plataformas!',
      location: 'Estúdio Musical',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      likesCount: 445,
      commentsCount: 42,
      isLiked: false,
      isSaved: true,
      user: users[7], // sofia_music
    ),
    Post(
      id: 'post_8',
      userId: 'rafael_tech',
      imageUrl: 'https://picsum.photos/400/500?random=108',
      caption: 'Workshop de IA hoje! 🤖 Tecnologia e inovação caminhando juntas para um futuro melhor. #inteligenciaartificial #inovacao',
      location: 'Tech Conference 2024',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      likesCount: 123,
      commentsCount: 19,
      isLiked: true,
      isSaved: false,
      user: users[8], // rafael_tech
    ),
    Post(
      id: 'post_9',
      userId: 'camila_design',
      imageUrl: 'https://picsum.photos/400/500?random=109',
      caption: 'Novo design de interface! ✨ UX/UI é sobre criar experiências que conectam pessoas e tecnologia de forma intuitiva.',
      location: 'Design Studio',
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      likesCount: 198,
      commentsCount: 22,
      isLiked: false,
      isSaved: true,
      user: users[9], // camila_design
    ),
    Post(
      id: 'post_10',
      userId: 'lucas_gamer',
      imageUrl: 'https://picsum.photos/400/500?random=110',
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
  static final List<Story> stories = [
    Story(
      id: 'story_1',
      userId: 'ana_silva',
      mediaUrl: 'https://picsum.photos/300/500?random=201',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isViewed: false,
      duration: const Duration(seconds: 5),
      user: users[1], // ana_silva
    ),
    Story(
      id: 'story_2',
      userId: 'carlos_dev',
      mediaUrl: 'https://picsum.photos/300/500?random=202',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isViewed: true,
      duration: const Duration(seconds: 3),
      user: users[2], // carlos_dev
    ),
    Story(
      id: 'story_3',
      userId: 'maria_fitness',
      mediaUrl: 'https://picsum.photos/300/500?random=203',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isViewed: false,
      duration: const Duration(seconds: 4),
      user: users[3], // maria_fitness
    ),
    Story(
      id: 'story_4',
      userId: 'joao_travel',
      mediaUrl: 'https://picsum.photos/300/500?random=204',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isViewed: true,
      duration: const Duration(seconds: 6),
      user: users[4], // joao_travel
    ),
    Story(
      id: 'story_5',
      userId: 'lucia_art',
      mediaUrl: 'https://picsum.photos/300/500?random=205',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isViewed: false,
      duration: const Duration(seconds: 4),
      user: users[5], // lucia_art
    ),
    Story(
      id: 'story_6',
      userId: 'pedro_food',
      mediaUrl: 'https://picsum.photos/300/500?random=206',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isViewed: true,
      duration: const Duration(seconds: 5),
      user: users[6], // pedro_food
    ),
    Story(
      id: 'story_7',
      userId: 'sofia_music',
      mediaUrl: 'https://picsum.photos/300/500?random=207',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
      isViewed: false,
      duration: const Duration(seconds: 3),
      user: users[7], // sofia_music
    ),
    Story(
      id: 'story_8',
      userId: 'rafael_tech',
      mediaUrl: 'https://picsum.photos/300/500?random=208',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isViewed: true,
      duration: const Duration(seconds: 4),
      user: users[8], // rafael_tech
    ),
    Story(
      id: 'story_9',
      userId: 'camila_design',
      mediaUrl: 'https://picsum.photos/300/500?random=209',
      timestamp: DateTime.now().subtract(const Duration(hours: 9)),
      isViewed: false,
      duration: const Duration(seconds: 5),
      user: users[9], // camila_design
    ),
    Story(
      id: 'story_10',
      userId: 'lucas_gamer',
      mediaUrl: 'https://picsum.photos/300/500?random=210',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      isViewed: true,
      duration: const Duration(seconds: 6),
      user: users[10], // lucas_gamer
    ),
  ];

  // Comentários mock
  static final List<Comment> comments = [
    Comment(
      id: 'comment_1',
      postId: 'post_1',
      userId: 'carlos_dev',
      text: 'Que foto incrível! 📸 A luz ficou perfeita!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      likesCount: 5,
      isLiked: false,
      user: users[2], // carlos_dev
    ),
    Comment(
      id: 'comment_2',
      postId: 'post_1',
      userId: 'maria_fitness',
      text: 'Adoro esse lugar! 😍 Já estive lá várias vezes.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      likesCount: 3,
      isLiked: true,
      user: users[3], // maria_fitness
    ),
    Comment(
      id: 'comment_3',
      postId: 'post_2',
      userId: 'ana_silva',
      text: 'Parabéns pelo projeto! 🚀 Flutter é incrível mesmo!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      likesCount: 8,
      isLiked: false,
      user: users[1], // ana_silva
    ),
    Comment(
      id: 'comment_4',
      postId: 'post_2',
      userId: 'rafael_tech',
      text: 'Ótimo trabalho! Qual versão do Flutter você está usando?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
      likesCount: 2,
      isLiked: false,
      user: users[8], // rafael_tech
    ),
    Comment(
      id: 'comment_5',
      postId: 'post_3',
      userId: 'joao_travel',
      text: 'Inspiração total! 💪 Preciso voltar a treinar.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 12,
      isLiked: true,
      user: users[4], // joao_travel
    ),
    Comment(
      id: 'comment_6',
      postId: 'post_4',
      userId: 'lucia_art',
      text: 'Que lugar mágico! 🏔️ Adoraria conhecer um dia.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      likesCount: 7,
      isLiked: false,
      user: users[5], // lucia_art
    ),
    Comment(
      id: 'comment_7',
      postId: 'post_5',
      userId: 'pedro_food',
      text: 'Arte incrível! 🎨 Você tem muito talento!',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      likesCount: 9,
      isLiked: true,
      user: users[6], // pedro_food
    ),
    Comment(
      id: 'comment_8',
      postId: 'post_6',
      userId: 'sofia_music',
      text: 'Que delícia! 🍤 Preciso dessa receita!',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likesCount: 15,
      isLiked: false,
      user: users[7], // sofia_music
    ),
    Comment(
      id: 'comment_9',
      postId: 'post_7',
      userId: 'camila_design',
      text: 'Ansiosa pelo lançamento! 🎵 Sua voz é linda!',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      likesCount: 11,
      isLiked: true,
      user: users[9], // camila_design
    ),
    Comment(
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
  static List<Post> getPosts() => posts;
  static List<Story> getStories() => stories;
  static List<Comment> getComments() => comments;
  
  static List<Post> getPostsByUser(String userId) {
    return posts.where((post) => post.userId == userId).toList();
  }
  
  static List<Comment> getCommentsByPost(String postId) {
    return comments.where((comment) => comment.postId == postId).toList();
  }
  
  static List<Story> getStoriesByUser(String userId) {
    return stories.where((story) => story.userId == userId).toList();
  }
  
  static Post? getPostById(String id) {
    try {
      return posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static Story? getStoryById(String id) {
    try {
      return stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }
  
  static Comment? getCommentById(String id) {
    try {
      return comments.firstWhere((comment) => comment.id == id);
    } catch (e) {
      return null;
    }
  }
}
