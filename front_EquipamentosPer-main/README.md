# P&R Equipamentos - Sistema de Gerenciamento

Aplicativo mobile Flutter para cadastro e gerenciamento de equipamentos de informática da empresa P&R.

## 📱 Funcionalidades

- ✅ **Cadastro de Clientes**: Gerenciar informações de clientes
- ✅ **Cadastro de Usuários**: Gerenciar usuários do sistema
- ✅ **Cadastro de Computadores**: Registro completo com código automático (P0001, P0002...)
- ✅ **Cadastro de Nobreaks**: Registro completo com código automático (N0001, N0002...)
- ✅ **Captura de Fotos**: Integração com câmera do dispositivo
- ✅ **Listagem e Filtros**: Visualização e busca de equipamentos
- ✅ **Edição e Exclusão**: Gerenciamento completo dos registros
- ✅ **Sincronização em Nuvem**: Dados compartilhados entre dispositivos via Firebase

## 🎨 Identidade Visual

O aplicativo segue a identidade visual da empresa P&R com:
- Paleta de cores verde (baseada no logo da empresa)
- Interface moderna e intuitiva
- Componentes personalizados
- Logo da empresa integrado

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.24.3**: Framework de desenvolvimento mobile
- **Firebase**: Backend como serviço
  - Firestore: Banco de dados NoSQL
  - Storage: Armazenamento de imagens
- **Dart**: Linguagem de programação
- **Material Design 3**: Sistema de design

## 📋 Pré-requisitos

- Flutter SDK 3.24.3 ou superior
- Android Studio ou VS Code
- Conta no Firebase (para configuração do backend)
- Dispositivo Android ou emulador

## 🚀 Instalação e Configuração

### 1. Clone o Projeto
```bash
git clone <url-do-repositorio>
cd pr_equipamentos
```

### 2. Instale as Dependências
```bash
flutter pub get
```

### 3. Configure o Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Crie um novo projeto chamado `pr-equipamentos`
3. Siga as instruções em `FIREBASE_SETUP.md`
4. Substitua o arquivo `android/app/google-services.json.example` pelo arquivo real
5. Atualize as chaves em `lib/firebase_options.dart`

### 4. Execute o Aplicativo
```bash
flutter run
```

## 📱 Como Usar

### Tela Inicial
- Visualize estatísticas rápidas
- Acesse as principais funcionalidades
- Navegue pelo menu principal

### Cadastrar Equipamentos
1. Toque em "Cadastrar" na tela inicial
2. Escolha o tipo: Cliente, Usuário ou Equipamento
3. Para equipamentos, selecione: Computador ou Nobreak
4. Preencha os campos obrigatórios
5. Tire uma foto (opcional)
6. Salve - o código será gerado automaticamente

### Listar e Gerenciar
1. Toque em "Listar" na tela inicial
2. Use filtros para encontrar equipamentos específicos
3. Toque em um item para ver detalhes
4. Use o menu de ações para editar ou excluir

## 📊 Estrutura do Banco de Dados

### Coleções Firestore:
- `clientes`: Informações dos clientes
- `usuarios`: Usuários do sistema
- `computadores`: Dados dos computadores (códigos P0001, P0002...)
- `nobreaks`: Dados dos nobreaks (códigos N0001, N0002...)
- `contadores`: Controle de numeração sequencial

### Storage:
- `/equipamentos/computadores/{id}/foto.jpg`
- `/equipamentos/nobreaks/{id}/foto.jpg`

## 🔧 Desenvolvimento

### Estrutura do Projeto
```
lib/
├── models/          # Modelos de dados
├── services/        # Serviços Firebase
├── screens/         # Telas do aplicativo
├── widgets/         # Componentes reutilizáveis
├── utils/           # Utilitários e temas
└── main.dart        # Ponto de entrada
```

### Comandos Úteis
```bash
# Analisar código
flutter analyze

# Executar testes
flutter test

# Gerar APK
flutter build apk

# Gerar Bundle (Play Store)
flutter build appbundle
```

## 📦 Gerar APK para Instalação

```bash
# APK de debug (para testes)
flutter build apk --debug

# APK de release (para produção)
flutter build apk --release
```

O arquivo APK será gerado em: `build/app/outputs/flutter-apk/`

## 🔒 Segurança

⚠️ **IMPORTANTE**: As regras de segurança do Firebase estão configuradas para desenvolvimento. Para produção, implemente regras adequadas:

1. Acesse Firebase Console > Firestore Database > Regras
2. Acesse Firebase Console > Storage > Regras
3. Configure autenticação e autorização apropriadas

## 🐛 Solução de Problemas

### Erro de Compilação
- Verifique se todas as dependências estão instaladas: `flutter pub get`
- Limpe o cache: `flutter clean`

### Erro do Firebase
- Verifique se o arquivo `google-services.json` está no local correto
- Confirme se as chaves em `firebase_options.dart` estão corretas

### Problemas de Permissão (Câmera)
- Adicione permissões no `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique a documentação do Firebase
2. Consulte a documentação do Flutter
3. Entre em contato com a equipe de desenvolvimento

## 📄 Licença

Este projeto é propriedade da empresa P&R. Todos os direitos reservados.

---

**Desenvolvido com ❤️ para P&R Equipamentos**
