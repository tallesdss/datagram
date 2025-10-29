import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Classe singleton para gerenciar a inicialização e acesso ao cliente Supabase
class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  
  factory SupabaseService() {
    return _instance;
  }
  
  SupabaseService._internal();
  
  // Valores padrão para fallback
  static const String _defaultSupabaseUrl = 'https://hbtsnmunidejqpsdinux.supabase.co';
  static const String _defaultSupabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhidHNubXVuaWRlanFwc2RpbnV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2NTcyMzAsImV4cCI6MjA3NzIzMzIzMH0.6YNw8xiS10tFfvTysfzumgqh3WwoHhYM0YJRsRWrBaM';
  
  // Armazenar os valores após inicialização
  String _supabaseUrl = _defaultSupabaseUrl;
  String _supabaseAnonKey = _defaultSupabaseAnonKey;
  
  /// Inicializa o cliente Supabase
  Future<void> initialize() async {
    // Tentar carregar as variáveis de ambiente do arquivo .env
    bool dotenvLoaded = false;
    try {
      await dotenv.load(fileName: "assets/.env");
      dotenvLoaded = true;
    } catch (e) {
      // Se não conseguir carregar o .env, usar valores padrão
      // Isso pode acontecer na web ou se o arquivo não existir
      dotenvLoaded = false;
    }
    
    // Obter valores do .env se disponível, caso contrário usar padrões
    if (dotenvLoaded) {
      try {
        _supabaseUrl = dotenv.env['SUPABASE_URL'] ?? _defaultSupabaseUrl;
        _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? _defaultSupabaseAnonKey;
      } catch (e) {
        // Se houver erro ao acessar dotenv.env, usar valores padrão
        _supabaseUrl = _defaultSupabaseUrl;
        _supabaseAnonKey = _defaultSupabaseAnonKey;
      }
    } else {
      _supabaseUrl = _defaultSupabaseUrl;
      _supabaseAnonKey = _defaultSupabaseAnonKey;
    }
    
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }
  
  /// Getter para acessar o cliente Supabase
  SupabaseClient get client => Supabase.instance.client;
  
  /// Verifica se o Supabase está inicializado
  bool get isInitialized => _supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty;
  
  /// Obtém a URL do Supabase
  String get url => _supabaseUrl;
  
  /// Obtém a chave anônima
  String get anonKey => _supabaseAnonKey;
}
