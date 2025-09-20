import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base da API Flask
  static const String baseUrl = 'http://192.168.254.3:5000/api';
  
  // Headers padrão
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Método GET genérico
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(url, headers: headers);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro de conexão: $e');
    }
  }

  // Método POST genérico
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro de conexão: $e');
    }
  }

  // Método PUT genérico
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(data),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro de conexão: $e');
    }
  }

  // Método DELETE genérico
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(url, headers: headers);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro de conexão: $e');
    }
  }

  // Método para upload de arquivo
  static Future<Map<String, dynamic>> uploadFile(String endpoint, File file, {Map<String, String>? fields}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', url);
      
      // Adicionar campos extras se fornecidos
      if (fields != null) {
        request.fields.addAll(fields);
      }
      
      // Adicionar arquivo
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro no upload: $e');
    }
  }

  // Processar resposta da API
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> data = json.decode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      final errorMessage = data['error'] ?? 'Erro desconhecido';
      throw ApiException(errorMessage, statusCode: response.statusCode);
    }
  }

  // Verificar se a API está funcionando
  static Future<bool> checkApiStatus() async {
    try {
      final response = await get('/status');
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}

// Exceção personalizada para erros da API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException ($statusCode): $message';
    }
    return 'ApiException: $message';
  }
}

