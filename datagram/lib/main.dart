import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase (que também carrega as variáveis de ambiente)
  await SupabaseService().initialize();
  
  // Login automático para testes (temporário)
  try {
    final supabase = SupabaseService().client;
    await supabase.auth.signInWithPassword(
      email: 'teste@email.com',
      password: '123456', // Senha padrão para testes
    );
  } catch (e) {
    // Erro no login automático - continuar sem autenticação
  }
  
  runApp(
    const ProviderScope(
      child: DatagramApp(),
    ),
  );
}

class DatagramApp extends ConsumerStatefulWidget {
  const DatagramApp({super.key});

  @override
  ConsumerState<DatagramApp> createState() => _DatagramAppState();
}

class _DatagramAppState extends ConsumerState<DatagramApp> {
  @override
  void initState() {
    super.initState();
    
    // Adicionar listener para mudanças no estado de autenticação do Supabase
    // Usar WidgetsBinding para garantir que o widget está montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
          if (!mounted) return;
          
          final AuthChangeEvent event = data.event;
          
          // Atualizar o estado de autenticação quando houver mudanças
          if (event == AuthChangeEvent.signedIn || 
              event == AuthChangeEvent.signedOut ||
              event == AuthChangeEvent.userUpdated) {
            // Forçar o provider a atualizar o estado
            if (mounted) {
              ref.invalidate(authProvider);
            }
          }
        });
      } catch (e) {
        // Ignorar erros de listener se o Supabase não estiver inicializado
        debugPrint('Erro ao configurar listener de auth: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Observar o estado de autenticação para atualizar o router
    ref.watch(authProvider);
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Datagram',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}