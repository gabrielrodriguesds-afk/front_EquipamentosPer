import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

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
  List<Cliente> _clientes = [];
  String? _currentSelectedClienteId;

  @override
  void initState() {
    super.initState();
    _currentSelectedClienteId = widget.selectedClienteId;
    _fetchClientes();
  }

  Future<void> _fetchClientes() async {
    try {
      final clientes = await ClienteService.listarClientes();
      setState(() {
        _clientes = clientes;
      });
    } catch (e) {
      // Handle error, e.g., show a SnackBar
      print('Erro ao carregar clientes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _currentSelectedClienteId,
      decoration: const InputDecoration(
        hintText: 'Selecione o Cliente',
        prefixIcon: Icon(Icons.person_search),
      ),
      items: _clientes.map((cliente) {
        return DropdownMenuItem<String>(
          value: cliente.id,
          child: Text(cliente.nome),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _currentSelectedClienteId = newValue;
        });
        widget.onChanged(newValue);
      },
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione um cliente';
            }
            return null;
          },
    );
  }
}


