import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/computador.dart';
import '../services/computador_service.dart';
import '../widgets/custom_text_field.dart';

class EdicaoComputadorScreen extends StatefulWidget {
  final Computador computador;

  const EdicaoComputadorScreen({Key? key, required this.computador}) : super(key: key);

  @override
  State<EdicaoComputadorScreen> createState() => _EdicaoComputadorScreenState();
}

class _EdicaoComputadorScreenState extends State<EdicaoComputadorScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _serialController;
  late TextEditingController _setorController;    // Novo Controller
  late TextEditingController _operadorController; // Novo Controller
  late TextEditingController _observacaoController;

  @override
  void initState() {
    super.initState();
    final c = widget.computador;
    _marcaController = TextEditingController(text: c.marca);
    _modeloController = TextEditingController(text: c.modelo);
    _serialController = TextEditingController(text: c.numeroSerie);
    _setorController = TextEditingController(text: c.setor);       // Inicializa com dados existentes
    _operadorController = TextEditingController(text: c.operador); // Inicializa com dados existentes
    _observacaoController = TextEditingController(text: c.observacao);
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _serialController.dispose();
    _setorController.dispose();
    _operadorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Cria o objeto atualizado incluindo Setor e Operador
    final computadorAtualizado = widget.computador.copyWith(
      marca: _marcaController.text,
      modelo: _modeloController.text,
      numeroSerie: _serialController.text,
      setor: _setorController.text,          // Salva Setor
      operador: _operadorController.text,    // Salva Operador
      observacao: _observacaoController.text,
    );

    try {
      final resultado = await ComputadorService.atualizarComputador(
        widget.computador.id, 
        computadorAtualizado
      );
      
      if (mounted) {
        Navigator.pop(context, resultado); // Retorna o objeto atualizado
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
        title: const Text('Editar Computador'),
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
                controller: _marcaController, 
                label: 'Marca', 
                prefixIcon: Icons.branding_watermark, 
                validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _modeloController, 
                label: 'Modelo', 
                prefixIcon: Icons.computer, 
                validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _serialController, 
                label: 'Nº Série', 
                prefixIcon: Icons.qr_code, 
                validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 15),
              
              // CAMPO SETOR
              CustomTextField(
                controller: _setorController, 
                label: 'Setor', 
                prefixIcon: Icons.place,
              ),
              const SizedBox(height: 15),

              // CAMPO OPERADOR
              CustomTextField(
                controller: _operadorController, 
                label: 'Operador', 
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 15),

              CustomTextField(
                controller: _observacaoController, 
                label: 'Observação', 
                prefixIcon: Icons.note, 
                maxLines: 3
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