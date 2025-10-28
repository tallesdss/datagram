import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase (que também carrega as variáveis de ambiente)
  await SupabaseService().initialize();
  
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
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      
      // Atualizar o estado de autenticação quando houver mudanças
      if (event == AuthChangeEvent.signedIn || 
          event == AuthChangeEvent.signedOut ||
          event == AuthChangeEvent.userUpdated) {
        // Forçar o provider a atualizar o estado
        ref.invalidate(authProvider);
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