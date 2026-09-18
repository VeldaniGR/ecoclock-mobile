// Modelos de datos basados en los schemas Pydantic del servidor (FastAPI)
//
// Generados a partir de:
// - server/app/schemas/user.py
// - server/app/schemas/task.py
// - server/app/schemas/credit.py

/// Respuesta de usuario autenticado (/me, /auth/register, /auth/login)
class UserResponse {
  final int id;
  final String email;
  final String username;

  UserResponse({
    required this.id,
    required this.email,
    required this.username,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json['id'] as int,
        email: json['email'] as String,
        username: json['username'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
      };
}

/// Respuesta de siguiente tarea (/tasks/next)
class TaskNextResponse {
  final int taskId;
  final String taskType;
  final Map<String, dynamic> payload;
  final String status;

  TaskNextResponse({
    required this.taskId,
    required this.taskType,
    required this.payload,
    required this.status,
  });

  factory TaskNextResponse.fromJson(Map<String, dynamic> json) {
    final payload = Map<String, dynamic>.from(json['payload'] as Map? ?? {});
    // El servidor usa "id" y "name"; el tipo real suele ir en payload.type
    final taskType = (payload['type'] as String?) ??
        (json['name'] as String?) ??
        'unknown';

    return TaskNextResponse(
      taskId: json['id'] as int,
      taskType: taskType,
      payload: payload,
      status: json['status'] as String? ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': taskId,
        'task_type': taskType,
        'payload': payload,
        'status': status,
      };
}

/// Resumen de créditos (/credits/me)
class CreditsSummary {
  final int totalCredits;
  final List<dynamic> recent;

  CreditsSummary({
    required this.totalCredits,
    required this.recent,
  });

  factory CreditsSummary.fromJson(Map<String, dynamic> json) =>
      CreditsSummary(
        totalCredits: json['total_credits'] as int,
        recent: List<dynamic>.from(json['recent'] as List),
      );

  Map<String, dynamic> toJson() => {
        'total_credits': totalCredits,
        'recent': recent,
      };
}

/// Respuesta genérica de error de la API
class ApiError {
  final String detail;

  ApiError({required this.detail});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      ApiError(detail: json['detail'] as String? ?? 'Error desconocido');
}