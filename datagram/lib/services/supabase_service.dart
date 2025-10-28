import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Classe singleton para gerenciar a inicialização e acesso ao cliente Supabase
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  
  factory SupabaseService() {
    return _instance;
  }
  
  SupabaseService._internal();
  
  /// Inicializa o cliente Supabase
  Future<void> initialize() async {
    // Tentar carregar as variáveis de ambiente do arquivo .env
    try {
      await dotenv.load(fileName: "assets/.env");
    } catch (e) {
      // Se não conseguir carregar o .env, usar valores padrão
    }
    
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'https://hbtsnmunidejqpsdinux.supabase.co';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhidHNubXVuaWRlanFwc2RpbnV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2NTcyMzAsImV4cCI6MjA3NzIzMzIzMH0.6YNw8xiS10tFfvTysfzumgqh3WwoHhYM0YJRsRWrBaM';
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  /// Getter para acessar o cliente Supabase
  SupabaseClient get client => Supabase.instance.client;
  
  /// Verifica se o Supabase está inicializado
  bool get isInitialized => url.isNotEmpty && anonKey.isNotEmpty;
  
  /// Obtém a URL do Supabase
  String get url => dotenv.env['SUPABASE_URL'] ?? '';
  
  /// Obtém a chave anônima
  String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}
