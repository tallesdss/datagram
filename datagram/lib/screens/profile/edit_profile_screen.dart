import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../providers/providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controladores com dados do usuário atual
    final user = ref.read(currentUserProvider);
    _nameController.text = user?.fullName ?? '';
    _usernameController.text = user?.username ?? '';
    _bioController.text = user?.bio ?? '';
    _emailController.text = 'usuario@exemplo.com'; // Simulado
    _phoneController.text = '(11) 98765-4321'; // Simulado
    _websiteController.text = 'www.exemplo.com.br'; // Simulado
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e nome de usuário são obrigatórios')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simular salvamento
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      // Voltar para a tela anterior
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveProfile,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto de perfil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? kIsWeb 
                          ? MemoryImage(Uint8List.fromList(_imageFile!.readAsBytesSync())) as ImageProvider
                          : FileImage(_imageFile!) as ImageProvider
                        : CachedNetworkImageProvider(user?.profileImageUrl ?? ''),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Link para alterar foto
            TextButton(
              onPressed: _pickImage,
              child: const Text('Alterar foto do perfil'),
            ),
            
            const SizedBox(height: 24),
            
            // Campos de edição
            _buildTextField(
              controller: _nameController,
              label: 'Nome',
              hint: 'Seu nome completo',
            ),
            
            _buildTextField(
              controller: _usernameController,
              label: 'Nome de usuário',
              hint: 'Seu nome de usuário',
            ),
            
            _buildTextField(
              controller: _bioController,
              label: 'Biografia',
              hint: 'Conte algo sobre você',
              maxLines: 3,
            ),
            
            const Divider(height: 32),
            
            // Seção de informações privadas
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'INFORMAÇÕES PRIVADAS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _emailController,
              label: 'E-mail',
              hint: 'Seu endereço de e-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            
            _buildTextField(
              controller: _phoneController,
              label: 'Telefone',
              hint: 'Seu número de telefone',
              keyboardType: TextInputType.phone,
            ),
            
            _buildTextField(
              controller: _websiteController,
              label: 'Site',
              hint: 'Seu site ou link',
              keyboardType: TextInputType.url,
            ),
            
            const SizedBox(height: 24),
            
            // Botão para configurações avançadas
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações avançadas')),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Configurações avançadas de perfil'),
            ),
            
            const SizedBox(height: 16),
            
            // Botão para configurações de privacidade
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações de privacidade')),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Configurações de privacidade'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
