import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_theme.dart';
import '../services/nobreak_service.dart';
import '../models/nobreak.dart';

class ListagemNobreaksScreen extends StatefulWidget {
  const ListagemNobreaksScreen({Key? key}) : super(key: key);

  @override
  State<ListagemNobreaksScreen> createState() => _ListagemNobreaksScreenState();
}

class _ListagemNobreaksScreenState extends State<ListagemNobreaksScreen> {
  List<Nobreak> _nobreaks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarNobreaks();
  }

  Future<void> _carregarNobreaks() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final nobreaks = await NobreakService.listarNobreaks();
      
      setState(() {
        _nobreaks = nobreaks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar nobreaks: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _recarregarNobreaks() async {
    await _carregarNobreaks();
  }

  Widget _buildNobreakCard(Nobreak nobreak) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com código e cliente
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    nobreak.codigo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    nobreak.clienteNome ?? 'Cliente não informado',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Informações principais
            Row(
              children: [
                const Icon(Icons.business_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${nobreak.marca} ${nobreak.modelo}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.qr_code_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Série: ${nobreak.numeroSerie}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            
            // Informações adicionais se disponíveis
            if (nobreak.setor != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.business_center_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Setor: ${nobreak.setor}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
            
            if (nobreak.dataBateria != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.battery_charging_full_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Data Bateria: ${_formatarData(nobreak.dataBateria!)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
            
            if (nobreak.quantidadeBaterias > 1) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.format_list_numbered_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Baterias: ${nobreak.quantidadeBaterias}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
            
            if (nobreak.observacao != null && nobreak.observacao!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  nobreak.observacao!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Nobreaks Cadastrados'),
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
        child: RefreshIndicator(
          onRefresh: _recarregarNobreaks,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _recarregarNobreaks,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Tentar Novamente'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _nobreaks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.power_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Nenhum nobreak cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Cadastre o primeiro nobreak para vê-lo aqui',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cadastro-nobreak');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Cadastrar Nobreak'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryGreen,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: _nobreaks.length,
                          itemBuilder: (context, index) {
                            return _buildNobreakCard(_nobreaks[index]);
                          },
                        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro-nobreak').then((_) {
            // Recarregar a lista quando voltar da tela de cadastro
            _recarregarNobreaks();
          });
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

