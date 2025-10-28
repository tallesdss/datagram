import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_service.dart';
import 'services/storage_service.dart';

/// Widget de teste para verificar se o Supabase Storage está funcionando
class TestStorageWidget extends ConsumerStatefulWidget {
  const TestStorageWidget({super.key});

  @override
  ConsumerState<TestStorageWidget> createState() => _TestStorageWidgetState();
}

class _TestStorageWidgetState extends ConsumerState<TestStorageWidget> {
  final StorageService _storageService = StorageService();
  String _status = 'Inicializando teste...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _testStorageConnection();
  }

  Future<void> _testStorageConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testando conexão com Supabase Storage...';
    });

    try {
      // Testar conexão básica
      final supabaseService = SupabaseService();
      final client = supabaseService.client;
      
      setState(() {
        _status = '✅ Supabase client conectado\n';
      });

      // Testar listagem de buckets
      final buckets = await client.storage.listBuckets();
      setState(() {
        _status += '✅ Buckets encontrados: ${buckets.length}\n';
        for (final bucket in buckets) {
          _status += '   - ${bucket.name} (público: ${bucket.public})\n';
        }
      });

      // Verificar se o bucket datagram-media existe
      final datagramBucket = buckets.where((b) => b.name == 'datagram-media').isNotEmpty;
      if (datagramBucket) {
        setState(() {
          _status += '✅ Bucket datagram-media encontrado\n';
        });
      } else {
        setState(() {
          _status += '❌ Bucket datagram-media NÃO encontrado\n';
        });
      }

      // Testar listagem de arquivos no bucket
      try {
        final files = await client.storage.from('datagram-media').list();
        setState(() {
          _status += '✅ Listagem de arquivos funcionando\n';
          _status += '   Arquivos encontrados: ${files.length}\n';
        });
      } catch (e) {
        setState(() {
          _status += '❌ Erro ao listar arquivos: $e\n';
        });
      }

      // Testar URL pública
      try {
        final publicUrl = client.storage.from('datagram-media').getPublicUrl('test.txt');
        setState(() {
          _status += '✅ Geração de URL pública funcionando\n';
          _status += '   URL exemplo: $publicUrl\n';
        });
      } catch (e) {
        setState(() {
          _status += '❌ Erro ao gerar URL pública: $e\n';
        });
      }

    } catch (e) {
      setState(() {
        _status += '❌ Erro na conexão: $e\n';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testUpload() async {
    setState(() {
      _isLoading = true;
      _status += '\n🧪 Testando upload de arquivo...\n';
    });

    try {
      // Criar um arquivo de teste em memória
      final testContent = 'Teste de upload - ${DateTime.now()}';
      final tempFile = File('${Directory.systemTemp.path}/test_storage.txt');
      await tempFile.writeAsString(testContent);

      // Tentar fazer upload
      final url = await _storageService.uploadImage(
        image: tempFile,
        path: 'test/upload_test',
      );

      setState(() {
        _status += '✅ Upload realizado com sucesso!\n';
        _status += '   URL: $url\n';
      });

      // Limpar arquivo temporário
      await tempFile.delete();

    } catch (e) {
      setState(() {
        _status += '❌ Erro no upload: $e\n';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste Supabase Storage'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status do Supabase Storage',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _status,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testStorageConnection,
                    child: const Text('Testar Conexão'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _testUpload,
                    child: const Text('Testar Upload'),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
