import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/cliente_dropdown.dart';
import '../utils/app_theme.dart';
import '../services/nobreak_service.dart';
import '../models/nobreak.dart';

class EdicaoNobreakScreen extends StatefulWidget {
  final Nobreak nobreak;

  const EdicaoNobreakScreen({Key? key, required this.nobreak}) : super(key: key);

  @override
  State<EdicaoNobreakScreen> createState() => _EdicaoNobreakScreenState();
}

class _EdicaoNobreakScreenState extends State<EdicaoNobreakScreen> {
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _preencherCampos();
  }

  void _preencherCampos() {
    _clienteIdController.text = widget.nobreak.clienteId;
    _marcaController.text = widget.nobreak.marca;
    _modeloController.text = widget.nobreak.modelo;
    _serialController.text = widget.nobreak.numeroSerie;
    
    if (widget.nobreak.dataBateria != null) {
      _selectedDataBateria = widget.nobreak.dataBateria;
      _dataBateriaController.text = widget.nobreak.dataBateria!.toIso8601String().split('T')[0];
    }
    
    _modeloBateriaController.text = widget.nobreak.modeloBateria ?? '';
    _quantidadeBateriasController.text = widget.nobreak.quantidadeBaterias.toString();
    _setorController.text = widget.nobreak.setor ?? '';
    _observacaoController.text = widget.nobreak.observacao ?? '';
  }

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
        _dataBateriaController.text = picked.toIso8601String().split('T')[0];
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

  void _showSucessoModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('Nobreak Atualizado!'),
            ],
          ),
          content: const Text(
            'Nobreak atualizado com sucesso!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o modal
                Navigator.of(context).pop(true); // Volta para a lista com indicação de atualização
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
      setState(() {
        _isLoading = true;
      });

      final nobreakAtualizado = Nobreak.novo(
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
        await NobreakService.atualizarNobreak(widget.nobreak.id, nobreakAtualizado);
        
        setState(() {
          _isLoading = false;
        });
        
        _showSucessoModal();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar nobreak: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Editar Nobreak ${widget.nobreak.codigo}',
      ),
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
                  // Cabeçalho com informações do nobreak
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.edit, color: AppTheme.primaryGreen),
                            const SizedBox(width: 8),
                            Text(
                              'Editando Nobreak',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Código: ${widget.nobreak.codigo}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Formulário
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
                    onPressed: _isLoading ? null : _submitForm,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Salvando...' : 'Salvar Alterações'),
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

