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

/// Nivel de gamificación (Fase B)
class LevelInfo {
  final int id;
  final String name;
  final int? nextId;
  final String? nextName;
  final double progress;

  LevelInfo({
    required this.id,
    required this.name,
    this.nextId,
    this.nextName,
    this.progress = 0.0,
  });

  factory LevelInfo.fromJson(Map<String, dynamic> json) => LevelInfo(
        id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
        name: json['name'] as String? ?? 'Recién llegado',
        nextId: (json['next_id'] is num) ? (json['next_id'] as num).toInt() : null,
        nextName: json['next_name'] as String?,
        progress: (json['progress'] is num) ? (json['progress'] as num).toDouble() : 0.0,
      );
}

/// Logro de gamificación
class AchievementOut {
  final String id;
  final String name;
  final DateTime? unlockedAt;

  AchievementOut({
    required this.id,
    required this.name,
    this.unlockedAt,
  });

  bool get unlocked => unlockedAt != null;

  factory AchievementOut.fromJson(Map<String, dynamic> json) {
    DateTime? dt;
    final raw = json['unlocked_at'];
    if (raw != null) dt = DateTime.tryParse(raw.toString());
    return AchievementOut(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      unlockedAt: dt,
    );
  }
}

/// Resumen de créditos (GET /me/credits)
class CreditsSummary {
  final int userId;
  final String username;
  final double totalCredits;
  final List<Map<String, dynamic>> recent;
  final Map<String, int> byMode;
  final Map<String, int> byClient;
  final int tasksDone;
  final double creditsThisWeek;
  final int streakDays;
  final DateTime? lastActiveAt;
  final int activeDays;
  final List<String> taskTypes;
  final LevelInfo? level;
  final List<AchievementOut> achievements;

  CreditsSummary({
    required this.userId,
    required this.username,
    required this.totalCredits,
    required this.recent,
    this.byMode = const {},
    this.byClient = const {},
    this.tasksDone = 0,
    this.creditsThisWeek = 0,
    this.streakDays = 0,
    this.lastActiveAt,
    this.activeDays = 0,
    this.taskTypes = const [],
    this.level,
    this.achievements = const [],
  });

  factory CreditsSummary.fromJson(Map<String, dynamic> json) {
    final total = json['total'];
    Map<String, int> parseCountMap(dynamic raw) {
      if (raw is! Map) return {};
      return {
        for (final e in raw.entries)
          e.key.toString(): (e.value is num) ? (e.value as num).toInt() : 0,
      };
    }

    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    LevelInfo? level;
    if (json['level'] is Map) {
      level = LevelInfo.fromJson(Map<String, dynamic>.from(json['level'] as Map));
    }

    final achievements = (json['achievements'] as List? ?? [])
        .whereType<Map>()
        .map((e) => AchievementOut.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final taskTypes = (json['task_types'] as List? ?? [])
        .map((e) => e.toString())
        .toList();

    return CreditsSummary(
      userId: json['user_id'] as int,
      username: json['username'] as String? ?? '',
      totalCredits: (total is num) ? total.toDouble() : 0.0,
      recent: (json['recent'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      byMode: parseCountMap(json['by_mode']),
      byClient: parseCountMap(json['by_client']),
      tasksDone: (json['tasks_done'] is num)
          ? (json['tasks_done'] as num).toInt()
          : 0,
      creditsThisWeek: (json['credits_this_week'] is num)
          ? (json['credits_this_week'] as num).toDouble()
          : 0.0,
      streakDays: (json['streak_days'] is num)
          ? (json['streak_days'] as num).toInt()
          : 0,
      lastActiveAt: parseDt(json['last_active_at']),
      activeDays: (json['active_days'] is num)
          ? (json['active_days'] as num).toInt()
          : 0,
      taskTypes: taskTypes,
      level: level,
      achievements: achievements,
    );
  }

  int get manualCount => byMode['manual'] ?? 0;
  int get autoCount => byMode['auto'] ?? 0;

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
        'total': totalCredits,
        'recent': recent,
        'by_mode': byMode,
        'by_client': byClient,
        'tasks_done': tasksDone,
        'credits_this_week': creditsThisWeek,
        'streak_days': streakDays,
        'last_active_at': lastActiveAt?.toIso8601String(),
        'active_days': activeDays,
        'task_types': taskTypes,
      };
}

/// Respuesta genérica de error de la API
class ApiError {
  final String detail;

  ApiError({required this.detail});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      ApiError(detail: json['detail'] as String? ?? 'Error desconocido');
}
