-- Políticas RLS (Row Level Security) para o Datagram
-- Criada em: 2024-12-19

-- Habilitar RLS em todas as tabelas
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE comment_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE story_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Políticas para a tabela users
CREATE POLICY "Usuários podem ver perfis públicos" ON users
    FOR SELECT USING (NOT is_private OR auth.uid() = id);

CREATE POLICY "Usuários podem atualizar seu próprio perfil" ON users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Usuários podem inserir seu próprio perfil" ON users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Políticas para a tabela posts
CREATE POLICY "Usuários podem ver posts de perfis públicos" ON posts
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = posts.user_id 
            AND (NOT users.is_private OR users.id = auth.uid())
        )
    );

CREATE POLICY "Usuários podem criar posts" ON posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem atualizar seus próprios posts" ON posts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem deletar seus próprios posts" ON posts
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para a tabela stories
CREATE POLICY "Usuários podem ver stories de perfis públicos" ON stories
    FOR SELECT USING (
        expires_at > NOW() AND
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = stories.user_id 
            AND (NOT users.is_private OR users.id = auth.uid())
        )
    );

CREATE POLICY "Usuários podem criar stories" ON stories
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem deletar suas próprias stories" ON stories
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para a tabela comments
CREATE POLICY "Usuários podem ver comentários de posts públicos" ON comments
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM posts 
            JOIN users ON users.id = posts.user_id
            WHERE posts.id = comments.post_id 
            AND (NOT users.is_private OR users.id = auth.uid())
        )
    );

CREATE POLICY "Usuários podem criar comentários" ON comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem atualizar seus próprios comentários" ON comments
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem deletar seus próprios comentários" ON comments
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para a tabela post_likes
CREATE POLICY "Usuários podem ver curtidas de posts públicos" ON post_likes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM posts 
            JOIN users ON users.id = posts.user_id
            WHERE posts.id = post_likes.post_id 
            AND (NOT users.is_private OR users.id = auth.uid())
        )
    );

CREATE POLICY "Usuários podem curtir posts" ON post_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem descurtir posts" ON post_likes
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para a tabela comment_likes
CREATE POLICY "Usuários podem ver curtidas de comentários" ON comment_likes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM comments 
            JOIN posts ON posts.id = comments.post_id
            JOIN users ON users.id = posts.user_id
            WHERE comments.id = comment_likes.comment_id 
            AND (NOT users.is_private OR users.id = auth.uid())
        )
    );

CREATE POLICY "Usuários podem curtir comentários" ON comment_likes
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem descurtir comentários" ON comment_likes
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para a tabela followers
CREATE POLICY "Usuários podem ver seguidores/seguindo de perfis públicos" ON followers
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE users.id = followers.following_id 
            AND (NOT users.is_private OR users.id = auth.uid())
        )
    );

CREATE POLICY "Usuários podem seguir outros usuários" ON followers
    FOR INSERT WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Usuários podem deixar de seguir outros usuários" ON followers
    FOR DELETE USING (auth.uid() = follower_id);

-- Políticas para a tabela saved_posts
CREATE POLICY "Usuários podem ver seus próprios posts salvos" ON saved_posts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem salvar posts" ON saved_posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem remover posts salvos" ON saved_posts
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para a tabela story_views
CREATE POLICY "Usuários podem ver visualizações de suas próprias stories" ON story_views
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM stories 
            WHERE stories.id = story_views.story_id 
            AND stories.user_id = auth.uid()
        )
    );

CREATE POLICY "Usuários podem visualizar stories" ON story_views
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Políticas para a tabela notifications
CREATE POLICY "Usuários podem ver suas próprias notificações" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Sistema pode criar notificações" ON notifications
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Usuários podem marcar notificações como lidas" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Políticas para a tabela conversations
CREATE POLICY "Usuários podem ver conversas que participam" ON conversations
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM conversation_participants 
            WHERE conversation_participants.conversation_id = conversations.id 
            AND conversation_participants.user_id = auth.uid()
        )
    );

CREATE POLICY "Usuários podem criar conversas" ON conversations
    FOR INSERT WITH CHECK (true);

-- Políticas para a tabela conversation_participants
CREATE POLICY "Usuários podem ver participantes de suas conversas" ON conversation_participants
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM conversation_participants cp2
            WHERE cp2.conversation_id = conversation_participants.conversation_id 
            AND cp2.user_id = auth.uid()
        )
    );

CREATE POLICY "Usuários podem adicionar participantes às conversas" ON conversation_participants
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM conversation_participants 
            WHERE conversation_participants.conversation_id = conversation_participants.conversation_id 
            AND conversation_participants.user_id = auth.uid()
        )
    );

-- Políticas para a tabela messages
CREATE POLICY "Usuários podem ver mensagens de suas conversas" ON messages
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM conversation_participants 
            WHERE conversation_participants.conversation_id = messages.conversation_id 
            AND conversation_participants.user_id = auth.uid()
        )
    );

CREATE POLICY "Usuários podem enviar mensagens" ON messages
    FOR INSERT WITH CHECK (
        auth.uid() = sender_id AND
        EXISTS (
            SELECT 1 FROM conversation_participants 
            WHERE conversation_participants.conversation_id = messages.conversation_id 
            AND conversation_participants.user_id = auth.uid()
        )
    );

CREATE POLICY "Usuários podem marcar mensagens como lidas" ON messages
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM conversation_participants 
            WHERE conversation_participants.conversation_id = messages.conversation_id 
            AND conversation_participants.user_id = auth.uid()
        )
    );
