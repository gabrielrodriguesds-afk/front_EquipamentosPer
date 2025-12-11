import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Cadastro'),
      body: Center(
        child: Text('Tela de Cadastro Geral'),
      ),
    );
  }
}