import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CadastroComputadorScreen extends StatelessWidget {
  const CadastroComputadorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Computador'),
      body: const Center(
        child: Text('Tela de Cadastro de Computador'),
      ),
    );
  }
}
