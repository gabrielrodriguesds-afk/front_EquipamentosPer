import '../models/cliente.dart';
import 'api_service.dart';

class ClienteService {
  // Listar todos os clientes
  static Future<List<Cliente>> listarClientes() async {
    try {
      final response = await ApiService.get('/clientes');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Cliente.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao listar clientes');
      }
    } catch (e) {
      throw ApiException('Erro ao listar clientes: $e');
    }
  }

  // Obter cliente por ID
  static Future<Cliente> obterCliente(String id) async {
    try {
      final response = await ApiService.get('/clientes/$id');
      
      if (response['success'] == true) {
        return Cliente.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Cliente não encontrado');
      }
    } catch (e) {
      throw ApiException('Erro ao obter cliente: $e');
    }
  }

  // Criar novo cliente
  static Future<Cliente> criarCliente(Cliente cliente) async {
    try {
      final response = await ApiService.post('/clientes', cliente.toJsonForCreation());
      
      if (response['success'] == true) {
        return Cliente.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao criar cliente');
      }
    } catch (e) {
      throw ApiException('Erro ao criar cliente: $e');
    }
  }

  // Atualizar cliente
  static Future<Cliente> atualizarCliente(String id, Cliente cliente) async {
    try {
      final response = await ApiService.put('/clientes/$id', cliente.toJsonForCreation());
      
      if (response['success'] == true) {
        return Cliente.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao atualizar cliente');
      }
    } catch (e) {
      throw ApiException('Erro ao atualizar cliente: $e');
    }
  }

  // Deletar cliente
  static Future<void> deletarCliente(String id) async {
    try {
      final response = await ApiService.delete('/clientes/$id');
      
      if (response['success'] != true) {
        throw ApiException(response['error'] ?? 'Erro ao deletar cliente');
      }
    } catch (e) {
      throw ApiException('Erro ao deletar cliente: $e');
    }
  }

  // Buscar clientes por nome
  static Future<List<Cliente>> buscarClientes(String termo) async {
    try {
      final response = await ApiService.get('/clientes/buscar?q=${Uri.encodeComponent(termo)}');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Cliente.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao buscar clientes');
      }
    } catch (e) {
      throw ApiException('Erro ao buscar clientes: $e');
    }
  }
}

