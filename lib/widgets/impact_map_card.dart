import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/api_models.dart';

enum ImpactScope { me, node, network }

class ImpactMapCard extends StatefulWidget {
  final MeImpact? impact;
  final bool loading;
  final ImpactScope scope;
  final ValueChanged<ImpactScope> onScopeChanged;

  const ImpactMapCard({
    super.key,
    required this.impact,
    required this.loading,
    required this.scope,
    required this.onScopeChanged,
  });

  @override
  State<ImpactMapCard> createState() => _ImpactMapCardState();
}

class _ImpactMapCardState extends State<ImpactMapCard> {
  final TransformationController _transform = TransformationController();
  static const int cols = 10;
  static const int rows = 10;
  static const double hexR = 18;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  static Color _colorFor(String color) {
    switch (color) {
      case 'glacier':
        return const Color(0xFF5B9EA6);
      case 'gold':
        return const Color(0xFFFFB300);
      case 'forest':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF5B9EA6);
    }
  }

  /// Código "D6" → (col 0-based, row 0-based) alineado con impact_geo (A=row0).
  static (int col, int row)? _parseHex(String code) {
    if (code.isEmpty) return null;
    final letter = code[0].toUpperCase();
    final numStr = code.substring(1);
    final col = int.tryParse(numStr);
    if (col == null || col < 1 || col > cols) return null;
    final row = letter.codeUnitAt(0) - 'A'.codeUnitAt(0);
    if (row < 0 || row >= rows) return null;
    return (col - 1, row);
  }

  double get _gridW {
    final horiz = hexR * math.sqrt(3);
    return (cols - 1) * horiz + 2 * hexR + 24;
  }

  double get _gridH {
    final vert = hexR * 1.5;
    return (rows - 1) * vert + 2 * hexR + 24;
  }

  void _centerOnLatest() {
    final hexes = widget.impact?.allHexes ?? [];
    if (hexes.isEmpty) {
      _transform.value = Matrix4.identity();
      return;
    }
    // Último desbloqueado = el de unlockedAt más reciente
    final sorted = [...hexes]
      ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
    final parsed = _parseHex(sorted.first.hexCode);
    if (parsed == null) return;
    final (col, row) = parsed;
    final horiz = hexR * math.sqrt(3);
    final vert = hexR * 1.5;
    final ox = 12.0 + hexR;
    final oy = 12.0 + hexR;
    final offsetX = (row.isOdd) ? horiz / 2 : 0.0;
    final cx = ox + col * horiz + offsetX;
    final cy = oy + row * vert;

    // Centrar en el viewport ~280x220
    const vw = 280.0;
    const vh = 220.0;
    final dx = vw / 2 - cx;
    final dy = vh / 2 - cy;
    _transform.value = Matrix4.identity()..translate(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.impact?.totalHexes ?? 0;
    final hexes = widget.impact?.allHexes ?? const <ImpactHex>[];
    final unlocked = <String, ImpactHex>{
      for (final h in hexes) h.hexCode.toUpperCase(): h,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🗺️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mapa de impacto',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!widget.loading)
                Text(
                  '$total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<ImpactScope>(
            segments: const [
              ButtonSegment(value: ImpactScope.me, label: Text('Solo yo')),
              ButtonSegment(value: ImpactScope.node, label: Text('Mi nodo')),
              ButtonSegment(value: ImpactScope.network, label: Text('Red')),
            ],
            selected: {widget.scope},
            onSelectionChanged: (s) {
              if (s.isNotEmpty) widget.onScopeChanged(s.first);
            },
          ),
          const SizedBox(height: 12),
          if (widget.loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.scope != ImpactScope.me)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                widget.scope == ImpactScope.node
                    ? 'Vista de nodo: próximamente'
                    : 'Vista de red: próximamente',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 220,
                width: double.infinity,
                color: const Color(0xFF0D1B1E),
                child: Stack(
                  children: [
                    InteractiveViewer(
                      transformationController: _transform,
                      minScale: 0.6,
                      maxScale: 3.5,
                      boundaryMargin: const EdgeInsets.all(80),
                      child: SizedBox(
                        width: _gridW,
                        height: _gridH,
                        child: CustomPaint(
                          painter: _ArcticHexPainter(
                            unlocked: unlocked,
                            cols: cols,
                            rows: rows,
                            hexR: hexR,
                            colorFor: _colorFor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Material(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                        child: IconButton(
                          tooltip: 'Centrar',
                          onPressed: _centerOnLatest,
                          icon: const Icon(Icons.my_location, size: 20),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Ártico · arrastra / zoom',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hexes.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Aún no has desbloqueado hexágonos. '
                  'Completa tareas en zonas de impacto para colorear el mapa.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _ArcticHexPainter extends CustomPainter {
  final Map<String, ImpactHex> unlocked;
  final int cols;
  final int rows;
  final double hexR;
  final Color Function(String) colorFor;

  _ArcticHexPainter({
    required this.unlocked,
    required this.cols,
    required this.rows,
    required this.hexR,
    required this.colorFor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final horiz = hexR * math.sqrt(3);
    final vert = hexR * 1.5;
    final ox = 12.0 + hexR;
    final oy = 12.0 + hexR;

    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF5B9EA6).withValues(alpha: 0.45);

    final emptyFill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1A2F34);

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final letter = String.fromCharCode('A'.codeUnitAt(0) + row);
        final code = '$letter${col + 1}';
        final offsetX = row.isOdd ? horiz / 2 : 0.0;
        final cx = ox + col * horiz + offsetX;
        final cy = oy + row * vert;
        final path = _hexPath(cx, cy, hexR);

        final hit = unlocked[code];
        if (hit != null) {
          final fill = Paint()
            ..style = PaintingStyle.fill
            ..color = colorFor(hit.color).withValues(alpha: 0.85);
          canvas.drawPath(path, fill);
          canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.6
              ..color = colorFor(hit.color),
          );
        } else {
          canvas.drawPath(path, emptyFill);
          canvas.drawPath(path, border);
        }

        final tp = TextPainter(
          text: TextSpan(
            text: code,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: hit != null ? Colors.white : Colors.white38,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
      }
    }
  }

  Path _hexPath(double cx, double cy, double r) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = -math.pi / 6 + i * math.pi / 3;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _ArcticHexPainter oldDelegate) =>
      oldDelegate.unlocked != unlocked;
}
