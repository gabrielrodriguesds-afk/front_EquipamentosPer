import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/cliente_service.dart';
import 'models/cliente.dart';

class TestApiScreen extends StatefulWidget {
  const TestApiScreen({super.key});

  @override
  _TestApiScreenState createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  String _resultado = 'Aguardando teste...';
  bool _carregando = false;

  Future<void> _testarConexaoAPI() async {
    setState(() {
      _carregando = true;
      _resultado = 'Testando conexão com API...';
    });

    try {
      // Testar status da API
      final status = await ApiService.checkApiStatus();
      if (status) {
        setState(() {
          _resultado = '✅ API Flask está funcionando!\n';
        });
        
        // Testar listagem de clientes
        await _testarClientes();
      } else {
        setState(() {
          _resultado = '❌ API Flask não está respondendo.\n\nVerifique se o servidor Flask está rodando:\ncd pr_equipamentos_api\nsource venv/bin/activate\npython src/main.py';
        });
      }
    } catch (e) {
      setState(() {
        _resultado = '❌ Erro ao conectar com API:\n$e\n\nVerifique se o servidor Flask está rodando na porta 5000.';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<void> _testarClientes() async {
    try {
      // Listar clientes existentes
      final clientes = await ClienteService.listarClientes();
      setState(() {
        _resultado += '\n📋 Clientes encontrados: ${clientes.length}';
      });

      // Criar um cliente de teste
      final clienteTeste = Cliente.novo(
        nome: 'Cliente Teste Flutter',
        email: 'teste@flutter.com',
        telefone: '(11) 99999-9999',
        endereco: 'Rua Teste, 123',
      );

      final clienteCriado = await ClienteService.criarCliente(clienteTeste);
      setState(() {
        _resultado += '\n✅ Cliente criado: ${clienteCriado.nome} (ID: ${clienteCriado.id})';
      });

      // Listar novamente para confirmar
      final clientesAtualizados = await ClienteService.listarClientes();
      setState(() {
        _resultado += '\n📋 Total de clientes após criação: ${clientesAtualizados.length}';
        _resultado += '\n\n🎉 Integração Flutter ↔ Flask funcionando perfeitamente!';
      });

    } catch (e) {
      setState(() {
        _resultado += '\n❌ Erro ao testar clientes: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Integração API'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Teste de Integração',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este teste verifica se o Flutter consegue se comunicar com a API Flask.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregando ? null : _testarConexaoAPI,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _carregando
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Testando...'),
                      ],
                    )
                  : const Text(
                      'Testar Conexão com API',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resultado:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _resultado,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

