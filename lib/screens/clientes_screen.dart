import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gerenciamento de Clientes'),
      body: const Center(
        child: Text('Tela de Gerenciamento de Clientes'),
      ),
    );
  }
}
