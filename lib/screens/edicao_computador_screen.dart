import 'package:flutter/material.dart';

class EdicaoComputadoresScreen extends StatelessWidget {
  const EdicaoComputadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edição de Computadores')),
      body: const Center(child: Text('Tela de edição de computadores')),
    );
  }
}