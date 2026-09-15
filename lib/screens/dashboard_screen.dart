// Dashboard principal con tabs: Inicio, Tarea, Créditos

import 'package:flutter/material.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../widgets/json_view.dart';

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

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Estado de datos
  UserResponse? _user;
  CreditsSummary? _credits;
  TaskNextResponse? _currentTask;
  bool _loadingUser = true;
  bool _loadingCredits = true;
  bool _loadingTask = true;
  String? _taskError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadUser(),
      _loadCredits(),
      _loadTask(),
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

  Future<void> _submitDummyTask() async {
    if (_currentTask == null) return;

    // Resultado simulado — aquí iría el cómputo real (NDVI, etc.)
    final dummyOutput = {
      'result': 'completed_from_mobile',
      'processed_at': DateTime.now().toIso8601String(),
      'device': 'flutter_mobile',
    };

    try {
      await widget.api.submitTask(
        taskId: _currentTask!.taskId,
        output: dummyOutput,
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Tarea enviada, ganando créditos...'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadAll(); // Refresca créditos y pide siguiente tarea
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco\'clock Network'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Inicio'),
            Tab(icon: Icon(Icons.task_alt_outlined), text: 'Tarea'),
            Tab(icon: Icon(Icons.stars_outlined), text: 'Créditos'),
          ],
        ),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildTaskTab(),
          _buildCreditsTab(),
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bienvenida
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
          const SizedBox(height: 24),

          // Descripción
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Sobre esta app',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Eco\'clock Network te permite donar capacidad de cómputo '
                    'ociosa de tu dispositivo para procesar datos ambientales '
                    '(deforestación, arrecifes de coral, biodiversidad).',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cada tarea completada genera créditos BOINC — '
                    'sin valor monetario, pero con valor simbólico '
                    'de contribución al planeta.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Acciones rápidas
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la tarea
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
          const SizedBox(height: 24),

          // Payload
          const Text('Datos de la tarea (payload):',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          JsonView(json: task.payload),
          const SizedBox(height: 24),

          // Nota
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 20, color: theme.colorScheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'En la versión beta, el cómputo se simula. '
                    'La versión final procesará los datos localmente.',
                    style: TextStyle(
                        color: theme.colorScheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Botón enviar
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Completar y enviar (simulado)'),
              onPressed: _submitDummyTask,
            ),
          ),
        ],
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total
          Row(
            children: [
              const Icon(Icons.star, size: 32, color: Colors.amber),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total créditos',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '$total',
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Historial
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_border,
                        size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      'Sin actividad reciente',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Completa tareas para ganar créditos',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: recent.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = recent[index] as Map<String, dynamic>;
                  final amount = entry['amount'] as int? ?? 0;
                  final taskType = entry['task_type'] as String? ?? 'tarea';
                  final createdAt = entry['created_at'] as String? ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.withOpacity(0.2),
                      child: const Icon(Icons.star, color: Colors.amber, size: 20),
                    ),
                    title: Text(
                      '$amount créditos · $taskType',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(createdAt),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}