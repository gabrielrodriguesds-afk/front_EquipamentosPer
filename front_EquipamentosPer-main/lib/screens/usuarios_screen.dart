import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Gerenciamento de Usuários'),
      body: Center(
        child: Text('Tela de Gerenciamento de Usuários'),
      ),
    );
  }
}
