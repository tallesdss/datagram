import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import 'storage_service.dart';

/// Serviço para gerenciar autenticação e perfil de usuário
class AuthService {
  final SupabaseClient _client = SupabaseService().client;
  final StorageService _storageService = StorageService();
  
  /// Cadastrar novo usuário
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    // Verificar se o username já existe
    final usernameExists = await _client
        .from('users')
        .select()
        .eq('username', username)
        .maybeSingle();
    
    if (usernameExists != null) {
      throw Exception('Nome de usuário já está em uso');
    }
    
    // Criar o usuário na autenticação
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    
    // Criar o perfil do usuário
    if (response.user != null) {
      await _client.from('users').insert({
        'id': response.user!.id,
        'username': username,
        'full_name': fullName,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
    
    return response;
  }
  
  /// Login com email e senha
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  /// Obter usuário atual autenticado
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }
  
  /// Atualizar dados do perfil
  Future<void> updateProfile({
    required Map<String, dynamic> userData,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    await _client.from('users').update(userData).eq('id', userId);
  }
  
  /// Fazer upload de foto de perfil
  Future<String> uploadProfileImage(File image) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    final imagePath = 'profiles/$userId.jpg';
    final imageUrl = await _storageService.uploadImage(
      image: image,
      bucket: 'profiles',
      path: imagePath,
    );
    
    // Atualizar URL da imagem no perfil do usuário
    await updateProfile(userData: {'profile_image_url': imageUrl});
    
    return imageUrl;
  }
  
  /// Stream de mudanças no estado de autenticação
  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }
}
