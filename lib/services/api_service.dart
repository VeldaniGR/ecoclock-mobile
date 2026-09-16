// Servicio API para Eco'clock Network
//
// Maneja autenticación (JWT en SharedPreferences), peticiones HTTP y parsing de respuestas.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';

/// Excepción personalizada para errores de la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
}

/// Cliente API principal con persistencia de token JWT
class EcoClockApi {
  // ──────────────────────────────────────────────────────────────
  // Configuración
  // ──────────────────────────────────────────────────────────────
  /// URL base de la API (ngrok tunnel a localhost:8000)
  /// Generado con: ngrok http 8000
  static const String baseUrl = 'https://barometer-ceramics-shore.ngrok-free.dev';

  /// Clave de SharedPreferences para el token JWT
  static const String _tokenKey = 'ecoclock_jwt';

  String? _token;

  // ──────────────────────────────────────────────────────────────
  // Gestión de token (persistencia local)
  // ──────────────────────────────────────────────────────────────

  /// Carga el token guardado en SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  /// Guarda el token en SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _token = token;
  }

  /// Elimina el token (logout)
  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _token = null;
  }

  /// Headers HTTP comunes (incluye Authorization si hay token)
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  // ──────────────────────────────────────────────────────────────
  // Helpers HTTP
  // ──────────────────────────────────────────────────────────────

  /// Procesa respuesta HTTP y lanza ApiException en caso de error
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    String errorMessage = 'Error HTTP ${response.statusCode}';
    try {
      final errorJson = jsonDecode(response.body);
      if (errorJson is Map && errorJson.containsKey('detail')) {
        errorMessage = errorJson['detail'].toString();
      }
    } catch (_) {
      // Usar mensaje por defecto
    }

    // Auto-logout en 401
    if (response.statusCode == 401) {
      _clearToken();
    }

    throw ApiException(errorMessage, statusCode: response.statusCode);
  }

  // ──────────────────────────────────────────────────────────────
  // Autenticación
  // ──────────────────────────────────────────────────────────────

  /// Registra un nuevo usuario
  /// POST /auth/register
  Future<UserResponse> register({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = _handleResponse(response);
    await _saveToken(data['access_token'] as String);
    return UserResponse.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Inicia sesión
  /// POST /auth/login
  Future<UserResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = _handleResponse(response);
    await _saveToken(data['access_token'] as String);
    return UserResponse.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// Cierra sesión (elimina token local)
  Future<void> logout() async => _clearToken();

  // ──────────────────────────────────────────────────────────────
  // Usuario autenticado
  // ──────────────────────────────────────────────────────────────

  /// Obtiene datos del usuario autenticado
  /// GET /me
  Future<UserResponse> getMe() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────────────────────────
  // Tareas
  // ──────────────────────────────────────────────────────────────

  /// Solicita la siguiente tarea disponible
  /// GET /tasks/next
  Future<TaskNextResponse> getNextTask() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/next'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return TaskNextResponse.fromJson(data as Map<String, dynamic>);
  }

  /// Envía el resultado de una tarea completada
  /// POST /tasks/submit
  Future<void> submitTask({
    required int taskId,
    required Map<String, dynamic> output,
  }) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/submit'),
      headers: _headers,
      body: jsonEncode({'task_id': taskId, 'output': output}),
    );
    _handleResponse(response);
  }

  // ──────────────────────────────────────────────────────────────
  // Créditos
  // ──────────────────────────────────────────────────────────────

  /// Obtiene el resumen de créditos del usuario
  /// GET /credits/me
  Future<CreditsSummary> getCredits() async {
    await _loadToken();
    final response = await http.get(
      Uri.parse('$baseUrl/credits/me'),
      headers: _headers,
    );
    final data = _handleResponse(response);
    return CreditsSummary.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────────────────────────
  // Health check (sin autenticación)
  // ──────────────────────────────────────────────────────────────

  /// Verifica si la API está disponible
  Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Indica si hay un token guardado (sesión iniciada)
  Future<bool> hasToken() async {
    await _loadToken();
    return _token != null;
  }
}