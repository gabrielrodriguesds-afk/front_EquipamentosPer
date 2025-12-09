import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_theme.dart';
import '../services/computador_service.dart'; // Certifique-se que este arquivo existe
import '../models/computador.dart'; // Certifique-se que este arquivo existe

class ListagemComputadoresScreen extends StatefulWidget {
  const ListagemComputadoresScreen({super.key});

  @override
  State<ListagemComputadoresScreen> createState() => _ListagemComputadoresScreenState();
}

class _ListagemComputadoresScreenState extends State<ListagemComputadoresScreen> {
  // Listas para controle de dados e filtro
  List<Computador> _todosComputadores = [];
  List<Computador> _computadoresFiltrados = [];
  
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarComputadores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarComputadores() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Chama o serviço de computadores
      final computadores = await ComputadorService.listarComputadores();
      
      // ORDENAÇÃO: Garante que fique P0001, P0002, etc.
      computadores.sort((a, b) {
        return a.codigo.compareTo(b.codigo);
      });
      
      setState(() {
        _todosComputadores = computadores;
        _computadoresFiltrados = computadores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar computadores: $e';
        _isLoading = false;
      });
    }
  }

  // Lógica de Pesquisa
  void _filtrarComputadores(String query) {
    if (query.isEmpty) {
      setState(() {
        _computadoresFiltrados = _todosComputadores;
      });
    } else {
      final filtro = query.toLowerCase();
      setState(() {
        _computadoresFiltrados = _todosComputadores.where((computador) {
          final codigo = computador.codigo.toLowerCase();
          final cliente = (computador.clienteNome ?? '').toLowerCase();
          final serial = computador.numeroSerie.toLowerCase();
          
          return codigo.contains(filtro) || 
                 cliente.contains(filtro) ||
                 serial.contains(filtro);
        }).toList();
      });
    }
  }

  Future<void> _recarregarComputadores() async {
    _searchController.clear();
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
        onTap: () {
           // Rota para detalhes (ajuste se o nome da rota for diferente)
           Navigator.pushNamed(
            context,
            '/detalhes-computador',
            arguments: computador,
          ).then((_) => _recarregarComputadores());
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
                      // Pode usar outra cor para diferenciar de Nobreaks, ex: Blue
                      color: Colors.blue[700], 
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      computador.codigo, // Ex: P0001
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
              
              // Marca e Modelo
              Row(
                children: [
                  const Icon(Icons.computer, size: 16, color: Colors.grey),
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
              
              // Número de Série
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Computadores'),
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
        child: Column(
          children: [
            // Área de Pesquisa
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.backgroundColor,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black.withOpacity(0.3),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filtrarComputadores,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar código, cliente ou série...',
                    prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filtrarComputadores('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  ),
                ),
              ),
            ),

            // Lista de Resultados
            Expanded(
              child: RefreshIndicator(
                onRefresh: _recarregarComputadores,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                        ),
                      )
                    : _errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
                                ),
                              ],
                            ),
                          )
                        : _computadoresFiltrados.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 60),
                                      const Icon(Icons.desktop_windows_outlined, size: 64, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        _todosComputadores.isEmpty 
                                            ? 'Nenhum computador cadastrado'
                                            : 'Nenhum computador encontrado',
                                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                itemCount: _computadoresFiltrados.length,
                                itemBuilder: (context, index) {
                                  return _buildComputadorCard(_computadoresFiltrados[index]);
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
      // Botão removido aqui também conforme padrão da tela anterior.
      // Se quiser adicionar de volta, insira o floatingActionButton aqui.
    );
  }
}