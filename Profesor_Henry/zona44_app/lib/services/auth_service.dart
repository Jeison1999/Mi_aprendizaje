import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  /// Iniciar sesión
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['token']);
        return data;
      } else {
        print('❌ Error al iniciar sesión: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción en login: $e');
      return null;
    }
  }

  /// Registrar un nuevo usuario
  Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'name': name,
            'email': email,
            'password': password,
            'role': 'cliente', // Siempre registramos clientes desde aquí
          }
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'token', value: data['token']);
        return data;
      } else {
        print('❌ Error al registrar: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Excepción en register: $e');
      return null;
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  /// Obtener token almacenado
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
