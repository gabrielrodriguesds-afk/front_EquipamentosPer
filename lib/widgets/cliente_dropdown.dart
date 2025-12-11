import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';
import '../utils/app_theme.dart';

class ClienteDropdown extends StatefulWidget {
  final String? selectedClienteId;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const ClienteDropdown({
    Key? key,
    this.selectedClienteId,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  State<ClienteDropdown> createState() => _ClienteDropdownState();
}

class _ClienteDropdownState extends State<ClienteDropdown> {
  final TextEditingController _displayController = TextEditingController();
  List<Cliente> _todosClientes = [];
  String? _currentSelectedId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentSelectedId = widget.selectedClienteId;
    _carregarClientes();
  }

  @override
  void didUpdateWidget(covariant ClienteDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedClienteId != oldWidget.selectedClienteId) {
      _currentSelectedId = widget.selectedClienteId;
      _atualizarTextoDisplay();
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _carregarClientes() async {
    setState(() => _isLoading = true);
    try {
      final clientes = await ClienteService.listarClientes();
      
      // 1. Ordenação Alfabética
      clientes.sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));

      if (mounted) {
        setState(() {
          _todosClientes = clientes;
          _isLoading = false;
        });
        _atualizarTextoDisplay();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Opcional: Tratar erro
      }
    }
  }

  void _atualizarTextoDisplay() {
    if (_currentSelectedId != null && _todosClientes.isNotEmpty) {
      try {
        final cliente = _todosClientes.firstWhere((c) => c.id == _currentSelectedId);
        _displayController.text = cliente.nome;
      } catch (e) {
        _displayController.text = '';
      }
    } else {
      _displayController.text = '';
    }
  }

  void _abrirSelecaoCliente() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ClienteSearchModal(
        clientes: _todosClientes,
        onSelected: (cliente) {
          setState(() {
            _currentSelectedId = cliente.id;
            _displayController.text = cliente.nome;
          });
          widget.onChanged(cliente.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um TextFormField "readOnly" para simular o dropdown,
    // mas com comportamento de clique customizado.
    return TextFormField(
      controller: _displayController,
      readOnly: true,
      onTap: _isLoading ? null : _abrirSelecaoCliente,
      validator: widget.validator ?? (value) {
        if (_currentSelectedId == null || _currentSelectedId!.isEmpty) {
          return 'Por favor, selecione um cliente';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Cliente',
        hintText: 'Toque para pesquisar...',
        prefixIcon: const Icon(Icons.person_search),
        suffixIcon: _isLoading 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              ) 
            : const Icon(Icons.arrow_drop_down),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

// Widget interno para o Modal de Pesquisa
class _ClienteSearchModal extends StatefulWidget {
  final List<Cliente> clientes;
  final ValueChanged<Cliente> onSelected;

  const _ClienteSearchModal({
    Key? key,
    required this.clientes,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<_ClienteSearchModal> createState() => _ClienteSearchModalState();
}

class _ClienteSearchModalState extends State<_ClienteSearchModal> {
  List<Cliente> _listaFiltrada = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listaFiltrada = widget.clientes;
  }

  void _filtrar(String query) {
    final termo = query.toLowerCase();
    setState(() {
      _listaFiltrada = widget.clientes.where((c) {
        return c.nome.toLowerCase().contains(termo);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Ocupa 70% da tela
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de busca
          TextField(
            controller: _searchController,
            onChanged: _filtrar,
            decoration: InputDecoration(
              hintText: 'Pesquisar cliente...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          
          // Lista de resultados
          Expanded(
            child: _listaFiltrada.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum cliente encontrado',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: _listaFiltrada.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final cliente = _listaFiltrada[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                          child: Text(
                            cliente.nome.isNotEmpty ? cliente.nome[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(cliente.nome),
                        onTap: () => widget.onSelected(cliente),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}