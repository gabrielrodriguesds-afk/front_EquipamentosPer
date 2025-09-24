import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_theme.dart';
import '../services/computador_service.dart';
import '../models/computador.dart';
// import 'detalhes_computador_screen.dart'; // Removido temporariamente

class ListagemComputadoresScreen extends StatefulWidget {
  const ListagemComputadoresScreen({Key? key}) : super(key: key);

  @override
  State<ListagemComputadoresScreen> createState() => _ListagemComputadoresScreenState();
}

class _ListagemComputadoresScreenState extends State<ListagemComputadoresScreen> {
  List<Computador> _computadores = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarComputadores();
  }

  Future<void> _carregarComputadores() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final computadores = await ComputadorService.listarComputadores();
      
      setState(() {
        _computadores = computadores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar computadores: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _recarregarComputadores() async {
    await _carregarComputadores();
  }

  Widget _buildComputadorCard(Computador computador) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          // Removido temporariamente a navegação para DetalhesComputadorScreen
          // final result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DetalhesComputadorScreen(computador: computador),
          //   ),
          // );
          
          // if (result == true) {
          //   _recarregarComputadores();
          // }
        },
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
                      computador.codigo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      computador.clienteNome ?? 'Cliente não informado',
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
                    '${computador.marca} ${computador.modelo}',
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
                    'Série: ${computador.numeroSerie}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              
              // Informações adicionais se disponíveis
              if (computador.setor != null && computador.setor!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.business_center_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Setor: ${computador.setor}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
              
              if (computador.operador != null && computador.operador!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Operador: ${computador.operador}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            
              if (computador.observacao != null && computador.observacao!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    computador.observacao!,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Computadores Cadastrados'),
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
          onRefresh: _recarregarComputadores,
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
                            onPressed: _recarregarComputadores,
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
                  : _computadores.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.computer,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Nenhum computador cadastrado',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Cadastre o primeiro computador para vê-lo aqui',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cadastro-computador');
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Cadastrar Computador'),
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
                          itemCount: _computadores.length,
                          itemBuilder: (context, index) {
                            return _buildComputadorCard(_computadores[index]);
                          },
                        ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro-computador').then((_) {
            // Recarregar a lista quando voltar da tela de cadastro
            _recarregarComputadores();
          });
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


