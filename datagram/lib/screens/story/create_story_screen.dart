import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  File? _mediaFile;
  bool _isLoading = false;
  bool _isVideo = false;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textController = TextEditingController();
  Color _selectedColor = Colors.black;
  double _textSize = 20.0;
  final List<Color> _colorOptions = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _mediaFile = File(pickedFile.path);
          _isVideo = false;
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

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _mediaFile = File(pickedFile.path);
          _isVideo = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar vídeo: $e')),
        );
      }
    }
  }

  void _showMediaSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Tirar Foto'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Escolher da Galeria'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text('Gravar Vídeo'),
            onTap: () {
              Navigator.pop(context);
              _pickVideo(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_library),
            title: const Text('Escolher Vídeo da Galeria'),
            onTap: () {
              Navigator.pop(context);
              _pickVideo(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _publishStory() {
    // Em uma implementação real, aqui enviaríamos o story para um servidor
    // Por enquanto, vamos apenas simular o processo
    setState(() {
      _isLoading = true;
    });

    // Simular o upload
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Story publicado com sucesso!')),
      );
      
      // Voltar para a tela anterior
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Criar Story'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_mediaFile != null)
            TextButton(
              onPressed: _isLoading ? null : _publishStory,
              child: _isLoading 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Publicar',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
            ),
        ],
      ),
      body: _mediaFile == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo, size: 100, color: Colors.white54),
                  const SizedBox(height: 20),
                  const Text(
                    'Crie um novo story',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _showMediaSourceOptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Selecionar Mídia'),
                  ),
                ],
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                // Mídia selecionada como fundo
                _isVideo
                    ? const Center(child: Text('Vídeo selecionado', style: TextStyle(color: Colors.white)))
                    : Image.file(
                        _mediaFile!,
                        fit: BoxFit.cover,
                      ),
                
                // Overlay para edição do story
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black54,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Campo de texto para o story
                        TextField(
                          controller: _textController,
                          style: TextStyle(
                            color: _selectedColor,
                            fontSize: _textSize,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Adicione um texto ao seu story...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          maxLines: 3,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Opções de formatação
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Seletor de cores
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _colorOptions.map((color) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedColor = color;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: _selectedColor == color
                                              ? Border.all(color: Colors.white, width: 2)
                                              : null,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            
                            // Controle de tamanho do texto
                            IconButton(
                              icon: const Icon(Icons.text_decrease, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _textSize = (_textSize - 2).clamp(14, 40);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.text_increase, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _textSize = (_textSize + 2).clamp(14, 40);
                                });
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Ferramentas adicionais
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white),
                              onPressed: () {
                                // Implementar seletor de emojis
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.brush_outlined, color: Colors.white),
                              onPressed: () {
                                // Implementar ferramenta de desenho
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                              onPressed: () {
                                // Implementar adição de localização
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.music_note_outlined, color: Colors.white),
                              onPressed: () {
                                // Implementar adição de música
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.sticky_note_2_outlined, color: Colors.white),
                              onPressed: () {
                                // Implementar adição de stickers
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
