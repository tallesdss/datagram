// import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    // Em uma implementação real, usaríamos dotenv:
    // await dotenv.load();
    // final supabaseUrl = dotenv.env['SUPABASE_URL'];
    // final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    // Por enquanto, usaremos valores fixos para demonstração
    const supabaseUrl = 'https://hbtsnmunidejqpsdinux.supabase.co';
    const supabaseAnonKey = 'sua_anon_key_aqui'; // Substituir por chave real em produção
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  /// Getter para acessar o cliente Supabase
  SupabaseClient get client => Supabase.instance.client;
}
