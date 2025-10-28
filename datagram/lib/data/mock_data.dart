import '../models/user_model.dart';

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
}
