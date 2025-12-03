import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_theme.dart';
import '../widgets/custom_text_field.dart'; // Seu widget de input padrão

class EdicaoNobreakScreen extends StatefulWidget {
  final Map<String, dynamic> nobreak;

  const EdicaoNobreakScreen({Key? key, required this.nobreak}) : super(key: key);

  @override
  State<EdicaoNobreakScreen> createState() => _EdicaoNobreakScreenState();
}

class _EdicaoNobreakScreenState extends State<EdicaoNobreakScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _clienteIdController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _serialController;
  late TextEditingController _dataBateriaController;
  late TextEditingController _modeloBateriaController;
  late TextEditingController _quantidadeBateriasController;
  late TextEditingController _setorController;
  late TextEditingController _observacaoController;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os dados atuais
    final n = widget.nobreak;
    _clienteIdController = TextEditingController(text: n['cliente_id']?.toString());
    _marcaController = TextEditingController(text: n['marca']);
    _modeloController = TextEditingController(text: n['modelo']);
    _serialController = TextEditingController(text: n['numero_serie']);
    _dataBateriaController = TextEditingController(text: n['data_troca_bateria']);
    _modeloBateriaController = TextEditingController(text: n['modelo_bateria']);
    _quantidadeBateriasController = TextEditingController(text: n['quantidade_baterias']?.toString());
    _setorController = TextEditingController(text: n['setor']);
    _observacaoController = TextEditingController(text: n['observacao']);
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

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    final dadosAtualizados = {
      'id': widget.nobreak['id'], // Mantém o ID original
      'cliente_id': int.tryParse(_clienteIdController.text),
      'marca': _marcaController.text,
      'modelo': _modeloController.text,
      'numero_serie': _serialController.text,
      'data_troca_bateria': _dataBateriaController.text,
      'modelo_bateria': _modeloBateriaController.text,
      'quantidade_baterias': int.tryParse(_quantidadeBateriasController.text),
      'setor': _setorController.text,
      'observacao': _observacaoController.text,
    };

    // Chamada PUT
    final url = Uri.parse('http://SEU_IP:3000/nobreaks/${widget.nobreak['id']}');
    
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(dadosAtualizados),
      );

      if (response.statusCode == 200) {
        // Retorna os dados novos para a tela anterior atualizar sem precisar buscar na API de novo
        Navigator.pop(context, dadosAtualizados); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Erro ao atualizar dados')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Erro de conexão')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Nobreak'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(controller: _clienteIdController, label: 'ID Cliente', icon: Icons.person, keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              CustomTextField(controller: _marcaController, label: 'Marca', icon: Icons.branding_watermark),
              const SizedBox(height: 15),
              CustomTextField(controller: _modeloController, label: 'Modelo', icon: Icons.devices),
              const SizedBox(height: 15),
              CustomTextField(controller: _serialController, label: 'Nº Série', icon: Icons.qr_code),
              const SizedBox(height: 15),
              CustomTextField(controller: _modeloBateriaController, label: 'Modelo Bateria', icon: Icons.battery_std),
              const SizedBox(height: 15),
              CustomTextField(controller: _quantidadeBateriasController, label: 'Qtd Baterias', icon: Icons.exposure_plus_1, keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              CustomTextField(controller: _dataBateriaController, label: 'Data Troca', icon: Icons.calendar_today),
              const SizedBox(height: 15),
              CustomTextField(controller: _setorController, label: 'Setor', icon: Icons.place),
              const SizedBox(height: 15),
              CustomTextField(controller: _observacaoController, label: 'Observação', icon: Icons.note, maxLines: 3),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: const Text('SALVAR ALTERAÇÕES', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}