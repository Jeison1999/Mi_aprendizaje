import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Map<String, dynamic>? _user;
  String? _token;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  // ✔️ Nuevo: Determina si el usuario es administrador
  bool get isAdmin => _user?['role'] == 'admin';

  Future<bool> login(String email, String password) async {
    final response = await _authService.login(email, password);
    if (response != null) {
      _user = response['user'];
      _token = response['token'];
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await _authService.register(name, email, password);
    if (response != null) {
      _user = response['user'];
      _token = response['token'];
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.logout(); // Limpia el token del storage si se usa
    _user = null;
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
