// Arquivo de exemplo para criar o arquivo .env na raiz do projeto
class EnvExample {
  // Instruções:
  // 1. Crie um arquivo chamado .env na raiz do projeto
  // 2. Copie o conteúdo abaixo para o arquivo .env
  // 3. Substitua os valores pelos fornecidos pelo Supabase
  // 
  // Conteúdo para o arquivo .env:
  // ```
  // SUPABASE_URL=https://hbtsnmunidejqpsdinux.supabase.co
  // SUPABASE_ANON_KEY=sua_anon_key_aqui
  // ```
  //
  // Nota: O arquivo .env está no .gitignore e não será versionado
  
  static const String supabaseUrl = 'https://hbtsnmunidejqpsdinux.supabase.co';
  static const String exampleNote = 'Substitua sua_anon_key_aqui pela chave anônima fornecida pelo Supabase';
}
