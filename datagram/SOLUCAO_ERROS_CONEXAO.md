# 🔧 Solução de Erros de Conexão - Flutter Pub

## Problema: Erro de DNS ao baixar pacotes do pub.dev

### Sintomas
```
ClientException with SocketException: Failed host lookup: 'pub.dev'
Failed to update packages.
```

## ✅ Soluções Rápidas

### 1. **Usar Modo Offline (Quando os pacotes já estão em cache)**
```powershell
cd datagram
flutter pub get --offline
```

### 2. **Limpar Cache do Flutter e Tentar Novamente**
```powershell
cd datagram
flutter clean
flutter pub cache repair
flutter pub get
```

### 3. **Alterar DNS do Sistema (Windows)**

#### Via Interface Gráfica:
1. Abra **Configurações do Windows** → **Rede e Internet** → **Adaptador de Rede**
2. Clique com botão direito no adaptador ativo → **Propriedades**
3. Selecione **Protocolo TCP/IP versão 4** → **Propriedades**
4. Marque **"Usar os seguintes endereços de servidor DNS"**
5. Defina:
   - **Servidor DNS preferencial:** `8.8.8.8` (Google DNS)
   - **Servidor DNS alternativo:** `8.8.4.4` (Google DNS) ou `1.1.1.1` (Cloudflare)
6. Clique **OK** e reinicie a conexão

#### Via PowerShell (Administrador):
```powershell
# Alterar DNS para Google DNS
netsh interface ip set dns "Wi-Fi" static 8.8.8.8
netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2

# Para conexão cabeada, use "Ethernet" em vez de "Wi-Fi"
# Para verificar o nome da interface:
Get-NetAdapter
```

### 4. **Verificar e Configurar Proxy (Se necessário)**

Se você usa proxy corporativo:
```powershell
# Configurar proxy para Flutter
$env:HTTP_PROXY="http://seu-proxy:porta"
$env:HTTPS_PROXY="http://seu-proxy:porta"
flutter pub get
```

### 5. **Verificar Conectividade**
```powershell
# Testar ping para pub.dev
ping pub.dev

# Testar resolução DNS
nslookup pub.dev

# Testar acesso HTTP
curl https://pub.dev
```

### 6. **Usar Mirror Alternativo (Se disponível)**

Alguns países têm mirrors regionais. Verifique na documentação do Flutter.

### 7. **Desabilitar Antivírus/Firewall Temporariamente**

Às vezes, antivírus ou firewalls podem bloquear conexões. Teste desabilitar temporariamente.

## 📝 Comandos Úteis

```powershell
# Verificar versão do Flutter
flutter --version

# Verificar status do Flutter
flutter doctor -v

# Limpar tudo e reinstalar dependências
flutter clean
flutter pub cache clean
flutter pub get

# Ver informações de rede do Flutter
flutter doctor -v | Select-String "Network"
```

## 🔍 Diagnóstico

Se o problema persistir:

1. **Verificar se é problema de rede geral:**
   ```powershell
   ping google.com
   ping github.com
   ```

2. **Verificar configuração do Flutter:**
   ```powershell
   flutter config
   ```

3. **Verificar logs detalhados:**
   ```powershell
   flutter pub get --verbose
   ```

## 💡 Dica

Se você já tem os pacotes instalados e só precisa executar o app:
- Use `flutter pub get --offline` para evitar downloads desnecessários
- O modo offline funciona perfeitamente se os pacotes já estão no cache local

## 📚 Referências

- [Flutter Pub Troubleshooting](https://dart.dev/tools/pub/troubleshoot)
- [Flutter Network Issues](https://docs.flutter.dev/troubleshooting)

