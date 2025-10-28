-- Configuração de Storage para o Datagram
-- Criada em: 2024-12-19

-- Criar bucket para mídia do app
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'datagram-media',
    'datagram-media',
    true,
    10485760, -- 10MB
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/quicktime']
) ON CONFLICT (id) DO NOTHING;

-- Políticas de storage para o bucket datagram-media

-- Política para upload de arquivos
CREATE POLICY "Usuários autenticados podem fazer upload de arquivos" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'datagram-media' AND
        auth.role() = 'authenticated'
    );

-- Política para visualização de arquivos públicos
CREATE POLICY "Arquivos são públicos para visualização" ON storage.objects
    FOR SELECT USING (bucket_id = 'datagram-media');

-- Política para atualização de arquivos próprios
CREATE POLICY "Usuários podem atualizar seus próprios arquivos" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'datagram-media' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Política para exclusão de arquivos próprios
CREATE POLICY "Usuários podem deletar seus próprios arquivos" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'datagram-media' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Função para criar estrutura de pastas por usuário
CREATE OR REPLACE FUNCTION create_user_folder()
RETURNS TRIGGER AS $$
BEGIN
    -- Criar pasta do usuário automaticamente quando um arquivo é inserido
    -- A estrutura será: user_id/posts/ ou user_id/stories/ ou user_id/profile/
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para criar estrutura de pastas
CREATE TRIGGER create_user_folder_trigger
    AFTER INSERT ON storage.objects
    FOR EACH ROW
    EXECUTE FUNCTION create_user_folder();

-- Função para validar tipos de arquivo
CREATE OR REPLACE FUNCTION validate_file_type()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar se o tipo de arquivo é permitido
    IF NEW.content_type NOT IN ('image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/quicktime') THEN
        RAISE EXCEPTION 'Tipo de arquivo não permitido: %', NEW.content_type;
    END IF;
    
    -- Verificar se o tamanho do arquivo não excede o limite
    IF NEW.metadata->>'size'::text IS NOT NULL AND 
       (NEW.metadata->>'size')::bigint > 10485760 THEN -- 10MB
        RAISE EXCEPTION 'Arquivo muito grande. Limite: 10MB';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para validar arquivos
CREATE TRIGGER validate_file_type_trigger
    BEFORE INSERT ON storage.objects
    FOR EACH ROW
    EXECUTE FUNCTION validate_file_type();

-- Função para gerar URLs públicas de arquivos
CREATE OR REPLACE FUNCTION get_public_url(bucket_name text, file_path text)
RETURNS text AS $$
BEGIN
    RETURN format('https://%s.supabase.co/storage/v1/object/public/%s/%s', 
                  current_setting('app.settings.supabase_project_ref'), 
                  bucket_name, 
                  file_path);
END;
$$ LANGUAGE plpgsql;

-- Função para upload de avatar de usuário
CREATE OR REPLACE FUNCTION upload_user_avatar(user_id uuid, file_path text)
RETURNS text AS $$
DECLARE
    public_url text;
BEGIN
    -- Gerar URL pública
    public_url := get_public_url('datagram-media', file_path);
    
    -- Atualizar avatar do usuário
    UPDATE users SET avatar_url = public_url WHERE id = user_id;
    
    RETURN public_url;
END;
$$ LANGUAGE plpgsql;

-- Função para upload de imagem de post
CREATE OR REPLACE FUNCTION upload_post_image(post_id uuid, file_path text)
RETURNS text AS $$
DECLARE
    public_url text;
BEGIN
    -- Gerar URL pública
    public_url := get_public_url('datagram-media', file_path);
    
    -- Atualizar imagem do post
    UPDATE posts SET image_url = public_url WHERE id = post_id;
    
    RETURN public_url;
END;
$$ LANGUAGE plpgsql;

-- Função para upload de vídeo de post
CREATE OR REPLACE FUNCTION upload_post_video(post_id uuid, file_path text)
RETURNS text AS $$
DECLARE
    public_url text;
BEGIN
    -- Gerar URL pública
    public_url := get_public_url('datagram-media', file_path);
    
    -- Atualizar vídeo do post
    UPDATE posts SET video_url = public_url WHERE id = post_id;
    
    RETURN public_url;
END;
$$ LANGUAGE plpgsql;

-- Função para upload de story
CREATE OR REPLACE FUNCTION upload_story_media(story_id uuid, file_path text, is_video boolean DEFAULT false)
RETURNS text AS $$
DECLARE
    public_url text;
BEGIN
    -- Gerar URL pública
    public_url := get_public_url('datagram-media', file_path);
    
    -- Atualizar story
    IF is_video THEN
        UPDATE stories SET video_url = public_url WHERE id = story_id;
    ELSE
        UPDATE stories SET image_url = public_url WHERE id = story_id;
    END IF;
    
    RETURN public_url;
END;
$$ LANGUAGE plpgsql;
