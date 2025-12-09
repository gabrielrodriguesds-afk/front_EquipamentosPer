import '../models/computador.dart';
import 'api_service.dart';

class ComputadorService {
  // Listar todos os computadores
  static Future<List<Computador>> listarComputadores() async {
    try {
      final response = await ApiService.get('/computadores');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Computador.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao listar computadores');
      }
    } catch (e) {
      throw ApiException('Erro ao listar computadores: $e');
    }
  }

  // Obter computador por ID
  static Future<Computador> obterComputador(String id) async {
    try {
      final response = await ApiService.get('/computadores/$id');
      
      if (response['success'] == true) {
        return Computador.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Computador não encontrado');
      }
    } catch (e) {
      throw ApiException('Erro ao obter computador: $e');
    }
  }

  // Criar novo computador (código será gerado automaticamente)
  static Future<Computador> criarComputador(Computador computador) async {
    try {
      final response = await ApiService.post('/computadores', computador.toJsonForCreation());
      
      if (response['success'] == true) {
        return Computador.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao criar computador');
      }
    } catch (e) {
      throw ApiException('Erro ao criar computador: $e');
    }
  }

  // Atualizar computador
  static Future<Computador> atualizarComputador(String id, Computador computador) async {
    try {
      final response = await ApiService.put('/computadores/$id', computador.toJsonForCreation());
      
      if (response['success'] == true) {
        return Computador.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao atualizar computador');
      }
    } catch (e) {
      throw ApiException('Erro ao atualizar computador: $e');
    }
  }

  // Deletar computador
  static Future<void> deletarComputador(String id) async {
    try {
      final response = await ApiService.delete('/computadores/$id');
      
      if (response['success'] != true) {
        throw ApiException(response['error'] ?? 'Erro ao deletar computador');
      }
    } catch (e) {
      throw ApiException('Erro ao deletar computador: $e');
    }
  }

  // Buscar computadores por código, marca, modelo ou cliente
  static Future<List<Computador>> buscarComputadores(String termo) async {
    try {
      final response = await ApiService.get('/computadores/buscar?q=${Uri.encodeComponent(termo)}');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Computador.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao buscar computadores');
      }
    } catch (e) {
      throw ApiException('Erro ao buscar computadores: $e');
    }
  }

  // Listar computadores de um cliente específico
  static Future<List<Computador>> listarComputadoresCliente(String clienteId) async {
    try {
      final response = await ApiService.get('/computadores/cliente/$clienteId');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Computador.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao listar computadores do cliente');
      }
    } catch (e) {
      throw ApiException('Erro ao listar computadores do cliente: $e');
    }
  }
}

