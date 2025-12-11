import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/cliente_dropdown.dart';
import '../utils/app_theme.dart';
import '../services/nobreak_service.dart';
import '../models/nobreak.dart';

class CadastroNobreakScreen extends StatefulWidget {
  const CadastroNobreakScreen({super.key});

  @override
  State<CadastroNobreakScreen> createState() => _CadastroNobreakScreenState();
}

class _CadastroNobreakScreenState extends State<CadastroNobreakScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteIdController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _dataBateriaController = TextEditingController();
  final TextEditingController _modeloBateriaController = TextEditingController();
  final TextEditingController _quantidadeBateriasController = TextEditingController();
  final TextEditingController _setorController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();

  DateTime? _selectedDataBateria;

  Future<void> _selectDataBateria(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDataBateria ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDataBateria) {
      setState(() {
        _selectedDataBateria = picked;
        _dataBateriaController.text = picked.toIso8601String().split('T')[0]; // Formato YYYY-MM-DD
      });
    }
  }

  @override
  void dispose() {
    _clienteIdController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _serialController.dispose();
    _dataBateriaController.dispose();
    _modeloBateriaController.dispose();
    _quantidadeBateriasController.dispose();
    _setorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  void _showCodigoModal(String codigo) {
    showDialog(
      context: context,
      barrierDismissible: false, // Não permite fechar clicando fora
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Nobreak Cadastrado!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nobreak cadastrado com sucesso!',
                style: TextStyle(fontSize: 16),
              ),
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
                    const Text(
                      'Código do Equipamento:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      codigo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final nobreak = Nobreak.novo(
        clienteId: _clienteIdController.text,
        marca: _marcaController.text,
        modelo: _modeloController.text,
        numeroSerie: _serialController.text,
        dataBateria: _selectedDataBateria,
        modeloBateria: _modeloBateriaController.text.isEmpty ? null : _modeloBateriaController.text,
        quantidadeBaterias: int.tryParse(_quantidadeBateriasController.text) ?? 1,
        setor: _setorController.text.isEmpty ? null : _setorController.text,
        observacao: _observacaoController.text.isEmpty ? null : _observacaoController.text,
      );

      try {
        final nobreakCriado = await NobreakService.criarNobreak(nobreak);
        
        // Limpar os campos
        _clienteIdController.clear();
        _marcaController.clear();
        _modeloController.clear();
        _serialController.clear();
        _dataBateriaController.clear();
        _selectedDataBateria = null;
        _modeloBateriaController.clear();
        _quantidadeBateriasController.clear();
        _setorController.clear();
        _observacaoController.clear();
        
        // Exibir modal com o código
        _showCodigoModal(nobreakCriado.codigo);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar nobreak: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Nobreak'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    'Preencha os dados do novo nobreak',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ClienteDropdown(
                    selectedClienteId: _clienteIdController.text.isEmpty ? null : _clienteIdController.text,
                    onChanged: (newValue) {
                      setState(() {
                        _clienteIdController.text = newValue ?? '';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione um cliente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _marcaController,
                    decoration: const InputDecoration(
                      hintText: 'Marca',
                      prefixIcon: Icon(Icons.business_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a marca';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modeloController,
                    decoration: const InputDecoration(
                      hintText: 'Modelo',
                      prefixIcon: Icon(Icons.power_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o modelo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _serialController,
                    decoration: const InputDecoration(
                      hintText: 'Número de Série',
                      prefixIcon: Icon(Icons.qr_code_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número de série';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDataBateria(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dataBateriaController,
                        decoration: const InputDecoration(
                          hintText: 'Data da Bateria (opcional)',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modeloBateriaController,
                    decoration: const InputDecoration(
                      hintText: 'Modelo da Bateria (opcional)',
                      prefixIcon: Icon(Icons.battery_charging_full_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantidadeBateriasController,
                    decoration: const InputDecoration(
                      hintText: 'Quantidade de Baterias (opcional, padrão 1)',
                      prefixIcon: Icon(Icons.format_list_numbered_outlined),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _setorController,
                    decoration: const InputDecoration(
                      hintText: 'Setor (opcional)',
                      prefixIcon: Icon(Icons.business_center_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _observacaoController,
                    decoration: const InputDecoration(
                      hintText: 'Observações (opcional)',
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Nobreak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

