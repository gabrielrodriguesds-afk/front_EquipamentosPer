import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';
import 'edicao_cliente_screen.dart';

class DetalhesClienteScreen extends StatefulWidget {
  final Cliente cliente;

  const DetalhesClienteScreen({Key? key, required this.cliente}) : super(key: key);

  @override
  State<DetalhesClienteScreen> createState() => _DetalhesClienteScreenState();
}

class _DetalhesClienteScreenState extends State<DetalhesClienteScreen> {
  late Cliente _cliente;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
  }

  Future<void> _deletarCliente() async {
    setState(() => _isLoading = true);
    try {
      await ClienteService.deletarCliente(_cliente.id);
      if (mounted) {
        Navigator.pop(context, true); // Retorna true para atualizar a lista
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar: $e')),
        );
      }
    }
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Cliente?'),
        content: Text('Deseja realmente excluir o cliente ${_cliente.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deletarCliente();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cliente'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _confirmarExclusao,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildInfoTile('Nome Completo', _cliente.nome),
                  const Divider(),
                  _buildInfoTile('E-mail', _cliente.email),
                  _buildInfoTile('Telefone', _cliente.telefone),
                  const Divider(),
                  _buildInfoTile('Endereço', _cliente.endereco, isLongText: true),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EdicaoClienteScreen(cliente: _cliente),
            ),
          );

          if (resultado != null && resultado is Cliente) {
            setState(() {
              _cliente = resultado;
            });
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryGreen,
            child: Text(
              _cliente.nome.isNotEmpty ? _cliente.nome[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _cliente.nome,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  _cliente.email ?? 'Sem e-mail',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value, {bool isLongText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            (value != null && value.isNotEmpty) ? value : '-',
            style: const TextStyle(fontSize: 16),
            maxLines: isLongText ? 5 : 1,
            overflow: isLongText ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}