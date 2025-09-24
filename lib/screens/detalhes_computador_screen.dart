import 'package:flutter/material.dart';

class DetalhesComputadoresScreen extends StatelessWidget {
  const DetalhesComputadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listagem de Computadores')),
      body: const Center(child: Text('Tela de listagem de computadores')),
    );
  }
}