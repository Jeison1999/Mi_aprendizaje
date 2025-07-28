import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:zona44_app/config/api_config.dart';
import 'package:zona44_app/models/group.dart';
import 'package:zona44_app/models/product.dart';
import 'package:zona44_app/models/pizza_base.dart';

class ApiService {
  final String baseUrl =
      'http://localhost:3000/api/v1'; // Cambia esto por tu URL real

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

  Future<bool> createGroupWithImageWeb(
    String name,
    Uint8List imageBytes,
    String imageName,
  ) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/groups');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
      );

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

  Future<bool> updateGroupWithImageWeb(
    int id,
    String name,
    Uint8List imageBytes,
    String imageName,
  ) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/groups/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
      );

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> updateGroupWithImage(int id, String name, File imageFile) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/groups/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
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

  Future<List<Product>> getProductsByGroup(int groupId) async {
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

  // ─────────── PIZZAS ───────────

  Future<List<PizzaBase>> fetchPizzaBases() async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/v1/admin/pizza_bases'),
      headers: await _authHeaders(),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => PizzaBase.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener pizzas');
    }
  }

  Future<List<PizzaBase>> fetchPizzaBasesByGroup(int groupId) async {
    final response = await http.get(
      Uri.parse('$apiBaseUrl/admin/pizza_bases?group_id=$groupId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => PizzaBase.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener pizzas por grupo');
    }
  }

  Future<bool> createPizzaWeb({
    required String name,
    required String description,
    required String category,
    required List<int> imageBytes,
    required String imageName,
    required int cheeseBorderPrice,
    required bool hasCheeseBorder,
    required List<Map<String, Object>> pizza_variants_attributes,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final url = Uri.parse('$apiBaseUrl/admin/pizza_bases');
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'category': category,
      'image': base64Encode(imageBytes),
      'image_name': imageName,
      'cheese_border_price': cheeseBorderPrice,
      'has_cheese_border': hasCheeseBorder,
      'pizza_variants_attributes': pizza_variants_attributes
          .map((s) => {'size': s['size'], 'price': s['price']})
          .toList(),
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> createPizzaWebMultipart({
    required String name,
    required String description,
    required String category,
    required Uint8List imageBytes,
    required String imageName,
    required int cheeseBorderPrice,
    required bool hasCheeseBorder,
    required List<Map<String, Object>> pizza_variants_attributes,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/pizza_bases');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['category'] = category
      ..fields['cheese_border_price'] = cheeseBorderPrice.toString()
      ..fields['has_cheese_border'] = hasCheeseBorder.toString();

    // Agregar variantes de pizza como campos anidados
    for (int i = 0; i < pizza_variants_attributes.length; i++) {
      final variant = pizza_variants_attributes[i];
      request.fields['pizza_variants_attributes[$i][size]'] = variant['size']
          .toString();
      request.fields['pizza_variants_attributes[$i][price]'] = variant['price']
          .toString();
    }

    request.files.add(
      http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
    );

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> updatePizzaWeb({
    required int id,
    required String name,
    required String description,
    required String category,
    List<int>? imageBytes,
    String? imageName,
    required int cheeseBorderPrice,
    required bool hasCheeseBorder,
    required List<Map<String, Object>> pizza_variants_attributes,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final url = Uri.parse('$apiBaseUrl/admin/pizza_bases/$id');
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'category': category,
      'cheese_border_price': cheeseBorderPrice,
      'has_cheese_border': hasCheeseBorder,
      'pizza_variants_attributes': pizza_variants_attributes
          .map((s) => {'size': s['size'], 'price': s['price']})
          .toList(),
    };

    if (imageBytes != null && imageName != null) {
      data['image'] = base64Encode(imageBytes);
      data['image_name'] = imageName;
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  Future<bool> createPizzaMobile({
    required String name,
    required String description,
    required String category,
    required File imageFile,
    required int cheeseBorderPrice,
    required bool hasCheeseBorder,
    required List<Map<String, Object>> sizes,
  }) async {
    final url = Uri.parse('$apiBaseUrl/admin/pizza_bases');
    final request = http.MultipartRequest('POST', url)
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['category'] = category
      ..fields['cheeseBorderPrice'] = cheeseBorderPrice.toString()
      ..fields['hasCheeseBorder'] = hasCheeseBorder.toString()
      ..fields['sizes'] = jsonEncode(sizes)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> updatePizza({
    required int id,
    required String name,
    required String description,
    required String category,
    File? imageFile,
    required int cheeseBorderPrice,
    required bool hasCheeseBorder,
    required List<Map<String, Object>> sizes,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');

    final uri = Uri.parse('$apiBaseUrl/admin/pizza_bases/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer \$token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['category'] = category
      ..fields['cheeseBorderPrice'] = cheeseBorderPrice.toString()
      ..fields['hasCheeseBorder'] = hasCheeseBorder.toString()
      ..fields['sizes'] = jsonEncode(sizes);

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> deletePizza(int id) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    final response = await http.delete(
      Uri.parse('$apiBaseUrl/admin/pizza_bases/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<bool> updateProductWeb({
    required int id,
    required String name,
    required String description,
    required int price,
    Uint8List? imageBytes,
    String? imageName,
    required int groupId,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    final uri = Uri.parse('$apiBaseUrl/admin/products/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString()
      ..fields['group_id'] = groupId.toString();
    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
      );
    }
    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> updateProductMobile({
    required int id,
    required String name,
    required String description,
    required int price,
    File? imageFile,
    required int groupId,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    final uri = Uri.parse('$apiBaseUrl/admin/products/$id');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['price'] = price.toString()
      ..fields['group_id'] = groupId.toString();
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }
    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 200;
  }

  Future<bool> updateProduct(
    int id,
    String name,
    String description,
    double price,
    int groupId,
  ) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    final response = await http.put(
      Uri.parse('$apiBaseUrl/admin/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'group_id': groupId,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> createProductWeb(
    String name,
    String desc,
    double price,
    int groupId,
    Uint8List imageBytes,
    String imageName,
  ) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    final uri = Uri.parse('$apiBaseUrl/admin/products');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = desc
      ..fields['price'] = price.toString()
      ..fields['group_id'] = groupId.toString()
      ..files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
      );
    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201;
  }

  Future<bool> createProductWithImage(
    String name,
    String desc,
    double price,
    int groupId,
    File imageFile,
  ) async {
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception('No hay token');
    final uri = Uri.parse('$apiBaseUrl/admin/products');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['description'] = desc
      ..fields['price'] = price.toString()
      ..fields['group_id'] = groupId.toString()
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    final response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201;
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
