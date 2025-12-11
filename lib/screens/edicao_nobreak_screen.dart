import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/nobreak.dart';
import '../services/nobreak_service.dart';
import '../widgets/custom_text_field.dart';

class EdicaoNobreakScreen extends StatefulWidget {
  final Nobreak nobreak;

  const EdicaoNobreakScreen({Key? key, required this.nobreak}) : super(key: key);

  @override
  State<EdicaoNobreakScreen> createState() => _EdicaoNobreakScreenState();
}

class _EdicaoNobreakScreenState extends State<EdicaoNobreakScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _serialController;
  late TextEditingController _modeloBateriaController;
  late TextEditingController _quantidadeBateriasController;
  late TextEditingController _setorController;
  late TextEditingController _observacaoController;
  
  // Controlador apenas visual para mostrar a data
  late TextEditingController _dataBateriaVisualController;
  // Variável para armazenar a data real
  DateTime? _dataBateriaSelecionada;

  @override
  void initState() {
    super.initState();
    final n = widget.nobreak;
    
    _marcaController = TextEditingController(text: n.marca);
    _modeloController = TextEditingController(text: n.modelo);
    _serialController = TextEditingController(text: n.numeroSerie);
    _modeloBateriaController = TextEditingController(text: n.modeloBateria);
    _quantidadeBateriasController = TextEditingController(text: n.quantidadeBaterias?.toString());
    _setorController = TextEditingController(text: n.setor);
    _observacaoController = TextEditingController(text: n.observacao);

    // Inicializa a data
    _dataBateriaSelecionada = n.dataBateria;
    _dataBateriaVisualController = TextEditingController(
      text: _formatarData(n.dataBateria)
    );
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _serialController.dispose();
    _modeloBateriaController.dispose();
    _quantidadeBateriasController.dispose();
    _setorController.dispose();
    _observacaoController.dispose();
    _dataBateriaVisualController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataBateriaSelecionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dataBateriaSelecionada = picked;
        _dataBateriaVisualController.text = _formatarData(picked);
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Cria cópia atualizada garantindo que a Observação e a Data sejam passadas
    final nobreakAtualizado = widget.nobreak.copyWith(
      marca: _marcaController.text,
      modelo: _modeloController.text,
      numeroSerie: _serialController.text,
      modeloBateria: _modeloBateriaController.text,
      quantidadeBaterias: int.tryParse(_quantidadeBateriasController.text),
      setor: _setorController.text,
      observacao: _observacaoController.text, // Garante o envio da observação
      dataBateria: _dataBateriaSelecionada,   // Garante o envio da data nova
    );

    try {
      final resultado = await NobreakService.atualizarNobreak(
        widget.nobreak.id,
        nobreakAtualizado
      );

      if (mounted) {
        Navigator.pop(context, resultado);
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
        title: const Text('Editar Nobreak'),
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
                validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _modeloController, 
                label: 'Modelo', 
                prefixIcon: Icons.devices,
                validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _serialController, 
                label: 'Nº Série', 
                prefixIcon: Icons.qr_code,
                validator: (v) => v?.isEmpty == true ? 'Campo obrigatório' : null
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _modeloBateriaController, 
                label: 'Modelo Bateria', 
                prefixIcon: Icons.battery_std
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _quantidadeBateriasController, 
                label: 'Qtd Baterias', 
                prefixIcon: Icons.exposure_plus_1, 
                keyboardType: TextInputType.number
              ),
              const SizedBox(height: 15),
              
              // CAMPO DE DATA DA BATERIA (Adicionado)
              GestureDetector(
                onTap: _selecionarData,
                child: AbsorbPointer( // Impede a digitação manual, força o uso do calendário
                  child: CustomTextField(
                    controller: _dataBateriaVisualController,
                    label: 'Data da Troca da Bateria',
                    prefixIcon: Icons.calendar_today,
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              CustomTextField(
                controller: _setorController, 
                label: 'Setor', 
                prefixIcon: Icons.place
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