import '../models/usuario.dart';
import 'api_service.dart';

class UsuarioService {
  // Listar todos os usuários
  static Future<List<Usuario>> listarUsuarios() async {
    try {
      final response = await ApiService.get('/usuarios');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao listar usuários');
      }
    } catch (e) {
      throw ApiException('Erro ao listar usuários: $e');
    }
  }

  // Obter usuário por ID
  static Future<Usuario> obterUsuario(String id) async {
    try {
      final response = await ApiService.get('/usuarios/$id');
      
      if (response['success'] == true) {
        return Usuario.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Usuário não encontrado');
      }
    } catch (e) {
      throw ApiException('Erro ao obter usuário: $e');
    }
  }

  // Criar novo usuário
  static Future<Usuario> criarUsuario(Usuario usuario) async {
    try {
      final response = await ApiService.post('/usuarios', usuario.toJsonForCreation());
      
      if (response['success'] == true) {
        return Usuario.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao criar usuário');
      }
    } catch (e) {
      throw ApiException('Erro ao criar usuário: $e');
    }
  }

  // Atualizar usuário
  static Future<Usuario> atualizarUsuario(String id, Usuario usuario) async {
    try {
      final response = await ApiService.put('/usuarios/$id', usuario.toJsonForCreation());
      
      if (response['success'] == true) {
        return Usuario.fromJson(response['data']);
      } else {
        throw ApiException(response['error'] ?? 'Erro ao atualizar usuário');
      }
    } catch (e) {
      throw ApiException('Erro ao atualizar usuário: $e');
    }
  }

  // Deletar usuário
  static Future<void> deletarUsuario(String id) async {
    try {
      final response = await ApiService.delete('/usuarios/$id');
      
      if (response['success'] != true) {
        throw ApiException(response['error'] ?? 'Erro ao deletar usuário');
      }
    } catch (e) {
      throw ApiException('Erro ao deletar usuário: $e');
    }
  }

  // Buscar usuários por nome
  static Future<List<Usuario>> buscarUsuarios(String termo) async {
    try {
      final response = await ApiService.get('/usuarios/buscar?q=${Uri.encodeComponent(termo)}');
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        throw ApiException(response['error'] ?? 'Erro ao buscar usuários');
      }
    } catch (e) {
      throw ApiException('Erro ao buscar usuários: $e');
    }
  }
}

