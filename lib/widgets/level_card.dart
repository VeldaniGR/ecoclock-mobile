import 'package:flutter/material.dart';
import '../models/api_models.dart';

/// Icono Material asociado a cada nivel (sin assets PNG todavía).
IconData levelIcon(int id) {
  switch (id) {
    case 1:
      return Icons.explore_rounded; // Explorador
    case 2:
      return Icons.sensors_rounded; // Sensor
    case 3:
      return Icons.radar_rounded; // Centinela
    case 4:
      return Icons.wb_incandescent_rounded; // Faro (si no existe, cae al default)
    default:
      return Icons.hiking_rounded;
  }
}

Color levelColor(int id, ColorScheme cs) {
  switch (id) {
    case 1:
      return const Color(0xFF5A7A4A);
    case 2:
      return const Color(0xFFC4A35A);
    case 3:
      return const Color(0xFF2F5D4A);
    case 4:
      return const Color(0xFFE8D5A3);
    default:
      return cs.outline;
  }
}

class LevelCard extends StatelessWidget {
  final LevelInfo? level;
  final int streakDays;

  const LevelCard({super.key, required this.level, this.streakDays = 0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final lv = level;
    final id = lv?.id ?? 0;
    final name = lv?.name ?? 'Recién llegado';
    final progress = (lv?.progress ?? 0.0).clamp(0.0, 1.0);
    final next = lv?.nextName;
    final color = levelColor(id, cs);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.2),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(levelIcon(id), color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: cs.surfaceContainerHighest,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  next != null
                      ? 'Siguiente: $next · Racha $streakDays d'
                      : 'Nivel máximo · Racha $streakDays d',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementsRow extends StatelessWidget {
  final List<AchievementOut> achievements;

  const AchievementsRow({super.key, required this.achievements});

  IconData _iconFor(String id) {
    switch (id) {
      case 'first_task':
        return Icons.eco_rounded;
      case 'streak_7':
        return Icons.local_fire_department_rounded;
      case 'two_habitats':
        return Icons.public_rounded;
      default:
        return Icons.military_tech_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Logros', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        ...achievements.map((a) {
          final unlocked = a.unlocked;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  _iconFor(a.id),
                  size: 22,
                  color: unlocked ? cs.primary : cs.outline.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    a.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: unlocked ? cs.onSurface : cs.onSurfaceVariant,
                      fontWeight: unlocked ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  unlocked ? Icons.check_circle : Icons.lock_outline,
                  size: 18,
                  color: unlocked ? cs.primary : cs.outline.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
