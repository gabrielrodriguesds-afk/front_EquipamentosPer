import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_theme.dart';

class CadastroNobreakScreen extends StatefulWidget {
  const CadastroNobreakScreen({Key? key}) : super(key: key);

  @override
  State<CadastroNobreakScreen> createState() => _CadastroNobreakScreenState();
}

class _CadastroNobreakScreenState extends State<CadastroNobreakScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _capacidadeController = TextEditingController();
  final TextEditingController _entradasController = TextEditingController();
  final TextEditingController _saidasController = TextEditingController();

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _serialController.dispose();
    _capacidadeController.dispose();
    _entradasController.dispose();
    _saidasController.dispose();
    super.dispose();
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final data = {
      "cliente_id": _clienteIdController.text,  // precisa existir no form!
      "marca": _marcaController.text,
      "modelo": _modeloController.text,
      "numero_serie": _serialController.text,
      "capacidade": _capacidadeController.text,
      "entradas": int.tryParse(_entradasController.text) ?? 0,
      "saidas": int.tryParse(_saidasController.text) ?? 0,
    };

    try {
      await NobreakService.cadastrarNobreak(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nobreak cadastrado com sucesso!')),
      );

      _clienteIdController.clear();
      _marcaController.clear();
      _modeloController.clear();
      _serialController.clear();
      _capacidadeController.clear();
      _entradasController.clear();
      _saidasController.clear();
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
                  TextFormField(
                    controller: _capacidadeController,
                    decoration: const InputDecoration(
                      hintText: 'Capacidade (Ex: 700VA)',
                      prefixIcon: Icon(Icons.battery_charging_full_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a capacidade';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _entradasController,
                    decoration: const InputDecoration(
                      hintText: 'Número de Entradas',
                      prefixIcon: Icon(Icons.input_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número de entradas';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _saidasController,
                    decoration: const InputDecoration(
                      hintText: 'Número de Saídas',
                      prefixIcon: Icon(Icons.output_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o número de saídas';
                      }
                      return null;
                    },
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

