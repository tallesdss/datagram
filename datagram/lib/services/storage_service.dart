import 'dart:io';
import 'package:path/path.dart' as path_lib;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// Serviço para gerenciar uploads e downloads de arquivos no Supabase Storage
class StorageService {
  final SupabaseClient _client = SupabaseService().client;
  
  /// Upload de imagem para o bucket especificado
  Future<String> uploadImage({
    required File image,
    required String bucket,
    required String path,
  }) async {
    // Verificar se o usuário está autenticado
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Upload da imagem
    final fileExtension = path_lib.extension(image.path);
    final fileName = '$path$fileExtension';
    
    await _client.storage.from(bucket).upload(
      fileName,
      image,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: true,
      ),
    );
    
    // Retornar URL pública da imagem
    return getPublicUrl(bucket, fileName);
  }
  
  /// Deletar imagem do bucket especificado
  Future<void> deleteImage({
    required String bucket,
    required String path,
  }) async {
    await _client.storage.from(bucket).remove([path]);
  }
  
  /// Obter URL pública de uma imagem
  String getPublicUrl(String bucket, String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }
}
