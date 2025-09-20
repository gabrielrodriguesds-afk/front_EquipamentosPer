import '../models/nobreak.dart';
import 'api_service.dart';

class NobreakService {
  // Listar todos os nobreaks
  static Future<List<Nobreak>> listarNobreaks() async {
    try {
      final response = await ApiService.get('/nobreaks');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Nobreak.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao listar nobreaks');
      }
    } catch (e) {
      throw ApiException('Erro ao listar nobreaks: $e');
    }
  }

  // Obter nobreak por ID
  static Future<Nobreak> obterNobreak(String id) async {
    try {
      final response = await ApiService.get('/nobreaks/$id');
      
      if (response['success'] == true) {
        return Nobreak.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Nobreak não encontrado');
      }
    } catch (e) {
      throw ApiException('Erro ao obter nobreak: $e');
    }
  }

  // Criar novo nobreak (código será gerado automaticamente)
  static Future<Nobreak> criarNobreak(Nobreak nobreak) async {
    try {
      final response = await ApiService.post('/nobreaks', nobreak.toJsonForCreation());
      
      if (response['success'] == true) {
        return Nobreak.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao criar nobreak');
      }
    } catch (e) {
      throw ApiException('Erro ao criar nobreak: $e');
    }
  }

  // Atualizar nobreak
  static Future<Nobreak> atualizarNobreak(String id, Nobreak nobreak) async {
    try {
      final response = await ApiService.put('/nobreaks/$id', nobreak.toJsonForCreation());
      
      if (response['success'] == true) {
        return Nobreak.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao atualizar nobreak');
      }
    } catch (e) {
      throw ApiException('Erro ao atualizar nobreak: $e');
    }
  }

  // Deletar nobreak
  static Future<void> deletarNobreak(String id) async {
    try {
      final response = await ApiService.delete('/nobreaks/$id');
      
      if (response['success'] != true) {
        throw ApiException(response['error'] ?? 'Erro ao deletar nobreak');
      }
    } catch (e) {
      throw ApiException('Erro ao deletar nobreak: $e');
    }
  }

  // Buscar nobreaks por código, marca, modelo ou cliente
  static Future<List<Nobreak>> buscarNobreaks(String termo) async {
    try {
      final response = await ApiService.get('/nobreaks/buscar?q=${Uri.encodeComponent(termo)}');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Nobreak.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao buscar nobreaks');
      }
    } catch (e) {
      throw ApiException('Erro ao buscar nobreaks: $e');
    }
  }

  // Listar nobreaks de um cliente específico
  static Future<List<Nobreak>> listarNobreaksCliente(String clienteId) async {
    try {
      final response = await ApiService.get('/nobreaks/cliente/$clienteId');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Nobreak.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao listar nobreaks do cliente');
      }
    } catch (e) {
      throw ApiException('Erro ao listar nobreaks do cliente: $e');
    }
  }
}

