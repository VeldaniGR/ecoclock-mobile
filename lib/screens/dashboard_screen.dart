// Dashboard principal con tabs: Inicio, Tarea, Créditos, Nodo, Donar

import 'package:flutter/material.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../widgets/json_view.dart';
import '../services/worker.dart';
import '../widgets/stat_card.dart';
import '../widgets/level_card.dart';
import 'donar_screen.dart';
import 'nodo_screen.dart';

class DashboardScreen extends StatefulWidget {
  final EcoClockApi api;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.api,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  UserResponse? _user;
  CreditsSummary? _credits;
  TaskNextResponse? _currentTask;
  Map<String, dynamic>? _myNode;
  bool _loadingUser = true;
  bool _loadingCredits = true;
  bool _loadingTask = true;
  String? _taskError;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadUser(),
      _loadCredits(),
      _loadTask(),
      _loadMyNode(),
    ]);
  }

  Future<void> _loadUser() async {
    try {
      _user = await widget.api.getMe();
    } catch (_) {
      _user = null;
    }
    if (mounted) setState(() => _loadingUser = false);
  }

  Future<void> _loadCredits() async {
    try {
      _credits = await widget.api.getCredits();
    } catch (_) {
      _credits = null;
    }
    if (mounted) setState(() => _loadingCredits = false);
  }

  Future<void> _loadTask() async {
    try {
      _currentTask = await widget.api.getNextTask();
      _taskError = null;
    } on ApiException catch (e) {
      _taskError = e.message;
      _currentTask = null;
    } catch (e) {
      _taskError = 'Error inesperado: $e';
      _currentTask = null;
    }
    if (mounted) setState(() => _loadingTask = false);
  }

  Future<void> _loadMyNode() async {
    try {
      _myNode = await widget.api.getMyNode();
    } catch (_) {
      _myNode = null;
    }
    if (mounted) setState(() {});
  }

  Future<void> _submitComputedTask() async {
    if (_currentTask == null) return;

    final output = computeTaskOutput(_currentTask!.payload);

    try {
      await widget.api.submitTask(
        taskId: _currentTask!.taskId,
        output: output,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarea enviada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadCredits();
      await _loadAll();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco\'clock Network'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget.api.logout();
              widget.onLogout();
            },
            tooltip: 'Cerrar sesión',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAll,
            tooltip: 'Refrescar todo',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          _buildTaskTab(),
          _buildCreditsTab(),
          NodoScreen(api: widget.api),
          const DonarScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          // Recargar nodo al entrar en la pestaña
          if (index == 3) _loadMyNode();
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tarea',
          ),
          NavigationDestination(
            icon: Icon(Icons.stars_outlined),
            selectedIcon: Icon(Icons.stars),
            label: 'Créditos',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Nodo',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Donar',
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Tab: Inicio
  // ──────────────────────────────────────────────────────────────

  Widget _buildHomeTab() {
    final theme = Theme.of(context);

    if (_loadingUser) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, ${_user?.email ?? 'usuario'}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ID de usuario: ${_user?.id ?? '?'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Card de Nodo (si pertenece a uno)
            if (_myNode != null) ...[
              _buildNodeCard(theme),
              const SizedBox(height: 16),
            ],

            if (_credits?.level != null) ...[
              LevelCard(
                level: _credits!.level,
                streakDays: _credits!.streakDays,
              ),
              const SizedBox(height: 16),
            ],
            _buildDashboardStatsRow(theme),
            const SizedBox(height: 28),
            Text('Acciones rápidas', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refrescar todo'),
                  onPressed: _loadAll,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.task_alt),
                  label: const Text('Pedir tarea'),
                  onPressed: _loadTask,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNodeCard(ThemeData theme) {
    final node = _myNode!;
    final logoUrl = node['logo_url'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          if (logoUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${EcoClockApi.baseUrl}$logoUrl',
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.groups, size: 28),
              ),
            )
          else
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.groups, color: theme.colorScheme.primary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Miembro del Nodo',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  node['name'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.outline),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Tab: Tarea
  // ──────────────────────────────────────────────────────────────

  Widget _buildTaskTab() {
    final theme = Theme.of(context);

    if (_loadingTask) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_taskError != null) {
      return _buildErrorState(
        icon: Icons.error_outline,
        color: Colors.orange,
        message: _taskError!,
        onRetry: _loadTask,
      );
    }

    if (_currentTask == null) {
      return _buildErrorState(
        icon: Icons.inbox_outlined,
        color: theme.colorScheme.primary,
        message: 'No hay tareas disponibles ahora mismo.\nInténtalo más tarde.',
        onRetry: _loadTask,
      );
    }

    final task = _currentTask!;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva tarea: ${task.taskType}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${task.taskId}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    task.taskType.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatChip(
                    theme,
                    label: 'Manuales',
                    value: '${_credits?.manualCount ?? 0}',
                    icon: Icons.touch_app_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatChip(
                    theme,
                    label: 'Automáticas',
                    value: '${_credits?.autoCount ?? 0}',
                    icon: Icons.autorenew,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Datos de la tarea (payload):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            JsonView(json: task.payload),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Calcular y enviar'),
                onPressed: _submitComputedTask,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required IconData icon,
    required Color color,
    required String message,
    required VoidCallback onRetry,
  }) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Tab: Créditos
  // ──────────────────────────────────────────────────────────────

  Widget _buildCreditsTab() {
    final theme = Theme.of(context);

    if (_loadingCredits) {
      return const Center(child: CircularProgressIndicator());
    }

    final total = _credits?.totalCredits ?? 0;
    final recent = _credits?.recent ?? [];

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, size: 32, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total créditos',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _formatCredits(total),
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDashboardStatsRow(theme),
            if (_credits != null) ...[
              const SizedBox(height: 16),
              LevelCard(
                level: _credits!.level,
                streakDays: _credits!.streakDays,
              ),
              const SizedBox(height: 16),
              AchievementsRow(achievements: _credits!.achievements),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Historial reciente', style: theme.textTheme.titleMedium),
                if (recent.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Actualizar'),
                    onPressed: _loadCredits,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (recent.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_border, size: 64, color: theme.colorScheme.outline),
                      const SizedBox(height: 16),
                      Text(
                        'Sin actividad reciente',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recent.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = recent[index];
                  final amountNum = entry['amount'];
                  final amount = (amountNum is num) ? amountNum.toDouble() : 0.0;
                  final taskId = entry['task_id']?.toString() ?? '—';
                  final grantedAt = entry['granted_at']?.toString() ?? '';

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.withValues(alpha: 0.2),
                      child: const Icon(Icons.star, color: Colors.amber, size: 20),
                    ),
                    title: Text(
                      '${_formatCredits(amount)} créditos · tarea #$taskId',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(grantedAt),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardStatsRow(ThemeData theme) {
    final c = _credits;
    final streak = c?.streakDays ?? 0;
    final week = c?.creditsThisWeek ?? 0;
    final tasks = c?.tasksDone ?? 0;

    final weekLabel = week >= 100 ? week.round().toString() : _formatCredits(week);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department_rounded,
                label: 'Racha',
                primaryValue: '$streak d',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.calendar_today_rounded,
                label: 'Semana',
                primaryValue: weekLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StatCard(
          icon: Icons.check_circle_outline_rounded,
          label: 'Tareas totales',
          primaryValue: '$tasks',
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildStatChip(
    ThemeData theme, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCredits(num value) {
    final v = value.toDouble();
    if (v == v.roundToDouble()) return v.toInt().toString();
    var s = v.toStringAsFixed(3);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }
}
