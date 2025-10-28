import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/post_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/theme/app_theme.dart';

/// Provider para gerenciar o estado da criação de post
final createPostProvider = StateNotifierProvider<CreatePostNotifier, CreatePostState>((ref) {
  return CreatePostNotifier();
});

/// Estado da criação de post
class CreatePostState {
  final Uint8List? selectedImageBytes;
  final String caption;
  final String? location;
  final bool isLoading;
  final String? error;

  const CreatePostState({
    this.selectedImageBytes,
    this.caption = '',
    this.location,
    this.isLoading = false,
    this.error,
  });

  CreatePostState copyWith({
    Uint8List? selectedImageBytes,
    String? caption,
    String? location,
    bool? isLoading,
    String? error,
  }) {
    return CreatePostState(
      selectedImageBytes: selectedImageBytes ?? this.selectedImageBytes,
      caption: caption ?? this.caption,
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Notifier para gerenciar o estado da criação de post
class CreatePostNotifier extends StateNotifier<CreatePostState> {
  final ImagePicker _imagePicker = ImagePicker();

  CreatePostNotifier() : super(const CreatePostState());

  /// Selecionar imagem da galeria
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        state = state.copyWith(
          selectedImageBytes: bytes,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Erro ao selecionar imagem: $e');
    }
  }

  /// Selecionar imagem da câmera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        final bytes = await image.readAsBytes();
        state = state.copyWith(
          selectedImageBytes: bytes,
          error: null,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Erro ao capturar imagem: $e');
    }
  }

  /// Atualizar legenda
  void updateCaption(String caption) {
    state = state.copyWith(caption: caption);
  }

  /// Atualizar localização
  void updateLocation(String? location) {
    state = state.copyWith(location: location);
  }

  /// Remover imagem selecionada
  void removeImage() {
    state = state.copyWith(selectedImageBytes: null);
  }

  /// Criar post
  Future<void> createPost(WidgetRef ref, BuildContext context) async {
    if (state.selectedImageBytes == null) {
      state = state.copyWith(error: 'Selecione uma imagem para postar');
      return;
    }

    if (state.caption.trim().isEmpty) {
      state = state.copyWith(error: 'Digite uma legenda para o post');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // Verificar se o usuário está autenticado
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        state = state.copyWith(
          isLoading: false,
          error: 'Usuário não autenticado. Faça login novamente.',
        );
        return;
      }

      print('DEBUG: Iniciando criação do post...');
      print('DEBUG: Usuário autenticado: ${authState.authUser?.id}');
      print('DEBUG: Tamanho da imagem: ${state.selectedImageBytes!.length} bytes');
      print('DEBUG: Legenda: ${state.caption.trim()}');

      await ref.read(postProvider.notifier).createPostWithImageBytes(
        imageBytes: state.selectedImageBytes!,
        caption: state.caption.trim(),
        location: state.location?.trim(),
      );

      print('DEBUG: Post criado com sucesso!');

      // Limpar estado após sucesso
      state = const CreatePostState();
      
      // Mostrar mensagem de sucesso e fechar a tela
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post criado com sucesso!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
      
    } catch (e) {
      print('DEBUG: Erro ao criar post: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Erro ao criar post: $e',
      );
    }
  }

  /// Limpar erro
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Tela para criar um novo post
class CreatePostScreen extends ConsumerWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createPostProvider);
    final notifier = ref.read(createPostProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Nova Postagem',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: state.isLoading || state.selectedImageBytes == null
                ? null
                : () => notifier.createPost(ref, context),
            child: Text(
              'Compartilhar',
              style: TextStyle(
                color: state.isLoading || state.selectedImageBytes == null
                    ? AppTheme.textColor.withValues(alpha: 0.5)
                    : AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Seletor de imagem
          _buildImageSelector(context, state, notifier),
          
          // Formulário de post
          Expanded(
            child: _buildPostForm(context, state, notifier),
          ),
        ],
      ),
    );
  }

  /// Widget para seleção de imagem
  Widget _buildImageSelector(
    BuildContext context,
    CreatePostState state,
    CreatePostNotifier notifier,
  ) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: state.selectedImageBytes != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    state.selectedImageBytes!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: notifier.removeImage,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 64,
                  color: AppTheme.textColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Adicionar Foto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha uma foto da galeria ou tire uma nova',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textColor.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceButton(
                      context,
                      'Galeria',
                      Icons.photo_library_outlined,
                      () => notifier.pickImageFromGallery(),
                    ),
                    _buildImageSourceButton(
                      context,
                      'Câmera',
                      Icons.camera_alt_outlined,
                      () => notifier.pickImageFromCamera(),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  /// Botão para fonte de imagem
  Widget _buildImageSourceButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Formulário do post
  Widget _buildPostForm(
    BuildContext context,
    CreatePostState state,
    CreatePostNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Campo de legenda
          Text(
            'Legenda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: notifier.updateCaption,
            maxLines: 4,
            maxLength: 2200,
            decoration: InputDecoration(
              hintText: 'Escreva uma legenda...',
              hintStyle: TextStyle(
                color: AppTheme.textColor.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              filled: true,
              fillColor: AppTheme.cardColor,
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(color: AppTheme.textColor),
          ),
          
          const SizedBox(height: 16),
          
          // Campo de localização (opcional)
          Text(
            'Localização (opcional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: notifier.updateLocation,
            decoration: InputDecoration(
              hintText: 'Adicionar localização...',
              hintStyle: TextStyle(
                color: AppTheme.textColor.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: AppTheme.textColor.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              filled: true,
              fillColor: AppTheme.cardColor,
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(color: AppTheme.textColor),
          ),
          
          const SizedBox(height: 24),
          
          // Mensagem de erro
          if (state.error != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: notifier.clearError,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Indicador de carregamento
          if (state.isLoading) ...[
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Criando post...',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
        ),
      ),
    );
  }
}