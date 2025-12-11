# 🚀 Próximos Passos - P&R Equipamentos

Este documento orienta sobre como continuar o desenvolvimento do aplicativo P&R Equipamentos.

## ✅ O que já foi implementado

### 1. Estrutura Base
- ✅ Projeto Flutter configurado
- ✅ Dependências instaladas (Firebase, Camera, etc.)
- ✅ Estrutura de pastas organizada
- ✅ Identidade visual aplicada

### 2. Backend e Modelos
- ✅ Configuração Firebase (Firestore + Storage)
- ✅ Modelos de dados (Cliente, Usuario, Computador, Nobreak)
- ✅ Serviços CRUD completos
- ✅ Geração automática de códigos (P0001, N0001)
- ✅ Upload de imagens

### 3. Interface Base
- ✅ Tema personalizado com cores da empresa
- ✅ Componentes reutilizáveis (AppBar, Button, TextField, Card)
- ✅ Tela inicial com menu
- ✅ Tela de seleção de tipo de cadastro

## 🔨 O que precisa ser implementado

### Fase 5: Telas de Cadastro
```
lib/screens/
├── cadastro/
│   ├── cliente_form_screen.dart
│   ├── usuario_form_screen.dart
│   ├── computador_form_screen.dart
│   └── nobreak_form_screen.dart
```

**Exemplo de implementação (Cliente):**
```dart
// lib/screens/cadastro/cliente_form_screen.dart
import 'package:flutter/material.dart';
import '../../models/cliente.dart';
import '../../services/cliente_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente; // null = novo, preenchido = edição
  
  const ClienteFormScreen({Key? key, this.cliente}) : super(key: key);
  
  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _nomeController.text = widget.cliente!.nome;
      _emailController.text = widget.cliente!.email ?? '';
      _telefoneController.text = widget.cliente!.telefone ?? '';
      _enderecoController.text = widget.cliente!.endereco ?? '';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente',
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                label: 'Nome',
                controller: _nomeController,
                required: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Telefone',
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Endereço',
                controller: _enderecoController,
                maxLines: 3,
              ),
              const Spacer(),
              CustomButton(
                text: widget.cliente == null ? 'Cadastrar' : 'Atualizar',
                onPressed: _salvarCliente,
                isLoading: _isLoading,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _salvarCliente() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      if (widget.cliente == null) {
        // Novo cliente
        Cliente novoCliente = Cliente.novo(
          nome: _nomeController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
          endereco: _enderecoController.text.isEmpty ? null : _enderecoController.text,
        );
        
        await ClienteService.criarCliente(novoCliente);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente cadastrado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } else {
        // Editar cliente existente
        Cliente clienteAtualizado = widget.cliente!.copyWith(
          nome: _nomeController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          telefone: _telefoneController.text.isEmpty ? null : _telefoneController.text,
          endereco: _enderecoController.text.isEmpty ? null : _enderecoController.text,
        );
        
        await ClienteService.atualizarCliente(clienteAtualizado);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente atualizado com sucesso!')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
```

### Fase 6: Telas de Listagem
```
lib/screens/
├── listagem/
│   ├── equipamentos_list_screen.dart
│   ├── clientes_list_screen.dart
│   └── usuarios_list_screen.dart
```

### Fase 7: Funcionalidades de Câmera
```
lib/services/
└── camera_service.dart

lib/widgets/
└── photo_picker.dart
```

### Fase 8: Telas de Detalhes
```
lib/screens/
├── detalhes/
│   ├── equipamento_detail_screen.dart
│   ├── cliente_detail_screen.dart
│   └── usuario_detail_screen.dart
```

## 🎯 Implementação Sugerida

### 1. Comece pelas telas de cadastro mais simples
1. `cliente_form_screen.dart`
2. `usuario_form_screen.dart`
3. `computador_form_screen.dart` (com seletor de cliente)
4. `nobreak_form_screen.dart` (com seletor de cliente e data picker)

### 2. Adicione as rotas no main.dart
```dart
routes: {
  '/': (context) => const HomeScreen(),
  '/cadastro': (context) => const CadastroTipoScreen(),
  '/cadastro/cliente': (context) => const ClienteFormScreen(),
  '/cadastro/usuario': (context) => const UsuarioFormScreen(),
  '/cadastro/computador': (context) => const ComputadorFormScreen(),
  '/cadastro/nobreak': (context) => const NobreakFormScreen(),
  // ... outras rotas
},
```

### 3. Implemente as telas de listagem
- Use `StreamBuilder` para dados em tempo real
- Implemente filtros e busca
- Use o widget `EquipmentCard` já criado

### 4. Adicione funcionalidade de câmera
```dart
// Exemplo de uso do image_picker
import 'package:image_picker/image_picker.dart';

Future<File?> _tirarFoto() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(
    source: ImageSource.camera,
    maxWidth: 1024,
    maxHeight: 1024,
    imageQuality: 80,
  );
  
  if (image != null) {
    return File(image.path);
  }
  return null;
}
```

### 5. Implemente a geração de códigos
- Os serviços já têm a lógica implementada
- Após salvar, mostre o código gerado em um dialog
- Permita que o usuário confirme antes de finalizar

## 🔧 Ferramentas Úteis

### Widgets Flutter Importantes
- `StreamBuilder`: Para dados em tempo real do Firebase
- `FutureBuilder`: Para operações assíncronas
- `Form` e `TextFormField`: Para formulários
- `DropdownButton`: Para seleção de clientes
- `DatePicker`: Para data da bateria dos nobreaks
- `AlertDialog`: Para confirmações e códigos gerados

### Packages Adicionais (se necessário)
```yaml
dependencies:
  # Já incluídos
  image_picker: ^1.0.4
  camera: ^0.10.5+5
  
  # Podem ser úteis
  cached_network_image: ^3.3.0  # Para cache de imagens
  flutter_datetime_picker: ^1.5.1  # Date picker customizado
```

## 🎨 Manter Consistência Visual

- Use sempre os widgets personalizados (`CustomAppBar`, `CustomButton`, etc.)
- Siga as cores do `AppTheme`
- Mantenha espaçamentos consistentes (16px padrão)
- Use `SnackBar` para feedback ao usuário
- Implemente loading states nos botões

## 🧪 Testes

1. Teste sem conexão Firebase (modo offline)
2. Teste com dados reais
3. Teste a câmera em dispositivo físico
4. Teste a geração de códigos sequenciais
5. Teste edição e exclusão de registros

## 📱 Geração do APK

Quando tudo estiver funcionando:

```bash
# Limpar cache
flutter clean
flutter pub get

# Gerar APK de release
flutter build apk --release

# O APK estará em: build/app/outputs/flutter-apk/app-release.apk
```

## 🔥 Configuração Firebase (IMPORTANTE)

Antes de testar:
1. Configure um projeto Firebase real
2. Substitua `google-services.json.example` pelo arquivo real
3. Atualize as chaves em `firebase_options.dart`
4. Configure as regras de segurança adequadas

---

**Boa sorte com o desenvolvimento! 🚀**

