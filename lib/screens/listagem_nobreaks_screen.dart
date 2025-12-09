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
  // Lista completa original (para manter os dados enquanto filtra)
  List<Nobreak> _todosNobreaks = [];
  // Lista que será exibida na tela (pode estar filtrada)
  List<Nobreak> _nobreaksFiltrados = [];
  
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarNobreaks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarNobreaks() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final nobreaks = await NobreakService.listarNobreaks();
      
      // 1. Lógica de Ordenação por Código (N0001, N0002...)
      nobreaks.sort((a, b) {
        // Compara as strings dos códigos (ex: "N0001" vem antes de "N0002")
        return a.codigo.compareTo(b.codigo);
      });
      
      setState(() {
        _todosNobreaks = nobreaks;
        _nobreaksFiltrados = nobreaks; // Inicialmente exibe tudo
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar nobreaks: $e';
        _isLoading = false;
      });
    }
  }

  // 2. Lógica de Filtragem (Código ou Cliente)
  void _filtrarNobreaks(String query) {
    if (query.isEmpty) {
      setState(() {
        _nobreaksFiltrados = _todosNobreaks;
      });
    } else {
      final filtro = query.toLowerCase();
      setState(() {
        _nobreaksFiltrados = _todosNobreaks.where((nobreak) {
          final codigo = nobreak.codigo.toLowerCase();
          final cliente = (nobreak.clienteNome ?? '').toLowerCase();
          final serial = nobreak.numeroSerie.toLowerCase();
          
          // Verifica se o texto digitado está no código, no nome do cliente ou no serial
          return codigo.contains(filtro) || 
                 cliente.contains(filtro) ||
                 serial.contains(filtro);
        }).toList();
      });
    }
  }

  Future<void> _recarregarNobreaks() async {
    // Limpa a busca ao recarregar
    _searchController.clear();
    await _carregarNobreaks();
  }

  Widget _buildNobreakCard(Nobreak nobreak) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
           Navigator.pushNamed(
            context,
            '/detalhes-nobreak',
            arguments: nobreak,
          ).then((_) => _recarregarNobreaks());
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
              if (nobreak.dataBateria != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Bateria: ${_formatarData(nobreak.dataBateria!)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ],
          ),
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
      appBar: const CustomAppBar(title: 'Nobreaks'),
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
                  onChanged: _filtrarNobreaks,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar código, cliente ou série...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGreen),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filtrarNobreaks('');
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
                                const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
                                ),
                              ],
                            ),
                          )
                        : _nobreaksFiltrados.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 60),
                                      const Icon(Icons.search_off, size: 64, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        _todosNobreaks.isEmpty 
                                            ? 'Nenhum nobreak cadastrado'
                                            : 'Nenhum nobreak encontrado',
                                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80), // Espaço para o FAB
                                itemCount: _nobreaksFiltrados.length,
                                itemBuilder: (context, index) {
                                  return _buildNobreakCard(_nobreaksFiltrados[index]);
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