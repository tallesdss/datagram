import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/providers.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Câmera'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeria'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createPost() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Criar o post com upload da imagem
      await ref.read(postProvider.notifier).createPostWithImage(
        imageFile: _imageFile!,
        caption: _captionController.text.trim(),
        location: _locationController.text.trim().isEmpty 
            ? null 
            : _locationController.text.trim(),
      );
      
      if (!mounted) return;
      
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post criado com sucesso!')),
      );
      
      // Voltar para a tela anterior
      Navigator.pop(context);
      
    } catch (e) {
      if (!mounted) return;
      
      // Mostrar mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar post: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_imageFile != null)
            TextButton(
              onPressed: _isLoading ? null : _createPost,
              child: _isLoading 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Compartilhar'),
            ),
        ],
      ),
      body: _imageFile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'Selecione uma imagem para o seu post',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _showImageSourceOptions,
                    child: const Text('Selecionar Imagem'),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                // Header com informações do usuário
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(currentUser?.profileImageUrl ?? ''),
                        radius: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        currentUser?.username ?? 'Usuário',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Imagem selecionada
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    _imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Campo de legenda
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      hintText: 'Escreva uma legenda...',
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                ),
                
                const Divider(),
                
                // Campo de localização
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'Adicionar localização',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                ),
                
                const Divider(),
                
                // Opções adicionais
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Marcar pessoas'),
                  onTap: () {
                    // Implementar funcionalidade de marcar pessoas
                  },
                ),
                
                ListTile(
                  leading: const Icon(Icons.label_outline),
                  title: const Text('Adicionar hashtags'),
                  onTap: () {
                    // Implementar funcionalidade de adicionar hashtags
                  },
                ),
                
                ListTile(
                  leading: const Icon(Icons.music_note_outlined),
                  title: const Text('Adicionar música'),
                  onTap: () {
                    // Implementar funcionalidade de adicionar música
                  },
                ),
              ],
            ),
    );
  }
}
