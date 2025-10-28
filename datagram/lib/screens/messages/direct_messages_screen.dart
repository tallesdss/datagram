import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../providers/providers.dart';
import '../../models/user_model.dart';

// Modelo para mensagens
class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final User sender;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isRead,
    required this.sender,
  });
}

// Modelo para conversas
class Conversation {
  final String id;
  final List<String> participantIds;
  final Message lastMessage;
  final List<User> participants;
  final bool isGroup;
  final String? groupName;
  final String? groupImageUrl;

  const Conversation({
    required this.id,
    required this.participantIds,
    required this.lastMessage,
    required this.participants,
    this.isGroup = false,
    this.groupName,
    this.groupImageUrl,
  });

  // Método para obter o nome da conversa
  String getConversationName(String currentUserId) {
    if (isGroup) {
      return groupName ?? 'Grupo';
    } else {
      // Para conversas privadas, mostrar o nome do outro usuário
      final otherUser = participants.firstWhere((user) => user.id != currentUserId);
      return otherUser.username;
    }
  }

  // Método para obter a imagem da conversa
  String getConversationImage(String currentUserId) {
    if (isGroup) {
      return groupImageUrl ?? 'https://picsum.photos/200/200?random=401';
    } else {
      // Para conversas privadas, mostrar a imagem do outro usuário
      final otherUser = participants.firstWhere((user) => user.id != currentUserId);
      return otherUser.profileImageUrl;
    }
  }
}

// Provider para conversas (simulado)
final conversationsProvider = Provider<List<Conversation>>((ref) {
  final users = ref.watch(usersProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  // Criar algumas mensagens simuladas
  final messages = [
    Message(
      id: 'msg_1',
      senderId: users[1].id,
      receiverId: currentUser.id,
      text: 'Oi, tudo bem?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: true,
      sender: users[1],
    ),
    Message(
      id: 'msg_2',
      senderId: users[2].id,
      receiverId: currentUser.id,
      text: 'Viu o novo projeto?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      sender: users[2],
    ),
    Message(
      id: 'msg_3',
      senderId: users[3].id,
      receiverId: currentUser.id,
      text: 'Treino amanhã?',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      sender: users[3],
    ),
    Message(
      id: 'msg_4',
      senderId: currentUser.id,
      receiverId: users[4].id,
      text: 'Adorei as fotos da viagem!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      sender: currentUser,
    ),
    Message(
      id: 'msg_5',
      senderId: users[5].id,
      receiverId: currentUser.id,
      text: 'Viu minha nova arte?',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      sender: users[5],
    ),
  ];
  
  // Criar conversas a partir das mensagens
  return [
    Conversation(
      id: 'conv_1',
      participantIds: [currentUser.id, users[1].id],
      lastMessage: messages[0],
      participants: [currentUser, users[1]],
    ),
    Conversation(
      id: 'conv_2',
      participantIds: [currentUser.id, users[2].id],
      lastMessage: messages[1],
      participants: [currentUser, users[2]],
    ),
    Conversation(
      id: 'conv_3',
      participantIds: [currentUser.id, users[3].id],
      lastMessage: messages[2],
      participants: [currentUser, users[3]],
    ),
    Conversation(
      id: 'conv_4',
      participantIds: [currentUser.id, users[4].id],
      lastMessage: messages[3],
      participants: [currentUser, users[4]],
    ),
    Conversation(
      id: 'conv_5',
      participantIds: [currentUser.id, users[5].id],
      lastMessage: messages[4],
      participants: [currentUser, users[5]],
    ),
    Conversation(
      id: 'conv_6',
      participantIds: [currentUser.id, users[1].id, users[2].id, users[3].id],
      lastMessage: Message(
        id: 'msg_6',
        senderId: users[1].id,
        receiverId: 'group',
        text: 'Pessoal, vamos marcar algo?',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        isRead: true,
        sender: users[1],
      ),
      participants: [currentUser, users[1], users[2], users[3]],
      isGroup: true,
      groupName: 'Amigos',
      groupImageUrl: 'https://picsum.photos/200/200?random=401',
    ),
  ];
});

// Provider para mensagens de uma conversa específica (simulado)
final conversationMessagesProvider = Provider.family<List<Message>, String>((ref, conversationId) {
  final users = ref.watch(usersProvider);
  final currentUser = ref.watch(currentUserProvider);
  
  // Simular mensagens para a conversa
  switch (conversationId) {
    case 'conv_1':
      return [
        Message(
          id: 'msg_1_1',
          senderId: users[1].id,
          receiverId: currentUser.id,
          text: 'Oi, tudo bem?',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          isRead: true,
          sender: users[1],
        ),
        Message(
          id: 'msg_1_2',
          senderId: currentUser.id,
          receiverId: users[1].id,
          text: 'Tudo ótimo! E você?',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          isRead: true,
          sender: currentUser,
        ),
        Message(
          id: 'msg_1_3',
          senderId: users[1].id,
          receiverId: currentUser.id,
          text: 'Também estou bem! Viu minhas novas fotos?',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
          sender: users[1],
        ),
        Message(
          id: 'msg_1_4',
          senderId: currentUser.id,
          receiverId: users[1].id,
          text: 'Vi sim, ficaram incríveis!',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isRead: true,
          sender: currentUser,
        ),
        Message(
          id: 'msg_1_5',
          senderId: users[1].id,
          receiverId: currentUser.id,
          text: 'Obrigada! Vamos marcar algo em breve?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: true,
          sender: users[1],
        ),
      ];
    default:
      return [];
  }
});

class DirectMessagesScreen extends ConsumerStatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  ConsumerState<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends ConsumerState<DirectMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(conversationsProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    // Filtrar conversas se estiver pesquisando
    final filteredConversations = _isSearching && _searchController.text.isNotEmpty
        ? conversations.where((conv) {
            final name = conv.getConversationName(currentUser.id).toLowerCase();
            return name.contains(_searchController.text.toLowerCase());
          }).toList()
        : conversations;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
                autofocus: true,
              )
            : const Text('Mensagens'),
        leading: IconButton(
          icon: Icon(_isSearching ? Icons.arrow_back : Icons.arrow_back),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showNewMessageDialog(context);
            },
          ),
        ],
      ),
      body: filteredConversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isSearching
                        ? 'Nenhuma conversa encontrada'
                        : 'Nenhuma conversa ainda',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (!_isSearching)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Inicie uma conversa com seus amigos',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: filteredConversations.length,
              itemBuilder: (context, index) {
                final conversation = filteredConversations[index];
                final isCurrentUserSender = conversation.lastMessage.senderId == currentUser.id;
                final hasUnreadMessages = !conversation.lastMessage.isRead && !isCurrentUserSender;
                
                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: CachedNetworkImageProvider(
                      conversation.getConversationImage(currentUser.id),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.getConversationName(currentUser.id),
                          style: TextStyle(
                            fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTimestamp(conversation.lastMessage.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: hasUnreadMessages ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      if (isCurrentUserSender)
                        const Text(
                          'Você: ',
                          style: TextStyle(fontSize: 14),
                        ),
                      Expanded(
                        child: Text(
                          conversation.lastMessage.text,
                          style: TextStyle(
                            fontWeight: hasUnreadMessages ? FontWeight.bold : FontWeight.normal,
                            color: hasUnreadMessages ? Colors.black : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnreadMessages)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    _openConversation(context, conversation);
                  },
                );
              },
            ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _showNewMessageDialog(BuildContext context) {
    final users = ref.read(usersProvider);
    final currentUser = ref.read(currentUserProvider);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Nova mensagem',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Para balancear o layout
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (user.id == currentUser.id) return const SizedBox.shrink();
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                    title: Text(user.username),
                    subtitle: Text(user.fullName),
                    onTap: () {
                      Navigator.pop(context);
                      // Simular criação de nova conversa
                      _openNewConversation(context, user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openConversation(BuildContext context, Conversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChatScreen(conversationId: conversation.id),
      ),
    );
  }

  void _openNewConversation(BuildContext context, User user) {
    // Em uma implementação real, aqui criaríamos uma nova conversa
    // Por enquanto, vamos apenas mostrar uma mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Iniciando conversa com ${user.username}')),
    );
    
    // Simular abertura de conversa existente
    final conversations = ref.read(conversationsProvider);
    final conversation = conversations.first;
    _openConversation(context, conversation);
  }
}

class _ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  
  const _ChatScreen({required this.conversationId});

  @override
  ConsumerState<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<_ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAttaching = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    // Em uma implementação real, aqui enviaríamos a mensagem
    // Por enquanto, vamos apenas limpar o campo
    setState(() {
      _messageController.clear();
      _isAttaching = false;
    });
    
    // Simular resposta após 1 segundo
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      // Rolar para o final da lista
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(conversationMessagesProvider(widget.conversationId));
    final currentUser = ref.watch(currentUserProvider);
    final conversations = ref.watch(conversationsProvider);
    final conversation = conversations.firstWhere((c) => c.id == widget.conversationId);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: CachedNetworkImageProvider(
                conversation.getConversationImage(currentUser.id),
              ),
            ),
            const SizedBox(width: 8),
            Text(conversation.getConversationName(currentUser.id)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chamada de vídeo iniciada')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Detalhes da conversa')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text('Nenhuma mensagem ainda. Diga olá!'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index]; // Inverter ordem
                      final isCurrentUser = message.senderId == currentUser.id;
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isCurrentUser)
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: CachedNetworkImageProvider(message.sender.profileImageUrl),
                              ),
                            const SizedBox(width: 8),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: isCurrentUser ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    timeago.format(message.timestamp, locale: 'pt'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isCurrentUser ? Colors.white70 : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          
          // Campo de entrada de mensagem
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                if (_isAttaching)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAttachmentButton(Icons.photo, 'Galeria', Colors.purple),
                        _buildAttachmentButton(Icons.camera_alt, 'Câmera', Colors.red),
                        _buildAttachmentButton(Icons.mic, 'Áudio', Colors.orange),
                        _buildAttachmentButton(Icons.location_on, 'Local', Colors.green),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isAttaching ? Icons.close : Icons.add,
                        color: _isAttaching ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _isAttaching = !_isAttaching;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Mensagem...',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Abrindo câmera')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gravando áudio')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: _messageController.text.trim().isEmpty ? null : Colors.blue,
                      onPressed: _messageController.text.trim().isEmpty ? null : _sendMessage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label selecionado')),
              );
              setState(() {
                _isAttaching = false;
              });
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
