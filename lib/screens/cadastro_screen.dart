import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro'),
      body: const Center(
        child: Text('Tela de Cadastro Geral'),
      ),
    );
  }
}