import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_theme.dart';
import '../services/cliente_service.dart';
import '../models/cliente.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  List<Cliente> _todosClientes = [];
  List<Cliente> _clientesFiltrados = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarClientes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final clientes = await ClienteService.listarClientes();
      
      // Ordena alfabeticamente por nome
      clientes.sort((a, b) => a.nome.compareTo(b.nome));
      
      setState(() {
        _todosClientes = clientes;
        _clientesFiltrados = clientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar clientes: $e';
        _isLoading = false;
      });
    }
  }

  void _filtrarClientes(String query) {
    if (query.isEmpty) {
      setState(() {
        _clientesFiltrados = _todosClientes;
      });
    } else {
      final filtro = query.toLowerCase();
      setState(() {
        _clientesFiltrados = _todosClientes.where((cliente) {
          final nome = cliente.nome.toLowerCase();
          final email = (cliente.email ?? '').toLowerCase();
          final telefone = (cliente.telefone ?? '').toLowerCase();
          
          return nome.contains(filtro) || 
                 email.contains(filtro) ||
                 telefone.contains(filtro);
        }).toList();
      });
    }
  }

  Future<void> _recarregarClientes() async {
    _searchController.clear();
    await _carregarClientes();
  }

  Widget _buildClienteCard(Cliente cliente) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Futuramente você pode criar uma tela de DetalhesClienteScreen
          // Navigator.pushNamed(context, '/detalhes-cliente', arguments: cliente);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar com a inicial do nome
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.darkGreen.withOpacity(0.1),
                child: Text(
                  cliente.nome.isNotEmpty ? cliente.nome[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGreen,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Informações do Cliente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente.nome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (cliente.email != null && cliente.email!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              cliente.email!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (cliente.telefone != null && cliente.telefone!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            cliente.telefone!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Seta ou menu de ações
              // Se quiser menu de editar/excluir, pode adicionar aqui
              // Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Clientes'),
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
            // Barra de Pesquisa
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.backgroundColor,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black.withOpacity(0.3),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filtrarClientes,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar nome, email ou telefone...',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.darkGreen),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filtrarClientes('');
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

            // Lista
            Expanded(
              child: RefreshIndicator(
                onRefresh: _recarregarClientes,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkGreen),
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
                                  onPressed: _recarregarClientes,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Tentar Novamente'),
                                ),
                              ],
                            ),
                          )
                        : _clientesFiltrados.isEmpty
                            ? Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 60),
                                      const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        _todosClientes.isEmpty 
                                            ? 'Nenhum cliente cadastrado'
                                            : 'Nenhum cliente encontrado',
                                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
                                itemCount: _clientesFiltrados.length,
                                itemBuilder: (context, index) {
                                  return _buildClienteCard(_clientesFiltrados[index]);
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastro/cliente').then((_) {
            _recarregarClientes();
          });
        },
        backgroundColor: AppTheme.darkGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}