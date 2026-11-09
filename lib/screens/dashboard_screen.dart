// Dashboard principal con tabs: Inicio, Tarea, Créditos, Nodo, Donar, Settings

import 'package:flutter/material.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../widgets/json_view.dart';
import '../services/worker.dart';
import '../widgets/stat_card.dart';
import '../widgets/level_card.dart';
import '../widgets/impact_map_card.dart';
import '../l10n/app_localizations.dart';
import 'donar_screen.dart';
import 'nodo_screen.dart';
import 'settings_screen.dart';

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
  Map<String, dynamic>? _expedition;
  MeImpact? _impact;
  NavigatorEnvelope? _envelope;
  bool _loadingImpact = true;
  ImpactScope _impactScope = ImpactScope.me;

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
      _loadExpedition(),
      _loadImpact(),
      _loadEnvelope(),
    ]);
  }

  Future<void> _loadImpact() async {
    try {
      _impact = await widget.api.getMyImpact();
    } catch (_) {
      _impact = null;
    }
    if (mounted) {
      setState(() {
        _loadingImpact = false;
      });
    }
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
    final hexesBefore = _impact?.totalHexes ?? 0;

    try {
      await widget.api.submitTask(
        taskId: _currentTask!.taskId,
        output: output,
      );
      if (!mounted) return;

      final l10n = AppLocalizations.of(context);

      // Créditos, nueva tarea, expedición e impacto
      await Future.wait([
        _loadCredits(),
        _loadTask(),
        _loadExpedition(),
        _loadImpact(),
        _loadEnvelope(),
      ]);
      if (!mounted) return;

      final hexesAfter = _impact?.totalHexes ?? 0;
      String msg = l10n.taskSentSuccess;
      if (hexesAfter > hexesBefore) {
        // Hexágono(s) nuevo(s): mostrar el más reciente
        final all = _impact?.allHexes ?? [];
        if (all.isNotEmpty) {
          final sorted = [...all]
            ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
          final h = sorted.first;
          msg = '${l10n.taskSentSuccess} · ${h.hexCode} (${h.tileSlug})';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.green,
        ),
      );
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

  Future<void> _loadExpedition() async {
    try {
      _expedition = await widget.api.getCurrentExpedition();
    } catch (_) {
      _expedition = null;
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadEnvelope() async {
    try {
      _envelope = await widget.api.getNavigatorEnvelope();
    } catch (_) {
      _envelope = null;
    }
    if (mounted) setState(() {});
  }

  bool _isSendingEnvelope = false;

  Future<void> _onSendEnvelope() async {
    if (_isSendingEnvelope) return;

    setState(() => _isSendingEnvelope = true);
    final l10n = AppLocalizations.of(context);

    try {
      await widget.api.ackNavigatorEnvelopeSent();
      await _loadEnvelope();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.navigatorSentSuccess),
            backgroundColor: const Color(0xFF5B9EA6),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.navigatorSendError('$e')),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingEnvelope = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget.api.logout();
              widget.onLogout();
            },
            tooltip: l10n.logout,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAll,
            tooltip: l10n.refreshAll,
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
          SettingsScreen(api: widget.api),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          if (index == 3) _loadMyNode();
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.task_alt_outlined),
            selectedIcon: const Icon(Icons.task_alt),
            label: l10n.tabTask,
          ),
          NavigationDestination(
            icon: const Icon(Icons.stars_outlined),
            selectedIcon: const Icon(Icons.stars),
            label: l10n.tabCredits,
          ),
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: l10n.tabNode,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: l10n.tabDonate,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.tabSettings,
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
    final l10n = AppLocalizations.of(context);

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
              l10n.welcome(_user?.email ?? l10n.userFallback),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.userId('${_user?.id ?? '?'}'),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            // Expedición (una sola)
            if (_expedition != null) ...[
              _buildExpeditionCard(theme, l10n),
              const SizedBox(height: 16),
            ],

            // Sobre de navegante
            _buildNavigatorBanner(theme),

            // Mapa (uno solo)
            ImpactMapCard(
              impact: _impact,
              loading: _loadingImpact,
              scope: _impactScope,
              onScopeChanged: (s) => setState(() => _impactScope = s),
            ),
            const SizedBox(height: 16),

            // Nodo
            if (_myNode != null) ...[
              GestureDetector(
                onTap: () => setState(() => _currentIndex = 3),
                child: _buildNodeCard(theme, l10n),
              ),
              const SizedBox(height: 16),
            ],

            // Nivel
            if (_credits?.level != null) ...[
              LevelCard(
                level: _credits!.level,
                streakDays: _credits!.streakDays,
              ),
              const SizedBox(height: 16),
            ],

            // Stats
            _buildDashboardStatsRow(theme, l10n),
          ],
        ),
      ),
    );
  }

  /// Icono de la tarjeta de expedición según slug / reward_frame / nombre.
    String _expeditionEmoji(Map<String, dynamic> e) {
    final slug = (e['slug'] ?? '').toString().toLowerCase();
    final frame = (e['reward_frame'] ?? '').toString().toLowerCase();
    final name = (e['name'] ?? '').toString().toLowerCase();

    if (slug.contains('arctic') ||
        slug.contains('winter') ||
        frame.contains('arctic') ||
        frame.contains('ice') ||
        name.contains('hielo') ||
        name.contains('ártico') ||
        name.contains('artico')) {
      return '🧊';
    }
    if (slug.contains('autumn') ||
        slug.contains('fungi') ||
        frame.contains('fungi') ||
        name.contains('hongo') ||
        name.contains('otoño') ||
        name.contains('otono')) {
      return '🍄';
    }
    return '🧭';
  }

  String _expeditionTitle(Map<String, dynamic> e, AppLocalizations l10n) {
    final slug = (e['slug'] ?? '').toString().toLowerCase();
    if (slug.contains('arctic') || slug.contains('winter')) {
      return l10n.expeditionArcticName;
    }
    if (slug.contains('autumn') || slug.contains('fungi')) {
      return l10n.expeditionAutumnName;
    }
    return e['name']?.toString() ?? l10n.expeditionFallback;
  }

  String _expeditionDescription(Map<String, dynamic> e, AppLocalizations l10n) {
    final slug = (e['slug'] ?? '').toString().toLowerCase();
    if (slug.contains('arctic') || slug.contains('winter')) {
      return l10n.expeditionArcticDescription;
    }
    if (slug.contains('autumn') || slug.contains('fungi')) {
      return l10n.expeditionAutumnDescription;
    }
    return e['description']?.toString() ?? '';
  }

  Widget _buildExpeditionCard(ThemeData theme, AppLocalizations l10n) {
    final e = _expedition;
    if (e == null) return const SizedBox.shrink();

    final goal = (e['goal_value'] as num?)?.toInt() ?? 1;
    final current = (e['current_value'] as num?)?.toInt() ?? 0;
    final progress = ((e['progress'] as num?)?.toDouble() ??
            (goal > 0 ? current / goal : 0.0))
        .clamp(0.0, 1.0);
    final name = _expeditionTitle(e, l10n);
    final desc = _expeditionDescription(e, l10n);

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
              Text(_expeditionEmoji(e), style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              desc,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tasksProgress(
              current,
              goal,
              (progress * 100).toStringAsFixed(1),
            ),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigatorBanner(ThemeData theme) {
    final env = _envelope;
    final l10n = AppLocalizations.of(context);

    if (env == null || !env.showBanner) {
      return const SizedBox.shrink();
    }

    // Texto 100 % local (no depende del message del servidor)
    final String? bannerText = switch (env.status) {
      'ready' => l10n.navigatorBannerReady,
      'sent' => l10n.navigatorBannerSent,
      'validated' => l10n.navigatorBannerValidated,
      _ => null,
    };
    if (bannerText == null) return const SizedBox.shrink();

    final bool canSend = env.status == 'ready' || env.status == 'sent';
    final String buttonLabel = env.status == 'sent'
        ? l10n.navigatorResendButton
        : l10n.navigatorSendButton;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF5B9EA6).withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF5B9EA6), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('✉️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bannerText,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.navigatorHexTasksCounter(
                        env.hexCount,
                        env.hexThreshold,
                        env.personalTaskCount,
                        env.taskThreshold,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (canSend) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSendingEnvelope ? null : _onSendEnvelope,
                icon: _isSendingEnvelope
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  _isSendingEnvelope ? l10n.navigatorSending : buttonLabel,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9EA6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNodeCard(ThemeData theme, AppLocalizations l10n) {
    final node = _myNode!;
    final logoUrl = node['logo_url'];
    final frame = node['logo_frame']?.toString();
    final frameAsset = _homeFrameAsset(frame);

    Widget logoWidget;
    if (logoUrl != null) {
      logoWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          '${EcoClockApi.baseUrl}$logoUrl',
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.groups, size: 28),
        ),
      );
    } else {
      logoWidget = Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.groups, color: theme.colorScheme.primary),
      );
    }

    if (frameAsset != null) {
      logoWidget = SizedBox(
        width: 56,
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: 40, height: 40, child: logoWidget),
            Image.asset(frameAsset, width: 56, height: 56, fit: BoxFit.contain),
          ],
        ),
      );
    }

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
          logoWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.nodeMember,
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

  String? _homeFrameAsset(String? frameId) {
    if (frameId == null || frameId.isEmpty || frameId == 'none') return null;
    const known = {
      'autumn_fungi',
      'water',
      'deforestation',
      'environmental_crime',
      'energy',
      'sea_ice',
      'arctic_ice',
      'ozone',
      'posidonia',
    };
    if (!known.contains(frameId)) return null;
    return 'assets/frames/$frameId.png';
  }

  // ──────────────────────────────────────────────────────────────
  // Tab: Tarea
  // ──────────────────────────────────────────────────────────────

  Widget _buildTaskTab() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

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
        message: l10n.noTasksAvailable,
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
                        l10n.newTask(task.taskType),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.taskId('${task.taskId}'),
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
                    label: l10n.manualTasks,
                    value: '${_credits?.manualCount ?? 0}',
                    icon: Icons.touch_app_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatChip(
                    theme,
                    label: l10n.autoTasks,
                    value: '${_credits?.autoCount ?? 0}',
                    icon: Icons.autorenew,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.taskPayload,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            JsonView(json: task.payload),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                icon: const Icon(Icons.send),
                label: Text(l10n.computeAndSubmit),
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
    final l10n = AppLocalizations.of(context);

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
              label: Text(l10n.retry),
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
    final l10n = AppLocalizations.of(context);

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
                        l10n.totalCredits,
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
            _buildDashboardStatsRow(theme, l10n),
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
                Text(l10n.recentHistory, style: theme.textTheme.titleMedium),
                if (recent.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(l10n.updateHistory),
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
                        l10n.noRecentActivity,
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
                      l10n.creditEntry(_formatCredits(amount), taskId),
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

  Widget _buildDashboardStatsRow(ThemeData theme, AppLocalizations l10n) {
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
                label: l10n.streak,
                primaryValue: '$streak d',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                icon: Icons.calendar_today_rounded,
                label: l10n.week,
                primaryValue: weekLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StatCard(
          icon: Icons.check_circle_outline_rounded,
          label: l10n.totalTasks,
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