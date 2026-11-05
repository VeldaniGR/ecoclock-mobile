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

// ──────────────────────────────────────────────────────────────
// Mapa de impacto
// ──────────────────────────────────────────────────────────────

/// Hexágono desbloqueado (GET /me/impact)
class ImpactHex {
  final String tileSlug;
  final String hexCode;
  final String color;
  final String source;
  final String? expeditionSlug;
  final double? lat;
  final double? lon;
  final DateTime unlockedAt;
  final DateTime? validatedAt;

  ImpactHex({
    required this.tileSlug,
    required this.hexCode,
    required this.color,
    required this.source,
    this.expeditionSlug,
    this.lat,
    this.lon,
    required this.unlockedAt,
    this.validatedAt,
  });

  factory ImpactHex.fromJson(Map<String, dynamic> json) {
    return ImpactHex(
      tileSlug: json['tile_slug'] as String? ?? '',
      hexCode: json['hex_code'] as String? ?? '',
      color: json['color'] as String? ?? 'glacier',
      source: json['source'] as String? ?? '',
      expeditionSlug: json['expedition_slug'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      unlockedAt: DateTime.tryParse(json['unlocked_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      validatedAt: json['validated_at'] != null
          ? DateTime.tryParse(json['validated_at'] as String)
          : null,
    );
  }
}

/// Resumen de una loseta con sus hexágonos
class ImpactTileSummary {
  final String tileSlug;
  final String? tileName;
  final int totalUnlocked;
  final List<ImpactHex> hexes;

  ImpactTileSummary({
    required this.tileSlug,
    this.tileName,
    required this.totalUnlocked,
    required this.hexes,
  });

  factory ImpactTileSummary.fromJson(Map<String, dynamic> json) {
    final rawHexes = json['hexes'] as List<dynamic>? ?? [];
    return ImpactTileSummary(
      tileSlug: json['tile_slug'] as String? ?? '',
      tileName: json['tile_name'] as String?,
      totalUnlocked: json['total_unlocked'] as int? ?? 0,
      hexes: rawHexes
          .map((e) => ImpactHex.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Respuesta de GET /me/impact
class MeImpact {
  final List<ImpactTileSummary> tiles;
  final int totalHexes;

  MeImpact({
    required this.tiles,
    required this.totalHexes,
  });

  factory MeImpact.fromJson(Map<String, dynamic> json) {
    final rawTiles = json['tiles'] as List<dynamic>? ?? [];
    return MeImpact(
      tiles: rawTiles
          .map((e) => ImpactTileSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalHexes: json['total_hexes'] as int? ?? 0,
    );
  }

  /// Todos los hexágonos aplanados (útil para el grid)
  List<ImpactHex> get allHexes =>
      tiles.expand((t) => t.hexes).toList(growable: false);
}

/// Sobre de navegante (GET /me/impact/navigator-envelope)
class NavigatorEnvelope {
  final String status; // locked | ready | sent | validated
  final String? expeditionSlug;
  final String tileSlug;
  final int hexCount;
  final int hexThreshold;
  final int personalTaskCount;
  final int taskThreshold;
  final String? message;
  final String? trigger;

  NavigatorEnvelope({
    required this.status,
    this.expeditionSlug,
    required this.tileSlug,
    required this.hexCount,
    required this.hexThreshold,
    required this.personalTaskCount,
    required this.taskThreshold,
    this.message,
    this.trigger,
  });

  bool get isLocked => status == 'locked';
  bool get isReady => status == 'ready';
  bool get showBanner => status != 'locked';

  factory NavigatorEnvelope.fromJson(Map<String, dynamic> json) {
    return NavigatorEnvelope(
      status: json['status'] as String? ?? 'locked',
      expeditionSlug: json['expedition_slug'] as String?,
      tileSlug: json['tile_slug'] as String? ?? 'arctic',
      hexCount: json['hex_count'] as int? ?? 0,
      hexThreshold: json['hex_threshold'] as int? ?? 5,
      personalTaskCount: json['personal_task_count'] as int? ?? 0,
      taskThreshold: json['task_threshold'] as int? ?? 25,
      message: json['message'] as String?,
      trigger: json['trigger'] as String?,
    );
  }
}
