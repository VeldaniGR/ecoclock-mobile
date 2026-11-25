import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../models/scope_impact.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

enum ImpactScope { me, node, network }

/// Celda lista para dibujar: color y nº de participantes que la desbloquearon.
class _Cell {
  final String color;
  final int count;
  const _Cell(this.color, this.count);
}

class ImpactMapCard extends StatefulWidget {
  final MeImpact? impact;
  final bool loading;
  final ImpactScope scope;
  final ValueChanged<ImpactScope> onScopeChanged;

  /// Cliente de la API: la tarjeta lo usa para cargar "Mi nodo" y "Red".
  final EcoClockApi api;

  const ImpactMapCard({
    super.key,
    required this.impact,
    required this.loading,
    required this.scope,
    required this.onScopeChanged,
    required this.api,
  });

  @override
  State<ImpactMapCard> createState() => _ImpactMapCardState();
}

class _ImpactMapCardState extends State<ImpactMapCard> {
  final TransformationController _transform = TransformationController();
  static const int cols = 10;
  static const int rows = 10;
  static const double hexR = 18;

  // Datos de "Mi nodo" y "Red". Se conservan al cambiar de pestaña y se
  // vuelven a pedir en cada visita, mostrando mientras tanto lo último que hubiera.
  final Map<ImpactScope, ScopeImpact> _scopeData = {};
  bool _scopeLoading = false;
  bool _scopeError = false;
  int _requestId = 0;
  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    if (widget.scope != ImpactScope.me) _loadScope(widget.scope);
  }

  @override
  void didUpdateWidget(covariant ImpactMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scope != widget.scope) {
      _selectedCode = null;
      if (widget.scope != ImpactScope.me) _loadScope(widget.scope);
    }
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  /// Pide los datos del ámbito. Se llama desde initState/didUpdateWidget (que
  /// van seguidos de build, así que no hace falta setState al empezar) o dentro
  /// de un setState (botón de reintento).
  Future<void> _loadScope(ImpactScope scope) async {
    final id = ++_requestId;
    _scopeLoading = true;
    _scopeError = false;
    try {
      final data = scope == ImpactScope.node
          ? await widget.api.getNodeImpact()
          : await widget.api.getNetworkImpact();
      if (!mounted || id != _requestId) return;
      setState(() {
        _scopeData[scope] = data;
        _scopeLoading = false;
        _scopeError = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.scope == scope) _centerOnLatest();
      });
    } catch (_) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _scopeLoading = false;
        _scopeError = true;
      });
    }
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

  /// Celdas del ámbito visible, indexadas por código de hexágono.
  Map<String, _Cell> _cells() {
    if (widget.scope == ImpactScope.me) {
      final hexes = widget.impact?.allHexes ?? const <ImpactHex>[];
      return {
        for (final h in hexes) h.hexCode.toUpperCase(): _Cell(h.color, 1),
      };
    }
    final data = _scopeData[widget.scope];
    if (data == null) return const <String, _Cell>{};
    return {
      for (final h in data.hexes) h.hexCode.toUpperCase(): _Cell(h.color, h.count),
    };
  }

  void _centerOnLatest() {
    // Hexágono desbloqueado más recientemente en el ámbito visible
    String? latestCode;
    var latestAt = '';
    if (widget.scope == ImpactScope.me) {
      for (final h in widget.impact?.allHexes ?? const <ImpactHex>[]) {
        final at = h.unlockedAt.toString();
        if (latestCode == null || at.compareTo(latestAt) > 0) {
          latestCode = h.hexCode;
          latestAt = at;
        }
      }
    } else {
      for (final h in _scopeData[widget.scope]?.hexes ?? const <ScopeHex>[]) {
        if (latestCode == null || h.unlockedAt.compareTo(latestAt) > 0) {
          latestCode = h.hexCode;
          latestAt = h.unlockedAt;
        }
      }
    }
    if (latestCode == null) {
      _transform.value = Matrix4.identity();
      return;
    }
    final parsed = _parseHex(latestCode);
    if (parsed == null) return;
    final (col, row) = parsed;
    final horiz = hexR * math.sqrt(3);
    final vert = hexR * 1.5;
    final ox = 12.0 + hexR;
    final oy = 12.0 + hexR;
    final offsetX = (row.isOdd) ? horiz / 2 : 0.0;
    final cx = ox + col * horiz + offsetX;
    final cy = oy + row * vert;

    const vw = 280.0;
    const vh = 220.0;
    final dx = vw / 2 - cx;
    final dy = vh / 2 - cy;

    final m = Matrix4.identity();
    m.setTranslationRaw(dx, dy, 0);
    _transform.value = m;
  }

  /// Código del hexágono bajo un punto (coordenadas de la rejilla), o null.
  String? _hexAt(Offset p) {
    final horiz = hexR * math.sqrt(3);
    final vert = hexR * 1.5;
    final ox = 12.0 + hexR;
    final oy = 12.0 + hexR;
    String? best;
    var bestD = math.pow(hexR * 0.9, 2).toDouble();
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cx = ox + col * horiz + (row.isOdd ? horiz / 2 : 0.0);
        final cy = oy + row * vert;
        final dx = p.dx - cx;
        final dy = p.dy - cy;
        final d = dx * dx + dy * dy;
        if (d < bestD) {
          bestD = d;
          best = '${String.fromCharCode('A'.codeUnitAt(0) + row)}${col + 1}';
        }
      }
    }
    return best;
  }

  Widget _errorRow(AppLocalizations l10n, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.impactScopeError,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() {
            _loadScope(widget.scope);
          }),
          child: Text(l10n.impactRetry),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isMe = widget.scope == ImpactScope.me;
    final scopeData = isMe ? null : _scopeData[widget.scope];
    final cells = _cells();
    final maxCount =
        cells.values.fold<int>(1, (m, c) => c.count > m ? c.count : m);
    final total =
        isMe ? (widget.impact?.totalHexes ?? 0) : (scopeData?.totalHexes ?? 0);
    final showSpinner =
        isMe ? widget.loading : (_scopeLoading && scopeData == null);
    final noNode = widget.scope == ImpactScope.node &&
        scopeData != null &&
        scopeData.nodeId == null;
    final selected = _selectedCode != null ? cells[_selectedCode] : null;

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
                  l10n.impactMapTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!showSpinner)
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
            segments: [
              ButtonSegment(
                value: ImpactScope.me,
                label: Text(l10n.impactTabOnlyMe),
              ),
              ButtonSegment(
                value: ImpactScope.node,
                label: Text(l10n.impactTabMyNode),
              ),
              ButtonSegment(
                value: ImpactScope.network,
                label: Text(l10n.impactTabNetwork),
              ),
            ],
            selected: {widget.scope},
            onSelectionChanged: (s) {
              if (s.isNotEmpty) widget.onScopeChanged(s.first);
            },
          ),
          const SizedBox(height: 12),
          if (showSpinner)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!isMe && scopeData == null && _scopeError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _errorRow(l10n, theme),
            )
          else if (noNode)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                l10n.impactNoNode,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            if (scopeData != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  [
                    if (widget.scope == ImpactScope.node &&
                        (scopeData.nodeName ?? '').isNotEmpty)
                      scopeData.nodeName!,
                    l10n.impactParticipants(scopeData.participants),
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (!isMe && _scopeError) _errorRow(l10n, theme),
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
                        child: GestureDetector(
                          // Pulsar un hexágono de nodo o red muestra cuántos participantes lo tienen
                          onTapUp: isMe
                              ? null
                              : (details) {
                                  final code = _hexAt(details.localPosition);
                                  setState(() {
                                    _selectedCode =
                                        (code != null && cells.containsKey(code))
                                            ? code
                                            : null;
                                  });
                                },
                          child: CustomPaint(
                            painter: _ArcticHexPainter(
                              unlocked: cells,
                              cols: cols,
                              rows: rows,
                              hexR: hexR,
                              colorFor: _colorFor,
                              showCounts: !isMe,
                              maxCount: maxCount,
                              selected: isMe ? null : _selectedCode,
                            ),
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
                          tooltip: l10n.impactCenterMap,
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
                        child: Text(
                          l10n.impactArcticHint,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    if (selected != null)
                      Positioned(
                        left: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_selectedCode · ${l10n.impactParticipants(selected.count)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isMe && cells.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  l10n.impactNoHexesHint,
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
  final Map<String, _Cell> unlocked;
  final int cols;
  final int rows;
  final double hexR;
  final Color Function(String) colorFor;

  /// En nodo y red, la intensidad del color crece con el nº de participantes.
  final bool showCounts;
  final int maxCount;
  final String? selected;

  _ArcticHexPainter({
    required this.unlocked,
    required this.cols,
    required this.rows,
    required this.hexR,
    required this.colorFor,
    required this.showCounts,
    required this.maxCount,
    required this.selected,
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
          // De 0,40 a 0,85 de opacidad según los participantes (0,85 fijo en "Solo yo")
          final alpha = (showCounts && maxCount > 1)
              ? 0.40 + 0.45 * hit.count / maxCount
              : 0.85;
          final fill = Paint()
            ..style = PaintingStyle.fill
            ..color = colorFor(hit.color).withValues(alpha: alpha);
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

        if (code == selected) {
          canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.4
              ..color = Colors.white,
          );
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
      oldDelegate.unlocked != unlocked ||
      oldDelegate.showCounts != showCounts ||
      oldDelegate.maxCount != maxCount ||
      oldDelegate.selected != selected;
}
