import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/services.dart';
import '../models/user_model.dart';

// Enumeração para representar o estado de autenticação
enum AuthStatus {
  initial, // Estado inicial, ainda não verificou o usuário
  authenticated, // Usuário autenticado
  unauthenticated, // Usuário não autenticado
  loading, // Carregando
  error, // Erro de autenticação
}

// Classe para representar o estado de autenticação
class AuthState {
  final AuthStatus status;
  final User? authUser; // Usuário do Supabase Auth
  final UserModel? userProfile; // Perfil do usuário no banco de dados
  final String? errorMessage;

  AuthState({
    this.status = AuthStatus.initial,
    this.authUser,
    this.userProfile,
    this.errorMessage,
  });

  // Criar uma cópia do estado com alterações
  AuthState copyWith({
    AuthStatus? status,
    User? authUser,
    UserModel? userProfile,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
    );
  }

  // Estado inicial
  factory AuthState.initial() => AuthState(status: AuthStatus.initial);

  // Estado de carregamento
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);

  // Estado autenticado
  factory AuthState.authenticated(User authUser, UserModel userProfile) => 
      AuthState(
        status: AuthStatus.authenticated,
        authUser: authUser,
        userProfile: userProfile,
      );

  // Estado não autenticado
  factory AuthState.unauthenticated() => 
      AuthState(status: AuthStatus.unauthenticated);

  // Estado de erro
  factory AuthState.error(String message) => 
      AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  // Verificar se o usuário está autenticado
  bool get isAuthenticated => status == AuthStatus.authenticated;

  // Verificar se o estado está carregando
  bool get isLoading => status == AuthStatus.loading;
}

// Notifier para gerenciar o estado de autenticação
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final UserService _userService;

  AuthNotifier({
    required AuthService authService,
    required UserService userService,
  })  : _authService = authService,
        _userService = userService,
        super(AuthState.initial()) {
    // Inicializar o estado de autenticação
    _initialize();
  }

  // Inicializar o estado de autenticação
  Future<void> _initialize() async {
    state = AuthState.loading();
    
    try {
      // Obter o usuário atual do Supabase Auth
      final authUser = _authService.getCurrentUser();
      
      if (authUser != null) {
        // Obter o perfil do usuário do banco de dados
        final userProfile = await _userService.getUser(authUser.id);
        
        if (userProfile != null) {
          state = AuthState.authenticated(authUser, userProfile);
        } else {
          // Usuário autenticado, mas sem perfil no banco
          state = AuthState.unauthenticated();
        }
      } else {
        // Usuário não autenticado
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Login com email e senha
  Future<void> signIn({required String email, required String password}) async {
    state = AuthState.loading();
    
    try {
      // Fazer login
      final response = await _authService.signIn(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        // Obter o perfil do usuário
        final userProfile = await _userService.getUser(response.user!.id);
        
        if (userProfile != null) {
          state = AuthState.authenticated(response.user!, userProfile);
        } else {
          state = AuthState.error('Perfil de usuário não encontrado');
        }
      } else {
        state = AuthState.error('Falha ao fazer login');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Cadastro de novo usuário
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    state = AuthState.loading();
    
    try {
      // Criar novo usuário
      final response = await _authService.signUp(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );
      
      if (response.user != null) {
        // Obter o perfil do usuário
        final userProfile = await _userService.getUser(response.user!.id);
        
        if (userProfile != null) {
          state = AuthState.authenticated(response.user!, userProfile);
        } else {
          state = AuthState.error('Perfil de usuário não encontrado');
        }
      } else {
        state = AuthState.error('Falha ao criar conta');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateProfile(Map<String, dynamic> userData) async {
    if (state.authUser == null) return;
    
    try {
      await _authService.updateProfile(userData: userData);
      
      // Atualizar o estado com o novo perfil
      final updatedProfile = await _userService.getUser(state.authUser!.id);
      
      if (updatedProfile != null) {
        state = state.copyWith(userProfile: updatedProfile);
      }
    } catch (e) {
      // Não alterar o estado em caso de erro ao atualizar o perfil
    }
  }
}

// Provider para o serviço de autenticação
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provider para o serviço de usuário
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

// Provider para o estado de autenticação
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final userService = ref.watch(userServiceProvider);
  
  return AuthNotifier(
    authService: authService,
    userService: userService,
  );
});

// Provider para o usuário atual autenticado
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.userProfile;
});

// Provider para verificar se o usuário está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});
