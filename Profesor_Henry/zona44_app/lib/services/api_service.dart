import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as storage;
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zona44_app/config/api_config.dart';
import 'package:zona44_app/models/group.dart';
import 'package:zona44_app/models/product.dart';

class ApiService {
  // Soporte para web: subir grupo con imagen usando bytes
  Future<bool> createGroupWithImageWeb(
    String name,
    Uint8List imageBytes,
    String imageName,
  ) async {
    final token = await storage.read(key: 'token');
    print('Token: $token');
    print('Nombre: $name');
    print('ImageName: $imageName');
    if (token == null) throw Exception('No hay token de autenticación');
    if (name.isEmpty)
      throw Exception('El nombre del grupo no puede estar vacío');
    if (imageName.isEmpty)
      throw Exception('El nombre de la imagen no puede estar vacío');
    if (imageBytes.isEmpty) throw Exception('La imagen no puede estar vacía');
    final uri = Uri.parse('$apiBaseUrl/admin/groups');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response.statusCode == 201;
  }

  final storage = FlutterSecureStorage();
  String get apiBaseUrl => ApiConfig.baseUrl;

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

  Future<List<Product>> getProductsByGroup(String groupId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('No hay token de autenticación');
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
    if (token == null) throw Exception('No hay token de autenticación');
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
    if (token == null) throw Exception('No hay token de autenticación');
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
    if (token == null) throw Exception('No hay token de autenticación');
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/admin/groups/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> uploadGroupWithImage(String name, File imageFile) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token de autenticación');
    if (name.isEmpty)
      throw Exception('El nombre del grupo no puede estar vacío');
    if (imageFile.path.isEmpty)
      throw Exception('La imagen no puede estar vacía');
    final uri = Uri.parse('$apiBaseUrl/admin/groups');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    return response.statusCode == 201;
  }

  Future<bool> createGroupWithImage(String name, File imageFile) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token de autenticación');
    if (name.isEmpty)
      throw Exception('El nombre del grupo no puede estar vacío');
    if (imageFile.path.isEmpty)
      throw Exception('La imagen no puede estar vacía');
    var uri = Uri.parse('$apiBaseUrl/admin/groups');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    var response = await request.send();
    return response.statusCode == 201;
  }
}

Future<bool> createProductWeb(
  String name,
  String description,
  int price,
  int groupId,
  Uint8List imageBytes,
  String imageName,
) async {
  final token = await storage.read(key: 'token');
  if (token == null) throw Exception('No hay token de autenticación');

  final uri = Uri.parse('$apiBaseUrl/admin/products');
  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..fields['name'] = name
    ..fields['description'] = description
    ..fields['price'] = price.toString()
    ..fields['group_id'] = groupId.toString()
    ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: imageName));

  final response = await http.Response.fromStream(await request.send());

  print('WEB Producto Status: ${response.statusCode}');
  print('Body: ${response.body}');

  return response.statusCode == 201;
}

Future<bool> createProductMobile(
  String name,
  String description,
  int price,
  int groupId,
  File imageFile,
) async {
  final token = await storage.read(key: 'token');
  if (token == null) throw Exception('No hay token de autenticación');

  final uri = Uri.parse('$apiBaseUrl/admin/products');
  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..fields['name'] = name
    ..fields['description'] = description
    ..fields['price'] = price.toString()
    ..fields['group_id'] = groupId.toString()
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  final response = await http.Response.fromStream(await request.send());

  print('MOBILE Producto Status: ${response.statusCode}');
  print('Body: ${response.body}');

  return response.statusCode == 201;
}


