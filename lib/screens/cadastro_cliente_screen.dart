import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CadastroClienteScreen extends StatelessWidget {
  const CadastroClienteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Cliente'),
      body: const Center(
        child: Text('Tela de Cadastro de Cliente'),
      ),
    );
  }
}
