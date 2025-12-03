import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Supondo que use http
import '../utils/app_theme.dart';
import 'edicao_nobreak_screen.dart'; // Import da tela de edição

class DetalhesNobreakScreen extends StatefulWidget {
  final Map<String, dynamic> nobreak;

  const DetalhesNobreakScreen({Key? key, required this.nobreak}) : super(key: key);

  @override
  State<DetalhesNobreakScreen> createState() => _DetalhesNobreakScreenState();
}

class _DetalhesNobreakScreenState extends State<DetalhesNobreakScreen> {
  // Variável local para atualizar a tela quando voltar da edição
  late Map<String, dynamic> dadosNobreak;

  @override
  void initState() {
    super.initState();
    dadosNobreak = widget.nobreak;
  }

  // Função para deletar
  Future<void> _deletarNobreak() async {
    // Adicione aqui sua URL de API correta
    final url = Uri.parse('http://SEU_IP:3000/nobreaks/${dadosNobreak['id']}');
    
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 204) {
        Navigator.pop(context, true); // Retorna true para atualizar a lista anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Erro ao deletar nobreak')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // Diálogo de confirmação para deletar
  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Nobreak?'),
        content: const Text('Tem certeza que deseja remover este equipamento?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deletarNobreak();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${dadosNobreak['marca']} ${dadosNobreak['modelo']}'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmarExclusao,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile('ID do Cliente', dadosNobreak['cliente_id']?.toString() ?? 'N/A'),
            _buildInfoTile('Marca', dadosNobreak['marca']),
            _buildInfoTile('Modelo', dadosNobreak['modelo']),
            _buildInfoTile('Nº de Série', dadosNobreak['numero_serie']),
            const Divider(),
            _buildInfoTile('Modelo Bateria', dadosNobreak['modelo_bateria']),
            _buildInfoTile('Qtd. Baterias', dadosNobreak['quantidade_baterias']?.toString() ?? '0'),
            _buildInfoTile('Data Troca Bateria', dadosNobreak['data_troca_bateria'] ?? 'Não informada'),
            const Divider(),
            _buildInfoTile('Setor', dadosNobreak['setor']),
            _buildInfoTile('Observação', dadosNobreak['observacao'], isLongText: true),
          ],
        ),
      ),
      // O LÁPIS PARA EDITAR
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.darkGreen,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          // Vai para a tela de edição e espera o resultado (os dados atualizados)
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EdicaoNobreakScreen(nobreak: dadosNobreak),
            ),
          );

          // Se voltou com dados atualizados, atualiza a tela
          if (resultado != null) {
            setState(() {
              dadosNobreak = resultado;
            });
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value, {bool isLongText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value ?? '-',
            style: const TextStyle(fontSize: 16),
            maxLines: isLongText ? 10 : 1,
            overflow: isLongText ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}