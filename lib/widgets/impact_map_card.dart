import 'package:flutter/material.dart';
import '../models/api_models.dart';

/// Filtro del mapa de impacto (v1: solo "Solo yo" tiene datos de API).
enum ImpactScope { me, node, network }

class ImpactMapCard extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = impact?.totalHexes ?? 0;
    final hexes = impact?.allHexes ?? const <ImpactHex>[];

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
              if (!loading)
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
            selected: {scope},
            onSelectionChanged: (s) {
              if (s.isNotEmpty) onScopeChanged(s.first);
            },
          ),
          const SizedBox(height: 14),
          if (loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (scope != ImpactScope.me)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                scope == ImpactScope.node
                    ? 'Vista de nodo: próximamente'
                    : 'Vista de red: próximamente',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else if (hexes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Aún no has desbloqueado hexágonos. '
                'Completa tareas en zonas de impacto para colorear el mapa.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final h in hexes)
                  _HexChip(
                    code: h.hexCode,
                    color: _colorFor(h.color),
                    tile: h.tileSlug,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _HexChip extends StatelessWidget {
  final String code;
  final Color color;
  final String tile;

  const _HexChip({
    required this.code,
    required this.color,
    required this.tile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1.4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            tile,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
