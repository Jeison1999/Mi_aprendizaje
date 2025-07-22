import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zona44_app/config/api_config.dart';
import 'package:zona44_app/models/group.dart';
import 'package:zona44_app/models/product.dart';

class ApiService {
  final storage = FlutterSecureStorage();
  String get apiBaseUrl => ApiConfig.baseUrl;

  Future<List<Group>> fetchGroups() async {
    final token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$apiBaseUrl/groups'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((json) => Group.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar grupos');
    }
  }

  Future<List<Product>> getProductsByGroup(String groupId) async {
    try {
      final token = await storage.read(key: 'token');

      final response = await http.get(
        Uri.parse('$apiBaseUrl/products?group_id=$groupId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<bool> createGroup(String name) async {
    final token = await storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/admin/groups'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    return response.statusCode == 201;
  }

  Future<bool> updateGroup(int id, String name) async {
    final token = await storage.read(key: 'token');

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/admin/groups/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteGroup(int id) async {
    final token = await storage.read(key: 'token');

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/admin/groups/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
