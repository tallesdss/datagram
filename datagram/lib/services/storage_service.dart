import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path_lib;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// Serviço para gerenciar uploads e downloads de arquivos no Supabase Storage
class StorageService {
  final SupabaseClient _client = SupabaseService().client;
  
  /// Nome do bucket principal para mídia
  String get _bucketName => dotenv.env['STORAGE_BUCKET_NAME'] ?? 'datagram-media';
  
  /// Tamanho máximo de arquivo em MB
  int get _maxFileSizeMB => int.tryParse(dotenv.env['MAX_FILE_SIZE_MB'] ?? '10') ?? 10;
  
  /// Tipos de arquivo permitidos
  List<String> get _allowedFileTypes => 
      (dotenv.env['ALLOWED_FILE_TYPES'] ?? 'jpg,jpeg,png,gif,mp4,mov').split(',');
  
  /// Upload de imagem para o bucket especificado
  Future<String> uploadImage({
    required File image,
    required String path,
    String? bucket,
  }) async {
    return await _uploadFile(
      file: image,
      path: path,
      bucket: bucket ?? _bucketName,
      isImage: true,
    );
  }
  
  /// Upload de vídeo para o bucket especificado
  Future<String> uploadVideo({
    required File video,
    required String path,
    String? bucket,
  }) async {
    return await _uploadFile(
      file: video,
      path: path,
      bucket: bucket ?? _bucketName,
      isImage: false,
    );
  }
  
  /// Upload genérico de arquivo
  Future<String> _uploadFile({
    required File file,
    required String path,
    required String bucket,
    required bool isImage,
  }) async {
    // Verificar se o usuário está autenticado
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    // Validar tipo de arquivo
    final fileExtension = path_lib.extension(file.path).toLowerCase().substring(1);
    if (!_allowedFileTypes.contains(fileExtension)) {
      throw Exception('Tipo de arquivo não permitido: $fileExtension');
    }
    
    // Validar tamanho do arquivo
    final fileSizeMB = await file.length() / (1024 * 1024);
    if (fileSizeMB > _maxFileSizeMB) {
      throw Exception('Arquivo muito grande. Limite: ${_maxFileSizeMB}MB');
    }
    
    // Criar caminho com ID do usuário
    final fileName = '$path$fileExtension';
    final fullPath = '$userId/$fileName';
    
    // Upload do arquivo
    await _client.storage.from(bucket).upload(
      fullPath,
      file,
      fileOptions: FileOptions(
        cacheControl: '3600',
        upsert: true,
      ),
    );
    
    // Retornar URL pública do arquivo
    return getPublicUrl(bucket, fullPath);
  }
  
  /// Upload de avatar do usuário
  Future<String> uploadUserAvatar(File image) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    return await uploadImage(
      image: image,
      path: 'profile/avatar',
    );
  }
  
  /// Upload de imagem de post
  Future<String> uploadPostImage(File image, String postId) async {
    return await uploadImage(
      image: image,
      path: 'posts/$postId/image',
    );
  }
  
  /// Upload de vídeo de post
  Future<String> uploadPostVideo(File video, String postId) async {
    return await uploadVideo(
      video: video,
      path: 'posts/$postId/video',
    );
  }
  
  /// Upload de story (imagem ou vídeo)
  Future<String> uploadStoryMedia(File media, String storyId, {bool isVideo = false}) async {
    if (isVideo) {
      return await uploadVideo(
        video: media,
        path: 'stories/$storyId/video',
      );
    } else {
      return await uploadImage(
        image: media,
        path: 'stories/$storyId/image',
      );
    }
  }
  
  /// Deletar arquivo do bucket especificado
  Future<void> deleteFile({
    required String path,
    String? bucket,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    final fullPath = '$userId/$path';
    await _client.storage.from(bucket ?? _bucketName).remove([fullPath]);
  }
  
  /// Deletar imagem do bucket especificado
  Future<void> deleteImage({
    required String path,
    String? bucket,
  }) async {
    await deleteFile(path: path, bucket: bucket);
  }
  
  /// Obter URL pública de um arquivo
  String getPublicUrl(String bucket, String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }
  
  /// Obter URL assinada para arquivos privados
  Future<String> getSignedUrl(String bucket, String path, {int expiresIn = 3600}) async {
    final response = await _client.storage.from(bucket).createSignedUrl(
      path,
      expiresIn,
    );
    return response;
  }
  
  /// Listar arquivos de um usuário
  Future<List<FileObject>> listUserFiles({
    String? bucket,
    String? folder,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuário não autenticado');
    
    final searchPath = folder != null ? '$userId/$folder' : userId;
    return await _client.storage.from(bucket ?? _bucketName).list(
      path: searchPath,
    );
  }
  
  /// Verificar se um arquivo existe
  Future<bool> fileExists(String bucket, String path) async {
    try {
      await _client.storage.from(bucket).download(path);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Obter informações de um arquivo
  Future<FileObject?> getFileInfo(String bucket, String path) async {
    try {
      final files = await _client.storage.from(bucket).list(
        path: path_lib.dirname(path),
      );
      return files.firstWhere(
        (file) => file.name == path_lib.basename(path),
        orElse: () => throw Exception('Arquivo não encontrado'),
      );
    } catch (e) {
      return null;
    }
  }
}
