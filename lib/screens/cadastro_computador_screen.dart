import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/cliente_dropdown.dart';
import '../utils/app_theme.dart';
import '../services/computador_service.dart';
import '../models/computador.dart';

class CadastroComputadorScreen extends StatefulWidget {
  const CadastroComputadorScreen({Key? key}) : super(key: key);

  @override
  State<CadastroComputadorScreen> createState() => _CadastroComputadorScreenState();
}

class _CadastroComputadorScreenState extends State<CadastroComputadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteIdController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _setorController = TextEditingController();
  final TextEditingController _operadorController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _clienteIdController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _serialController.dispose();
    _setorController.dispose();
    _operadorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _showCodigoModal(String codigo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text("Computador Cadastrado!"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Computador cadastrado com sucesso!", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    const Text("Código do Equipamento:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text(codigo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _salvarComputador() async {
    if (!_formKey.currentState!.validate()) return;

    if (_clienteIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um cliente'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. VALIDAÇÃO DE SERIAL REPETIDO
      final serialDigitado = _serialController.text.trim();
      
      // Busca lista atual para verificar duplicidade (pode ser otimizado com endpoint de busca)
      final listaExistente = await ComputadorService.listarComputadores();
      final jaExiste = listaExistente.any((c) => c.numeroSerie.toLowerCase() == serialDigitado.toLowerCase());

      if (jaExiste) {
        if (!mounted) return;
        setState(() => _isLoading = false); // Para o loading para mostrar o alerta

        // Pergunta ao usuário
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(children: [Icon(Icons.warning_amber, color: Colors.orange), SizedBox(width: 10), Text("Serial Duplicado")]),
            content: Text("O número de série '$serialDigitado' já existe cadastrado.\n\nDeseja cadastrar mesmo assim?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Não")),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true), 
                child: const Text("Sim, Cadastrar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        // Se clicou em Não ou fora, cancela
        if (confirmar != true) return;

        // Se Sim, continua
        setState(() => _isLoading = true);
      }

      // 2. CRIAÇÃO DO OBJETO E ENVIO
      final computador = Computador.novo(
        clienteId: _clienteIdController.text,
        marca: _marcaController.text,
        modelo: _modeloController.text,
        numeroSerie: _serialController.text,
        setor: _setorController.text.isEmpty ? null : _setorController.text,
        operador: _operadorController.text.isEmpty ? null : _operadorController.text,
        observacao: _observacaoController.text.isEmpty ? null : _observacaoController.text,
      );

      final computadorCriado = await ComputadorService.criarComputador(computador);

      if (mounted) {
        _clienteIdController.clear();
        _marcaController.clear();
        _modeloController.clear();
        _serialController.clear();
        _setorController.clear();
        _operadorController.clear();
        _observacaoController.clear();
        _showCodigoModal(computadorCriado.codigo);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Computador'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Seleção de Cliente
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cliente', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ClienteDropdown(
                          onChanged: (clienteId) {
                            _clienteIdController.text = clienteId ?? "";
                          },
                          selectedClienteId: _clienteIdController.text.isEmpty ? null : _clienteIdController.text,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Informações do Computador
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Informações do Computador', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _marcaController,
                          decoration: const InputDecoration(labelText: 'Marca *', prefixIcon: Icon(Icons.business)),
                          validator: (v) => v?.isEmpty == true ? 'Informe a marca' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _modeloController,
                          decoration: const InputDecoration(labelText: 'Modelo *', prefixIcon: Icon(Icons.computer)),
                          validator: (v) => v?.isEmpty == true ? 'Informe o modelo' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _serialController,
                          decoration: const InputDecoration(labelText: 'Número de Série *', prefixIcon: Icon(Icons.confirmation_number)),
                          validator: (v) => v?.isEmpty == true ? 'Informe o número de série' : null,
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _setorController,
                          decoration: const InputDecoration(labelText: 'Setor', prefixIcon: Icon(Icons.location_on)),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _operadorController,
                          decoration: const InputDecoration(labelText: 'Operador', prefixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _observacaoController,
                          decoration: const InputDecoration(labelText: 'Observação', prefixIcon: Icon(Icons.note)),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _salvarComputador,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Salvar Computador', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}