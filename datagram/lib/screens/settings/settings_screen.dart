import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Seção de conta
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'CONTA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Editar perfil'),
            onTap: () {
              // Navegar para tela de editar perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Segurança'),
            onTap: () {
              // Navegar para tela de segurança
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacidade'),
            onTap: () {
              // Navegar para tela de privacidade
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            onTap: () {
              // Navegar para tela de notificações
            },
          ),
          
          const Divider(),
          
          // Seção de preferências
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'PREFERÊNCIAS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Tema escuro'),
            value: settings['darkMode'] as bool,
            onChanged: (value) {
              // Em uma implementação real, isso atualizaria o provider
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tema ${value ? 'escuro' : 'claro'} ativado')),
              );
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: const Text('Reprodução automática'),
            subtitle: const Text('Reproduzir vídeos automaticamente'),
            value: settings['autoPlay'] as bool,
            onChanged: (value) {
              // Em uma implementação real, isso atualizaria o provider
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reprodução automática ${value ? 'ativada' : 'desativada'}')),
              );
            },
            secondary: const Icon(Icons.play_circle),
          ),
          SwitchListTile(
            title: const Text('Economizador de dados'),
            subtitle: const Text('Reduzir uso de dados no aplicativo'),
            value: settings['dataSaver'] as bool,
            onChanged: (value) {
              // Em uma implementação real, isso atualizaria o provider
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Economizador de dados ${value ? 'ativado' : 'desativado'}')),
              );
            },
            secondary: const Icon(Icons.data_saver_off),
          ),
          
          const Divider(),
          
          // Seção de suporte
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'SUPORTE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Central de ajuda'),
            onTap: () {
              // Navegar para central de ajuda
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Relatar um problema'),
            onTap: () {
              // Navegar para relatar problema
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          
          const Divider(),
          
          // Seção de desenvolvimento
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'DESENVOLVIMENTO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Testar Supabase Storage'),
            subtitle: const Text('Verificar conexão e funcionalidade'),
            onTap: () {
              context.push('/test-storage');
            },
          ),
          
          const Divider(),
          
          // Seção de conta
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'CONTA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sair', style: TextStyle(color: Colors.red)),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
          
          // Informações do usuário
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Conectado como ${currentUser?.username ?? 'Usuário'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versão 1.0.0',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o Datagram'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datagram é um clone do Instagram desenvolvido com Flutter.'),
            SizedBox(height: 16),
            Text('Versão: 1.0.0'),
            Text('© 2025 Datagram'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
  
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fechar o diálogo
              Navigator.pop(context); // Voltar para a tela anterior
              // Em uma implementação real, aqui seria feito o logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout realizado com sucesso')),
              );
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
