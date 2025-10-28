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
    // Carrega as variáveis de ambiente do arquivo .env
    await dotenv.load(fileName: ".env");
    
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Variáveis SUPABASE_URL e SUPABASE_ANON_KEY são obrigatórias');
    }
    
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
