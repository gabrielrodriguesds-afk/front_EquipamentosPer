import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_theme.dart';
import '../services/nobreak_service.dart';
import '../models/nobreak.dart';

class DetalhesNobreakScreen extends StatefulWidget {
  final Nobreak nobreak;

  const DetalhesNobreakScreen({Key? key, required this.nobreak}) : super(key: key);

  @override
  State<DetalhesNobreakScreen> createState() => _DetalhesNobreakScreenState();
}

class _DetalhesNobreakScreenState extends State<DetalhesNobreakScreen> {
  bool _isEditMode = false;
  bool _isLoading = false;
  
  // Controladores para os campos editáveis
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _dataBateriaController = TextEditingController();
  final TextEditingController _modeloBateriaController = TextEditingController();
  final TextEditingController _quantidadeBateriasController = TextEditingController();
  final TextEditingController _setorController = TextEditingController();
  final TextEditingController _observacaoController = TextEditingController();
  
  DateTime? _selectedDataBateria;
  late Nobreak _currentNobreak;

  @override
  void initState() {
    super.initState();
    _currentNobreak = widget.nobreak;
    _preencherCampos();
  }

  void _preencherCampos() {
    _marcaController.text = _currentNobreak.marca;
    _modeloController.text = _currentNobreak.modelo;
    _serialController.text = _currentNobreak.numeroSerie;
    
    if (_currentNobreak.dataBateria != null) {
      _selectedDataBateria = _currentNobreak.dataBateria;
      _dataBateriaController.text = _currentNobreak.dataBateria!.toIso8601String().split('T')[0];
    }
    
    _modeloBateriaController.text = _currentNobreak.modeloBateria ?? '';
    _quantidadeBateriasController.text = _currentNobreak.quantidadeBaterias.toString();
    _setorController.text = _currentNobreak.setor ?? '';
    _observacaoController.text = _currentNobreak.observacao ?? '';
  }

  Future<void> _selectDataBateria(BuildContext context) async {
    if (!_isEditMode) return;
    
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

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        // Se saiu do modo de edição, restaura os valores originais
        _preencherCampos();
      }
    });
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
                setState(() {
                  _isEditMode = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _salvarAlteracoes() async {
    setState(() {
      _isLoading = true;
    });

    final nobreakAtualizado = Nobreak.novo(
      clienteId: _currentNobreak.clienteId, // Não pode ser alterado
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
      final nobreakResponse = await NobreakService.atualizarNobreak(_currentNobreak.id, nobreakAtualizado);
      
      setState(() {
        _currentNobreak = nobreakResponse;
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

  String _formatarData(DateTime? data) {
    if (data == null) return 'Não informado';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Widget _buildInfoCard(String titulo, String valor, IconData icone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: AppTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, IconData icone, {bool isRequired = false, TextInputType? keyboardType, int maxLines = 1, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: _isEditMode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onTap: onTap,
        readOnly: onTap != null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icone),
          suffixIcon: onTap != null && _isEditMode ? const Icon(Icons.arrow_drop_down) : null,
          filled: !_isEditMode,
          fillColor: _isEditMode ? null : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryGreen),
          ),
        ),
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        } : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detalhes do Nobreak',
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: 'Editar',
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleEditMode,
              tooltip: 'Cancelar',
            ),
            IconButton(
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
              onPressed: _isLoading ? null : _salvarAlteracoes,
              tooltip: 'Salvar',
            ),
          ],
        ],
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com código e cliente (não editáveis)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.primaryGreen.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.power_outlined, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          _currentNobreak.codigo,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentNobreak.clienteNome ?? 'Cliente não informado',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (!_isEditMode) ...[
                // Modo visualização
                Text(
                  'Informações do Equipamento',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildInfoCard('Marca', _currentNobreak.marca, Icons.business_outlined),
                _buildInfoCard('Modelo', _currentNobreak.modelo, Icons.power_outlined),
                _buildInfoCard('Número de Série', _currentNobreak.numeroSerie, Icons.qr_code_outlined),
                _buildInfoCard('Data da Bateria', _formatarData(_currentNobreak.dataBateria), Icons.calendar_today_outlined),
                _buildInfoCard('Modelo da Bateria', _currentNobreak.modeloBateria ?? 'Não informado', Icons.battery_charging_full_outlined),
                _buildInfoCard('Quantidade de Baterias', _currentNobreak.quantidadeBaterias.toString(), Icons.format_list_numbered_outlined),
                _buildInfoCard('Setor', _currentNobreak.setor ?? 'Não informado', Icons.business_center_outlined),
                
                if (_currentNobreak.observacao != null && _currentNobreak.observacao!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.notes_outlined, color: AppTheme.primaryGreen, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Observações',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _currentNobreak.observacao!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                // Modo edição
                Text(
                  'Editando Informações',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cliente e código não podem ser alterados',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildEditableField('Marca *', _marcaController, Icons.business_outlined, isRequired: true),
                _buildEditableField('Modelo *', _modeloController, Icons.power_outlined, isRequired: true),
                _buildEditableField('Número de Série *', _serialController, Icons.qr_code_outlined, isRequired: true),
                _buildEditableField('Data da Bateria', _dataBateriaController, Icons.calendar_today_outlined, onTap: () => _selectDataBateria(context)),
                _buildEditableField('Modelo da Bateria', _modeloBateriaController, Icons.battery_charging_full_outlined),
                _buildEditableField('Quantidade de Baterias', _quantidadeBateriasController, Icons.format_list_numbered_outlined, keyboardType: TextInputType.number),
                _buildEditableField('Setor', _setorController, Icons.business_center_outlined),
                _buildEditableField('Observações', _observacaoController, Icons.notes_outlined, maxLines: 3),
              ],
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

