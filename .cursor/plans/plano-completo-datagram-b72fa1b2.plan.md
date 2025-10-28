<!-- b72fa1b2-3512-4935-8301-fd134ce12520 76a841d9-6419-47da-9ee5-69718f4e6850 -->
# Plano do Projeto Datagram

## Visão Geral

**Datagram** é um clone do Instagram desenvolvido em Flutter para demonstrar as melhores práticas de desenvolvimento mobile. O aplicativo utiliza dados mock para simular todas as funcionalidades de uma rede social, incluindo posts, stories, comentários, perfis de usuários e sistema de navegação completo.

## Tecnologias Utilizadas

### Framework e Linguagem

- **Flutter** (SDK 3.9.2+)
- **Dart**

### Dependências Principais

- `flutter_riverpod` (^2.5.1) - Gerenciamento de estado reativo
- `go_router` (^14.2.7) - Sistema de navegação e roteamento
- `cached_network_image` (^3.3.1) - Cache de imagens da rede
- `image_picker` (^1.0.7) - Seleção de imagens (câmera/galeria)
- `timeago` (^3.6.0) - Formatação de timestamps relativos
- `intl` (^0.19.0) - Internacionalização e formatação

## Arquitetura do Projeto

### Estrutura de Pastas

```
lib/
├── core/
│   ├── constants/      # Constantes da aplicação
│   ├── router/         # Configuração de rotas (GoRouter)
│   └── theme/          # Temas (light/dark)
├── data/
│   └── mock_data.dart  # Dados mock (usuários, posts, stories, comentários)
├── models/             # Modelos de dados
│   ├── user_model.dart
│   ├── post_model.dart
│   ├── story_model.dart
│   └── comment_model.dart
├── providers/          # Providers Riverpod
│   ├── user_provider.dart
│   ├── post_provider.dart
│   ├── story_provider.dart
│   ├── comment_provider.dart
│   └── providers.dart  # Agregador e providers globais
├── screens/            # Telas da aplicação
│   ├── home/           # Feed principal
│   ├── search/         # Busca de usuários e posts
│   ├── reels/          # Vídeos curtos
│   ├── activity/       # Notificações e atividades
│   ├── profile/        # Perfil do usuário
│   ├── post/           # Detalhes e criação de posts
│   ├── story/          # Visualização e criação de stories
│   ├── messages/       # Mensagens diretas
│   ├── settings/       # Configurações
│   └── saved/          # Posts salvos
├── widgets/            # Widgets reutilizáveis
│   ├── post_card.dart  # Card de post
│   └── story_circle.dart # Círculo de story
├── examples/
│   └── provider_examples.dart # Exemplos de uso dos providers
└── main.dart           # Entry point da aplicação
```

## Funcionalidades Implementadas

### 1. Feed Principal (Home)

- Exibição de posts em ordem cronológica
- Stories no topo da tela
- Scroll infinito
- Like e salvar posts
- Acesso rápido aos comentários

### 2. Sistema de Posts

- Visualização detalhada de posts
- Curtidas e contadores
- Comentários com suporte a likes
- Localização do post
- Caption com suporte a hashtags
- Timestamp relativo (timeago)
- Opção de salvar posts

### 3. Stories

- Visualização de stories com timer automático
- Indicador de progresso
- Stories visualizados vs não visualizados
- Criação de novos stories
- Duração customizável por story

### 4. Perfil de Usuário

- Informações do usuário (bio, contadores)
- Grid de posts do usuário
- Badge de verificação
- Edição de perfil
- Estatísticas (posts, seguidores, seguindo)

### 5. Busca Global

- Busca por usuários (username e nome completo)
- Busca por posts (caption, localização)
- Sistema de relevância
- Resultados ordenados por relevância

### 6. Atividades e Notificações

- Notificações de likes
- Notificações de comentários
- Notificações de novos seguidores
- Notificações de stories
- Contador de notificações não lidas

### 7. Navegação

- Bottom Navigation Bar com 5 tabs principais
- Navegação modal para criação de conteúdo
- Rotas nomeadas com parâmetros
- Deep linking preparado
- Shell routes para navegação aninhada

### 8. Mensagens Diretas

- Tela de mensagens diretas (preparada)
- Integração com navegação

### 9. Configurações

- Tela de configurações
- Opções de tema
- Configurações de notificações
- Opções de privacidade

### 10. Posts Salvos

- Coleção de posts salvos
- Acesso rápido via menu

## Providers e Gerenciamento de Estado

### Providers de Dados Base

- `usersProvider` - Lista de todos os usuários
- `postsProvider` - Lista de todos os posts
- `storiesProvider` - Lista de todos os stories
- `commentsProvider` - Lista de todos os comentários

### Providers Computados

- `currentUserProvider` - Usuário atual logado
- `sortedPostsProvider` - Posts ordenados por data
- `sortedStoriesProvider` - Stories ordenados por visualização
- `unviewedStoriesProvider` - Stories não visualizados
- `commentsByPostProvider(postId)` - Comentários de um post específico
- `globalSearchProvider(query)` - Resultados de busca global

### Providers Globais

- `appStateProvider` - Estado geral da aplicação
- `notificationsProvider` - Lista de notificações
- `unreadNotificationsProvider` - Contador de não lidas
- `appSettingsProvider` - Configurações do app
- `generalStatsProvider` - Estatísticas gerais
- `mainFeedProvider` - Dados do feed principal

## Dados Mock

### Usuários (11 usuários)

- Usuario atual (current_user)
- 10 usuários diversos (fotógrafa, desenvolvedores, fitness, viajante, artista, chef, cantora, tech lead, designer, gamer)
- Cada usuário com perfil completo (bio, contadores, foto)

### Posts (10 posts)

- Posts variados de diferentes usuários
- Com caption, localização, timestamps
- Contadores de likes e comentários
- URLs de imagens via Picsum

### Stories (10 stories)

- Stories de diferentes usuários
- Com estado de visualização
- Duração customizável (3-6 segundos)

### Comentários (10 comentários)

- Distribuídos entre os posts
- Com likes e timestamps
- Relacionados aos posts via postId

## Rotas Configuradas

### Rotas Principais (com Shell/Bottom Nav)

- `/home` - Feed principal
- `/search` - Busca
- `/reels` - Reels
- `/activity` - Atividades/Notificações
- `/profile` - Perfil do usuário

### Rotas Secundárias

- `/post/:postId` - Detalhes do post
- `/create-post` - Criar novo post
- `/story/:storyId` - Visualizar story
- `/create-story` - Criar novo story
- `/edit-profile` - Editar perfil
- `/settings` - Configurações
- `/saved` - Posts salvos
- `/direct-messages` - Mensagens diretas

## Temas

### Light Theme

- Cores claras e modernas
- Baseado no Material Design
- Compatível com design do Instagram

### Dark Theme

- Modo escuro completo
- Cores otimizadas para OLED
- Mudança automática baseada no sistema

## Constantes da Aplicação

### UI

- Paddings: 8, 16, 24 pixels
- Border radius: 8, 12 pixels
- Tamanhos de imagem: perfil (40px), story (60px), post (400px)

### Animações

- Curta: 200ms
- Média: 300ms
- Longa: 500ms

### Limites

- Posts por página: 10
- Comentários por post: 50
- Stories por usuário: 5

## Plano de Migração para Produção com Supabase Backend

### Objetivo

Migrar completamente o projeto de template com dados mock para uma aplicação em produção utilizando **Supabase** como backend (https://hbtsnmunidejqpsdinux.supabase.co), incluindo banco de dados PostgreSQL, autenticação, storage e realtime.

### Fase 1: Configuração do Supabase

#### 1.1. Setup Inicial

- Adicionar dependências do Supabase ao `pubspec.yaml`:
  - `supabase_flutter: ^2.0.0`
  - `flutter_dotenv: ^5.1.0` (para variáveis de ambiente)
- Criar arquivo `.env` com credenciais do Supabase:
  - `SUPABASE_URL=https://hbtsnmunidejqpsdinux.supabase.co`
  - `SUPABASE_ANON_KEY=<sua_anon_key>`
- Inicializar Supabase no `main.dart` antes do `runApp()`
- Adicionar `.env` ao `.gitignore`

#### 1.2. Estrutura do Banco de Dados PostgreSQL

Criar as seguintes tabelas no Supabase:

**Tabela: users**

```sql
- id: uuid (primary key, auto)
- username: text (unique, not null)
- full_name: text (not null)
- profile_image_url: text
- bio: text
- is_verified: boolean (default false)
- created_at: timestamp (default now())
- updated_at: timestamp (default now())
```

**Tabela: posts**

```sql
- id: uuid (primary key, auto)
- user_id: uuid (foreign key -> users.id)
- image_url: text (not null)
- caption: text
- location: text
- likes_count: integer (default 0)
- comments_count: integer (default 0)
- created_at: timestamp (default now())
- updated_at: timestamp (default now())
```

**Tabela: stories**

```sql
- id: uuid (primary key, auto)
- user_id: uuid (foreign key -> users.id)
- media_url: text (not null)
- duration: integer (default 5)
- expires_at: timestamp (default now() + interval '24 hours')
- created_at: timestamp (default now())
```

**Tabela: comments**

```sql
- id: uuid (primary key, auto)
- post_id: uuid (foreign key -> posts.id, cascade delete)
- user_id: uuid (foreign key -> users.id)
- text: text (not null)
- likes_count: integer (default 0)
- created_at: timestamp (default now())
- updated_at: timestamp (default now())
```

**Tabela: likes**

```sql
- id: uuid (primary key, auto)
- user_id: uuid (foreign key -> users.id)
- post_id: uuid (foreign key -> posts.id, nullable)
- comment_id: uuid (foreign key -> comments.id, nullable)
- created_at: timestamp (default now())
- unique(user_id, post_id) ou unique(user_id, comment_id)
```

**Tabela: follows**

```sql
- id: uuid (primary key, auto)
- follower_id: uuid (foreign key -> users.id)
- following_id: uuid (foreign key -> users.id)
- created_at: timestamp (default now())
- unique(follower_id, following_id)
```

**Tabela: saved_posts**

```sql
- id: uuid (primary key, auto)
- user_id: uuid (foreign key -> users.id)
- post_id: uuid (foreign key -> posts.id)
- created_at: timestamp (default now())
- unique(user_id, post_id)
```

**Tabela: story_views**

```sql
- id: uuid (primary key, auto)
- story_id: uuid (foreign key -> stories.id)
- user_id: uuid (foreign key -> users.id)
- viewed_at: timestamp (default now())
- unique(story_id, user_id)
```

**Tabela: notifications**

```sql
- id: uuid (primary key, auto)
- user_id: uuid (foreign key -> users.id)
- type: text (like, comment, follow, story)
- message: text (not null)
- related_user_id: uuid (foreign key -> users.id, nullable)
- related_post_id: uuid (foreign key -> posts.id, nullable)
- is_read: boolean (default false)
- created_at: timestamp (default now())
```

#### 1.3. Row Level Security (RLS)

Configurar políticas de segurança para cada tabela:

- Users: Todos podem ler, apenas o próprio usuário pode atualizar
- Posts: Todos podem ler, apenas o autor pode atualizar/deletar
- Stories: Todos podem ler stories não expirados
- Comments: Todos podem ler, apenas o autor pode deletar
- Likes/Follows/Saved: Apenas o próprio usuário pode inserir/deletar

#### 1.4. Storage Buckets

Criar buckets no Supabase Storage:

- `profiles` - Fotos de perfil (público)
- `posts` - Imagens de posts (público)
- `stories` - Mídia de stories (público, com expiração)

### Fase 2: Camada de Serviços

#### 2.1. Criar Serviços de API

Criar pasta `lib/services/` com os seguintes arquivos:

**auth_service.dart**

- `signUp(email, password, username, fullName)`
- `signIn(email, password)`
- `signOut()`
- `getCurrentUser()`
- `updateProfile(userData)`
- `uploadProfileImage(File image)`

**user_service.dart**

- `getUser(userId)`
- `getUserByUsername(username)`
- `searchUsers(query)`
- `followUser(userId)`
- `unfollowUser(userId)`
- `getFollowers(userId)`
- `getFollowing(userId)`
- `updateUserStats(userId)` - Atualizar contadores

**post_service.dart**

- `createPost(imageFile, caption, location)`
- `getPosts(limit, offset)` - Paginação
- `getPostById(postId)`
- `getPostsByUser(userId)`
- `deletePost(postId)`
- `likePost(postId)`
- `unlikePost(postId)`
- `savePost(postId)`
- `unsavePost(postId)`
- `getSavedPosts()`

**story_service.dart**

- `createStory(mediaFile)`
- `getStories()` - Apenas stories não expirados
- `getStoriesByUser(userId)`
- `viewStory(storyId)` - Marcar como visualizado
- `deleteExpiredStories()` - Cleanup automático

**comment_service.dart**

- `createComment(postId, text)`
- `getCommentsByPost(postId)`
- `deleteComment(commentId)`
- `likeComment(commentId)`
- `unlikeComment(commentId)`

**notification_service.dart**

- `getNotifications()`
- `markAsRead(notificationId)`
- `markAllAsRead()`
- `createNotification(userId, type, message, ...)`

**storage_service.dart**

- `uploadImage(File image, String bucket, String path)`
- `deleteImage(String bucket, String path)`
- `getPublicUrl(String bucket, String path)`

#### 2.2. Implementar Realtime

- Subscrever mudanças em tempo real usando Supabase Realtime:
  - Novos posts no feed
  - Novos comentários
  - Novas notificações
  - Novos likes
  - Novos seguidores

### Fase 3: Migração dos Providers

#### 3.1. Refatorar Providers Existentes

Transformar todos os providers de dados mock para StateNotifierProvider que se comunicam com os serviços:

**auth_provider.dart** (novo)

- `AuthState` com status de autenticação
- `currentAuthUserProvider` - Usuário autenticado do Supabase
- `authStateProvider` - Stream do estado de autenticação

**user_provider.dart** (refatorar)

- Remover dados mock
- Implementar `AsyncValue<User>` para loading states
- Integrar com `user_service.dart`
- Cache local com invalidação

**post_provider.dart** (refatorar)

- Implementar paginação real
- Loading states (loading, error, data)
- Refresh e pull-to-refresh
- Cache de imagens com `cached_network_image`

**story_provider.dart** (refatorar)

- Filtrar stories expirados automaticamente
- Realtime para novos stories
- Auto-cleanup de stories antigos

**comment_provider.dart** (refatorar)

- Realtime para novos comentários
- Otimistic updates

#### 3.2. Novos Providers

- `connectionProvider` - Monitorar conexão com internet
- `uploadProvider` - Gerenciar uploads em progresso
- `cacheProvider` - Gerenciar cache local

### Fase 4: Atualização das Telas

#### 4.1. Adicionar Telas de Autenticação

Criar pasta `lib/screens/auth/`:

- `login_screen.dart` - Login com email/senha
- `register_screen.dart` - Cadastro com validação
- `forgot_password_screen.dart` - Recuperação de senha
- `onboarding_screen.dart` - Primeira vez no app

#### 4.2. Atualizar Telas Existentes

Todas as telas devem:

- Implementar loading states
- Tratamento de erros com mensagens amigáveis
- Pull-to-refresh onde aplicável
- Indicadores de upload em progresso
- Estados vazios (empty states)
- Retry em caso de falha

#### 4.3. Upload de Imagens

- Integrar `image_picker` nas telas de criação
- Adicionar preview antes de enviar
- Progress indicator durante upload
- Compressão de imagens antes do upload
- Validação de tamanho e formato

### Fase 5: Recursos de Produção

#### 5.1. Tratamento de Erros

- Criar `lib/core/errors/`:
  - `app_exception.dart` - Exceções customizadas
  - `error_handler.dart` - Handler global de erros
- Implementar retry logic para falhas de rede
- Logs de erro (integrar Sentry ou similar)

#### 5.2. Loading States

- Skeleton loaders para melhor UX
- Shimmer effect durante carregamento
- Progress indicators contextuais

#### 5.3. Validações

- Validação de formulários
- Validação de imagens (tamanho, formato)
- Validação de username (único, formato)
- Limite de caracteres em captions e comentários

#### 5.4. Cache e Performance

- Implementar cache local com `hive` ou `isar`
- Lazy loading de imagens
- Paginação em todas as listas
- Otimização de queries
- Índices no banco de dados

#### 5.5. Segurança

- Validação de tokens
- Sanitização de inputs
- Rate limiting (via Supabase Edge Functions)
- Moderação de conteúdo

### Fase 6: Funcionalidades Adicionais

#### 6.1. Sistema de Notificações Push

- Integrar Firebase Cloud Messaging
- Notificações para likes, comentários, seguidores
- Deep linking nas notificações

#### 6.2. Mensagens Diretas (DM)

- Criar tabelas de conversas e mensagens
- Implementar chat em tempo real
- Indicador de "digitando..."
- Status de leitura

#### 6.3. Busca Avançada

- Full-text search no PostgreSQL
- Busca por hashtags
- Busca por localização
- Histórico de buscas

#### 6.4. Analytics

- Integrar Firebase Analytics ou Mixpanel
- Tracking de eventos importantes
- Métricas de engajamento

### Fase 7: Testes e Deploy

#### 7.1. Testes

- Unit tests para services
- Widget tests para componentes
- Integration tests para fluxos principais
- Testes de performance

#### 7.2. CI/CD

- GitHub Actions ou similar
- Build automático
- Deploy automático para TestFlight/Play Store Beta

#### 7.3. Monitoramento

- Crash reporting (Firebase Crashlytics)
- Performance monitoring
- Analytics de uso

### Fase 8: Migração dos Dados Mock

#### 8.1. Script de Migração

- Criar script para popular banco com dados mock iniciais
- Útil para desenvolvimento e testes

#### 8.2. Remover Código Mock

- Deletar `lib/data/mock_data.dart`
- Remover referências a dados mock
- Atualizar imports em todos os arquivos
- Limpar código não utilizado

### Checklist de Migração

#### Preparação

- [ ] Configurar projeto no Supabase
- [ ] Obter credenciais (URL e anon key)
- [ ] Configurar variáveis de ambiente
- [ ] Adicionar dependências

#### Banco de Dados

- [ ] Criar todas as tabelas
- [ ] Configurar relacionamentos e foreign keys
- [ ] Implementar RLS policies
- [ ] Criar índices para performance
- [ ] Popular com dados de teste

#### Storage

- [ ] Criar buckets
- [ ] Configurar políticas de acesso
- [ ] Testar upload/download

#### Backend

- [ ] Implementar todos os services
- [ ] Configurar autenticação
- [ ] Implementar realtime subscriptions
- [ ] Testar todas as operações CRUD

#### Frontend

- [ ] Refatorar todos os providers
- [ ] Atualizar todas as telas
- [ ] Implementar telas de autenticação
- [ ] Adicionar loading states
- [ ] Implementar tratamento de erros
- [ ] Adicionar validações

#### Features

- [ ] Upload de imagens funcionando
- [ ] Sistema de likes completo
- [ ] Sistema de comentários
- [ ] Sistema de follows
- [ ] Posts salvos
- [ ] Stories com expiração
- [ ] Notificações
- [ ] Busca funcionando

#### Produção

- [ ] Testes completos
- [ ] Otimizações de performance
- [ ] Configurar monitoramento
- [ ] Deploy em ambiente de staging
- [ ] Testes de aceitação
- [ ] Deploy em produção

#### Cleanup

- [ ] Remover todo código mock
- [ ] Atualizar documentação
- [ ] Limpar dependências não utilizadas
- [ ] Code review final

### Dependências Adicionais Necessárias

```yaml
dependencies:
  supabase_flutter: ^2.0.0
  flutter_dotenv: ^5.1.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  image_picker: ^1.0.7  # já existe
  image_cropper: ^5.0.1
  flutter_image_compress: ^2.1.0
  connectivity_plus: ^5.0.2
  firebase_messaging: ^14.7.9
  firebase_analytics: ^10.8.0
  firebase_crashlytics: ^3.4.8
  sentry_flutter: ^7.14.0
  pull_to_refresh: ^2.0.0

dev_dependencies:
  mockito: ^5.4.4
  build_runner: ^2.4.7
```

### Estimativa de Tempo

- **Fase 1-2** (Setup + Services): 2-3 dias
- **Fase 3** (Providers): 2-3 dias
- **Fase 4** (Telas): 3-4 dias
- **Fase 5** (Recursos): 2-3 dias
- **Fase 6** (Features adicionais): 3-5 dias
- **Fase 7** (Testes/Deploy): 2-3 dias
- **Fase 8** (Cleanup): 1 dia

**Total estimado**: 15-22 dias de desenvolvimento

## Próximos Passos / Funcionalidades Futuras (Pós-Migração)

### Em Desenvolvimento

- **Reels** - Vídeos curtos com player customizado
- **Live Streaming** - Transmissões ao vivo via RTMP
- **Direct Messages** - Chat em tempo real completo

### Planejadas

- **Filtros de Imagem** - Edição e filtros estilo Instagram
- **Multi-idiomas** - Suporte completo a i18n
- **Modo Offline** - Funcionalidade básica sem internet
- **Compartilhamento Externo** - Share para outras redes
- **QR Code de Perfil** - Facilitar seguir usuários
- **Temas Customizados** - Mais opções de personalização

## Como Executar

### Pré-requisitos

- Flutter SDK 3.9.2 ou superior
- Dart SDK incluído no Flutter
- Android Studio / Xcode (para emuladores)
- VS Code ou Android Studio (IDEs)

### Instalação

```bash
# Navegar para o diretório do projeto
cd datagram

# Instalar dependências
flutter pub get

# Executar em modo debug
flutter run

# Ou usar o script PowerShell (Windows)
..\run_app.ps1
```

### Build para Produção

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Estrutura de Dados

### User Model

- id, username, fullName
- profileImageUrl, bio
- postsCount, followersCount, followingCount
- isVerified

### Post Model

- id, userId, user
- imageUrl, caption, location
- timestamp, likesCount, commentsCount
- isLiked, isSaved

### Story Model

- id, userId, user
- mediaUrl, timestamp
- isViewed, duration

### Comment Model

- id, postId, userId, user
- text, timestamp
- likesCount, isLiked

## Observações Importantes

1. **Dados Mock**: Todos os dados são simulados e resetam ao reiniciar o app
2. **Imagens**: URLs do Picsum Photos (requerem conexão com internet)
3. **Estado**: Gerenciado por Riverpod, não persiste entre sessões
4. **Navegação**: GoRouter configurado para deep linking futuro
5. **Tema**: Suporta light/dark mode baseado no sistema operacional

## Versão

**Versão Atual**: 1.0.0+1

## Autor e Licença

Projeto desenvolvido como demonstração de boas práticas em Flutter.

Clone educacional do Instagram para fins de aprendizado.