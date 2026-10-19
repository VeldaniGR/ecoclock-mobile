Map<String, dynamic> computeTaskOutput(Map<String, dynamic> payload) {
  final type = (payload['type'] as String? ?? 'ndvi').toLowerCase();
  final now = DateTime.now().toUtc().toIso8601String();

  if (type == 'posidonia') {
    final unitId = payload['unit_id'] ?? 'unknown';
    final value = 500.0 + (DateTime.now().millisecond % 24500);
    return {
      'type': 'posidonia',
      'version': 1,
      'unit_id': unitId,
      'metric': 'surface_m2',
      'value': value,
      'unit': 'm2',
      'method': 'placeholder',
      'processed_at': now,
      'client': {'device': 'flutter_mobile'},
    };
  }

  if (type == 'biodiversity') {
    final unitId = payload['unit_id'] ?? 'unknown';
    final params = (payload['params'] as Map?) ?? {};
    final metric = params['metric'] as String? ?? 'presence_score';
    final value = metric == 'presence_score'
        ? (0.2 + (DateTime.now().millisecond % 80) / 100.0)
        : (15 + DateTime.now().millisecond % 400);
    return {
      'type': 'biodiversity',
      'version': 1,
      'unit_id': unitId,
      'metric': metric,
      'value': value,
      'unit': metric == 'presence_score' ? 'score' : 'species_count',
      'method': 'placeholder',
      'processed_at': now,
      'client': {'device': 'flutter_mobile'},
    };
  }

  // NDVI (default)
  final bands = (payload['bands'] as Map?) ?? {};
  final red = (bands['red'] as num?)?.toDouble();
  final nir = (bands['nir'] as num?)?.toDouble();
  late final double ndvi;
  late final String method;
  if (red != null && nir != null) {
    final denom = (nir + red) == 0 ? 1e-9 : (nir + red);
    ndvi = ((nir - red) / denom).clamp(-1.0, 1.0);
    method = 'formula_bands';
  } else {
    ndvi = 0.1 + (DateTime.now().millisecond % 80) / 100.0;
    method = 'placeholder';
  }
  return {
    'type': 'ndvi',
    'version': 1,
    'ndvi': double.parse(ndvi.toStringAsFixed(4)),
    'method': method,
    'processed_at': now,
    'client': {'device': 'flutter_mobile'},
  };
}
