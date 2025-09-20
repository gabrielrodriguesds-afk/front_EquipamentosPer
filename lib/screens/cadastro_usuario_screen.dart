import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class CadastroUsuarioScreen extends StatelessWidget {
  const CadastroUsuarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Usuário'),
      body: const Center(
        child: Text('Tela de Cadastro de Usuário'),
      ),
    );
  }
}
