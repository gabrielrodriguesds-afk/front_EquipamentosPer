import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/computador.dart';
import '../services/computador_service.dart';
import 'edicao_computador_screen.dart';

class DetalhesComputadorScreen extends StatefulWidget {
  final Computador computador;

  const DetalhesComputadorScreen({Key? key, required this.computador}) : super(key: key);

  @override
  State<DetalhesComputadorScreen> createState() => _DetalhesComputadorScreenState();
}

class _DetalhesComputadorScreenState extends State<DetalhesComputadorScreen> {
  late Computador _computador;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _computador = widget.computador;
  }

  Future<void> _deletarComputador() async {
    setState(() => _isLoading = true);
    try {
      await ComputadorService.deletarComputador(_computador.id);
      if (mounted) {
        Navigator.pop(context, true); // Retorna true para atualizar a lista anterior
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
        title: const Text('Excluir Computador?'),
        content: Text('Deseja realmente excluir o computador ${_computador.codigo}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deletarComputador();
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
        title: Text('${_computador.marca} ${_computador.modelo}'),
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
                  _buildInfoTile('Código', _computador.codigo),
                  _buildInfoTile('Cliente', _computador.clienteNome ?? 'Não informado'),
                  const Divider(),
                  _buildInfoTile('Número de Série', _computador.numeroSerie),
                  
                  // NOVOS CAMPOS ADICIONADOS AQUI
                  _buildInfoTile('Setor', _computador.setor),
                  _buildInfoTile('Operador', _computador.operador),
                  
                  const Divider(),
                  _buildInfoTile('Observação', _computador.observacao, isLongText: true),
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
              builder: (context) => EdicaoComputadorScreen(computador: _computador),
            ),
          );

          if (resultado != null && resultado is Computador) {
            setState(() {
              _computador = resultado;
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
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.computer, size: 40, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _computador.codigo,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  _computador.marca,
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
            maxLines: isLongText ? 10 : 1,
            overflow: isLongText ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}