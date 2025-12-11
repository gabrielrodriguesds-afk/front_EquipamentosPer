import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';
import '../widgets/custom_text_field.dart';

class EdicaoClienteScreen extends StatefulWidget {
  final Cliente cliente;

  const EdicaoClienteScreen({Key? key, required this.cliente}) : super(key: key);

  @override
  State<EdicaoClienteScreen> createState() => _EdicaoClienteScreenState();
}

class _EdicaoClienteScreenState extends State<EdicaoClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _enderecoController;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    _nomeController = TextEditingController(text: c.nome);
    _emailController = TextEditingController(text: c.email);
    _telefoneController = TextEditingController(text: c.telefone);
    _enderecoController = TextEditingController(text: c.endereco);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Cria o objeto atualizado
    final clienteAtualizado = widget.cliente.copyWith(
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      endereco: _enderecoController.text,
    );

    try {
      final resultado = await ClienteService.atualizarCliente(
        widget.cliente.id, 
        clienteAtualizado
      );
      
      if (mounted) {
        Navigator.pop(context, resultado); // Retorna o cliente atualizado
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nomeController, 
                label: 'Nome Completo', 
                prefixIcon: Icons.person,
                validator: (v) => v?.isEmpty == true ? 'Nome é obrigatório' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _emailController, 
                label: 'E-mail', 
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _telefoneController, 
                label: 'Telefone', 
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _enderecoController, 
                label: 'Endereço', 
                prefixIcon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SALVAR ALTERAÇÕES', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}