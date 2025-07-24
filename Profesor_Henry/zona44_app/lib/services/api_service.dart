import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zona44_app/config/api_config.dart';
import 'package:zona44_app/models/group.dart';
import 'package:zona44_app/models/product.dart';

class ApiService {
  final storage = FlutterSecureStorage();
  String get apiBaseUrl => ApiConfig.baseUrl;

  // ─────────── GRUPOS ───────────

  Future<List<Group>> fetchGroups() async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token de autenticación');

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

  Future<bool> createGroupWithImageWeb(String name, Uint8List imageBytes, String imageName) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/groups');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageName));

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201;
  }

  Future<bool> createGroupWithImage(String name, File imageFile) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/groups');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    return response.statusCode == 201;
  }

  Future<bool> updateGroup(int id, String name) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final response = await http.put(
      Uri.parse('$apiBaseUrl/admin/groups/$id'),
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
    if (token == null) throw Exception('No hay token');

    final response = await http.delete(
      Uri.parse('$apiBaseUrl/admin/groups/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  // ─────────── PRODUCTOS ───────────

  Future<List<Product>> getProductsByGroup(String groupId) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

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
      throw Exception('Error al cargar productos');
    }
  }

  Future<bool> createProductWeb(String name, String description, int price, int groupId, Uint8List imageBytes, String imageName) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/products');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString()
      ..fields['group_id'] = groupId.toString()
      ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageName));

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201;
  }

  Future<bool> createProductMobile(String name, String description, int price, int groupId, File imageFile) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/products');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString()
      ..fields['group_id'] = groupId.toString()
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201;
  }

  Future<bool> updateProductMobile({
    required int id,
    required String name,
    required String description,
    required int price,
    File? imageFile,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/products/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString();

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> updateProductWeb({
    required int id,
    required String name,
    required String description,
    required int price,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/products/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString();

    if (imageBytes != null && imageName != null) {
      request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageName));
    }

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> deleteProduct(int id) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final response = await http.delete(
      Uri.parse('$apiBaseUrl/admin/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
