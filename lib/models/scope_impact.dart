// Modelos de GET /impact/node y GET /impact/network (hexágonos agregados).
//
// Solo recuentos: cada hexágono indica cuántos participantes lo han
// desbloqueado, sin nombres ni identificadores de otros usuarios.

class ScopeHex {
  final String hexCode;
  final String color;

  /// Cuántos participantes han desbloqueado este hexágono.
  final int count;

  /// Fecha ISO 8601 del desbloqueo más reciente (se compara como texto).
  final String unlockedAt;

  const ScopeHex({
    required this.hexCode,
    required this.color,
    required this.count,
    required this.unlockedAt,
  });

  factory ScopeHex.fromJson(Map<String, dynamic> json) {
    return ScopeHex(
      hexCode: (json['hex_code'] ?? '') as String,
      color: (json['color'] ?? 'glacier') as String,
      count: (json['count'] as num?)?.toInt() ?? 1,
      unlockedAt: (json['unlocked_at'] ?? '') as String,
    );
  }
}

class ScopeImpact {
  /// Solo en "Mi nodo": null si el usuario no pertenece a ningún nodo.
  final int? nodeId;
  final String? nodeName;
  final int participants;
  final int totalHexes;
  final List<ScopeHex> hexes;

  const ScopeImpact({
    required this.nodeId,
    required this.nodeName,
    required this.participants,
    required this.totalHexes,
    required this.hexes,
  });

  factory ScopeImpact.fromJson(Map<String, dynamic> json) {
    final node = json['node'] as Map<String, dynamic>?;
    final rawHexes = (json['hexes'] as List<dynamic>?) ?? const <dynamic>[];
    final hexes = rawHexes
        .map((e) => ScopeHex.fromJson(e as Map<String, dynamic>))
        .toList();
    return ScopeImpact(
      nodeId: (node?['id'] as num?)?.toInt(),
      nodeName: node?['name'] as String?,
      participants: (json['participants'] as num?)?.toInt() ?? 0,
      totalHexes: (json['total_hexes'] as num?)?.toInt() ?? hexes.length,
      hexes: hexes,
    );
  }
}
