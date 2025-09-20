import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class ListagemScreen extends StatelessWidget {
  const ListagemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Listagem de Equipamentos'),
      body: Center(
        child: Text('Tela de Listagem de Equipamentos'),
      ),
    );
  }
}
