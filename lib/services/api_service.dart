// Servicio API para Eco'clock Network
//
// Maneja autenticación con access + refresh token (flutter_secure_storage),
// auto-refresh transparente en 401 y reintento de peticiones.

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

/// Excepción personalizada para errores de la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
}

/// Cliente API principal con persistencia segura de tokens
class EcoClockApi {
  // ──────────────────────────────────────────────────────────────
  // Configuración
  // ──────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://api.ecoclock.org';

  static const String _accessTokenKey = 'ecoclock_access_token';
  static const String _refreshTokenKey = 'ecoclock_refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;

  // Evitar múltiples refreshes concurrentes
  Future<bool>? _refreshing;

  // ──────────────────────────────────────────────────────────────
  // Gestión de tokens (almacenamiento seguro)
  // ──────────────────────────────────────────────────────────────

  Future<void> _loadTokens() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);
  }

  Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _accessToken = null;
    _refreshToken = null;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // ──────────────────────────────────────────────────────────────
  // Helpers HTTP + auto-refresh
  // ──────────────────────────────────────────────────────────────

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
    } catch (_) {}

    throw ApiException(errorMessage, statusCode: response.statusCode);
  }

  /// Intenta renovar los tokens. Devuelve true si tuvo éxito.
  Future<bool> _tryRefresh() async {
    // Si ya hay un refresh en curso, esperamos el mismo
    if (_refreshing != null) {
      return _refreshing!;
    }

    _refreshing = () async {
      try {
        await _loadTokens();
        if (_refreshToken == null) return false;

        final response = await http.post(
          Uri.parse('$baseUrl/auth/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh_token': _refreshToken}),
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          await _saveTokens(
            accessToken: data['access_token'] as String,
            refreshToken: data['refresh_token'] as String,
          );
          return true;
        }
        // Refresh falló → limpiamos
        await _clearTokens();
        return false;
      } catch (_) {
        await _clearTokens();
        return false;
      } finally {
        _refreshing = null;
      }
    }();

    return _refreshing!;
  }

  /// Realiza una petición autenticada con reintento automático en 401
  Future<http.Response> _authenticatedRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    await _loadTokens();

    var response = await requestFn();

    if (response.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        // Reintentamos la petición original con el nuevo token
        response = await requestFn();
      }
    }

    return response;
  }

  // ──────────────────────────────────────────────────────────────
  // Autenticación
  // ──────────────────────────────────────────────────────────────

  Future<UserResponse> register({
    required String email,
    required String username,
    required String password,
    bool keepSession = true,
  }) async {
    final regResponse = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    _handleResponse(regResponse);

    return login(
      username: username,
      password: password,
      keepSession: keepSession,
    );
  }

  Future<UserResponse> login({
    required String username,
    required String password,
    bool keepSession = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    final data = _handleResponse(response) as Map<String, dynamic>;

    final accessToken = data['access_token'] as String;
    final refreshToken = data['refresh_token'] as String;

    if (keepSession) {
      await _saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    } else {
      _accessToken = accessToken;
      _refreshToken = refreshToken;
    }

    return getMe();
  }

  Future<void> logout() async {
    await _loadTokens();
    if (_refreshToken != null && _accessToken != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: _headers,
          body: jsonEncode({'refresh_token': _refreshToken}),
        );
      } catch (_) {
        // Ignoramos errores de red en logout
      }
    }
    await _clearTokens();
  }

  Future<String> forgotPassword({required String emailOrUsername}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': emailOrUsername}),
    );
    final data = _handleResponse(response);
    if (data is Map && data['detail'] != null) {
      return data['detail'] as String;
    }
    return 'Si la cuenta existe, recibirás un correo con instrucciones.';
  }

  Future<String> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'new_password': newPassword,
      }),
    );
    final data = _handleResponse(response);
    if (data is Map && data['detail'] != null) {
      return data['detail'] as String;
    }
    return 'Contraseña actualizada. Ya puedes iniciar sesión.';
  }

  // ──────────────────────────────────────────────────────────────
  // Usuario autenticado
  // ──────────────────────────────────────────────────────────────

  Future<UserResponse> getMe() async {
    final response = await _authenticatedRequest(
      () => http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: _headers,
      ),
    );
    final data = _handleResponse(response);
    return UserResponse.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────────────────────────
  // Tareas
  // ──────────────────────────────────────────────────────────────

  Future<TaskNextResponse> getNextTask() async {
    final response = await _authenticatedRequest(
      () => http.get(
        Uri.parse('$baseUrl/tasks/next'),
        headers: _headers,
      ),
    );
    final data = _handleResponse(response);
    return TaskNextResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<void> submitTask({
    required int taskId,
    required Map<String, dynamic> output,
    double? computeTimeSec,
    String client = 'flutter_mobile',
    String clientMode = 'manual',
  }) async {
    final body = <String, dynamic>{
      'task_id': taskId,
      'output': output,
      'client': client,
      'client_mode': clientMode,
    };
    if (computeTimeSec != null) {
      body['compute_time_sec'] = computeTimeSec;
    }

    final response = await _authenticatedRequest(
      () => http.post(
        Uri.parse('$baseUrl/tasks/submit'),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
    _handleResponse(response);
  }

  // ──────────────────────────────────────────────────────────────
  // Créditos
  // ──────────────────────────────────────────────────────────────

  Future<CreditsSummary> getCredits() async {
    final response = await _authenticatedRequest(
      () => http.get(
        Uri.parse('$baseUrl/me/credits'),
        headers: _headers,
      ),
    );
    final data = _handleResponse(response);
    return CreditsSummary.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────────────────────────
  // Utilidades
  // ──────────────────────────────────────────────────────────────

  Future<bool> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasToken() async {
    await _loadTokens();
    return _accessToken != null || _refreshToken != null;
  }

  // ──────────────────────────────────────────────────────────────
  // Nodos Ciudadanos
  // ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> createNode(String name) async {
    final response = await _authenticatedRequest(
      () => http.post(
        Uri.parse('$baseUrl/nodes'),
        headers: _headers,
        body: jsonEncode({'name': name}),
      ),
    );
    return _handleResponse(response) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getMyNode() async {
    final response = await _authenticatedRequest(
      () => http.get(
        Uri.parse('$baseUrl/nodes/me'),
        headers: _headers,
      ),
    );
    if (response.statusCode == 404) return null;
    return _handleResponse(response) as Map<String, dynamic>;
  }

  Future<List<dynamic>> listPublicNodes() async {
    final response = await _authenticatedRequest(
      () => http.get(
        Uri.parse('$baseUrl/nodes'),
        headers: _headers,
      ),
    );
    return _handleResponse(response) as List<dynamic>;
  }

  Future<Map<String, dynamic>> joinNodeByCode(String code) async {
    final response = await _authenticatedRequest(
      () => http.post(
        Uri.parse('$baseUrl/nodes/join/$code'),
        headers: _headers,
      ),
    );
    return _handleResponse(response) as Map<String, dynamic>;
  }

  Future<void> leaveNode() async {
    final response = await _authenticatedRequest(
      () => http.post(
        Uri.parse('$baseUrl/nodes/leave'),
        headers: _headers,
      ),
    );
    _handleResponse(response);
  }

  Future<void> requestJoinNode(int nodeId) async {
    final response = await _authenticatedRequest(
      () => http.post(
        Uri.parse('$baseUrl/nodes/$nodeId/request'),
        headers: _headers,
      ),
    );
    _handleResponse(response);
  }

  Future<void> deleteNode(int nodeId) async {
    final response = await _authenticatedRequest(
      () => http.delete(
        Uri.parse('$baseUrl/nodes/$nodeId'),
        headers: _headers,
      ),
    );
    _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadNodeLogo(int nodeId, String filePath) async {
    await _loadTokens();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/nodes/$nodeId/logo'),
    );
    request.headers['Authorization'] = 'Bearer $_accessToken';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> renameNode(int nodeId, String name) async {
    final response = await _authenticatedRequest(
      () => http.patch(
        Uri.parse('$baseUrl/nodes/$nodeId'),
        headers: _headers,
        body: jsonEncode({'name': name}),
      ),
    );
    return _handleResponse(response) as Map<String, dynamic>;
  }


  Future<Map<String, dynamic>?> getCurrentExpedition() async {
    final response = await _authenticatedRequest(
      () => http.get(
        Uri.parse('$baseUrl/expeditions/current'),
        headers: _headers,
      ),
    );
    if (response.statusCode == 204 || response.body.isEmpty || response.body == 'null') {
      return null;
    }
    if (response.statusCode == 404) return null;
    final data = _handleResponse(response);
    if (data == null) return null;
    return data as Map<String, dynamic>;
  }

}
