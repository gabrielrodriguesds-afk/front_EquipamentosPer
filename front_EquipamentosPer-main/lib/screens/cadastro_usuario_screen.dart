import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CadastroUsuarioScreen extends StatelessWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Cadastro de Usuário'),
      body: Center(
        child: Text('Tela de Cadastro de Usuário'),
      ),
    );
  }
}
