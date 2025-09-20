import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gerenciamento de Usuários'),
      body: const Center(
        child: Text('Tela de Gerenciamento de Usuários'),
      ),
    );
  }
}
