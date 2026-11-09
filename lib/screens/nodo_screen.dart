import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../services/api_service.dart';

class NodoScreen extends StatefulWidget {
  final EcoClockApi api;

  const NodoScreen({super.key, required this.api});

  @override
  State<NodoScreen> createState() => _NodoScreenState();
}

class _NodoScreenState extends State<NodoScreen> {
  Map<String, dynamic>? _myNode;
  List<dynamic> _publicNodes = [];
  List<dynamic> _members = [];
  List<dynamic> _joinRequests = [];
  bool _loading = true;
  bool _loadingPublic = false;
  bool _loadingAdminLists = false;
  bool _uploadingLogo = false;
  String? _error;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _picker = ImagePicker();

  static const _frameLabels = {
    'autumn_fungi': 'Otoño · Hongos',
  };

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  List<String> _unlockedFrames(Map<String, dynamic> node) {
    final raw = node['unlocked_frames'];
    if (raw == null) return [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) return decoded.map((e) => e.toString()).toList();
      } catch (_) {}
    }
    return [];
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.wait([_loadMyNode(), _loadPublicNodes()]);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadMyNode() async {
    try {
      final node = await widget.api.getMyNode();
      if (mounted) {
        setState(() => _myNode = node);
        if (node != null) await _loadAdminLists(node);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _myNode = null;
          _members = [];
          _joinRequests = [];
          if (!e.toString().contains('404')) _error = e.toString();
        });
      }
    }
  }

  Future<void> _loadAdminLists(Map<String, dynamic> node) async {
    final id = node['id'] as int?;
    if (id == null) return;
    setState(() => _loadingAdminLists = true);
    try {
      final members = await widget.api.listNodeMembers(id);
      List<dynamic> requests = [];
      if (node['my_role'] == 'admin') {
        try {
          requests = await widget.api.listJoinRequests(id);
          requests = requests.where((r) => r['status'] == 'pending').toList();
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _members = members;
          _joinRequests = requests;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _members = [];
          _joinRequests = [];
        });
      }
    }
    if (mounted) setState(() => _loadingAdminLists = false);
  }

  Future<void> _loadPublicNodes() async {
    setState(() => _loadingPublic = true);
    try {
      final nodes = await widget.api.listPublicNodes();
      if (mounted) setState(() => _publicNodes = nodes);
    } catch (_) {}
    if (mounted) setState(() => _loadingPublic = false);
  }

  Future<void> _createNode() async {
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.length < 3) {
      _showSnack('El nombre debe tener al menos 3 caracteres');
      return;
    }
    try {
      final node = await widget.api.createNode(name);
      if (mounted) {
        setState(() => _myNode = node);
        await _loadAdminLists(node);
        _showSnack(l10n.nodeCreated, success: true);
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _joinByCode() async {
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    try {
      final node = await widget.api.joinNodeByCode(code);
      if (mounted) {
        setState(() => _myNode = node);
        await _loadAdminLists(node);
        _showSnack(l10n.nodeJoined, success: true);
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _requestJoin(int nodeId, String name) async {
    try {
      await widget.api.requestJoinNode(nodeId);
      _showSnack('Solicitud enviada a "$name"', success: true);
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _leaveNode() async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.nodeLeave),
        content: const Text('¿Seguro que quieres salir de este nodo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.leave)),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await widget.api.leaveNode();
      if (mounted) {
        setState(() {
          _myNode = null;
          _members = [];
          _joinRequests = [];
        });
        _showSnack(l10n.nodeLeft);
        _loadPublicNodes();
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _deleteNode() async {
    final l10n = AppLocalizations.of(context);
    final node = _myNode;
    if (node == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.nodeDelete),
        content: Text('¿Eliminar permanentemente el nodo "${node['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await widget.api.deleteNode(node['id'] as int);
      if (mounted) {
        setState(() {
          _myNode = null;
          _members = [];
          _joinRequests = [];
        });
        _showSnack(l10n.nodeDeleted, success: true);
        _loadPublicNodes();
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _renameNode() async {
    final l10n = AppLocalizations.of(context);
    final node = _myNode;
    if (node == null) return;
    final controller = TextEditingController(text: node['name']?.toString() ?? '');
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.nodeRename),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.nodeName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    if (newName == null || newName.length < 3) return;
    try {
      final updated = await widget.api.renameNode(node['id'] as int, newName);
      if (mounted) {
        setState(() => _myNode = updated);
        _showSnack(l10n.nodeNameUpdated, success: true);
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _setLogoFrame(String? frame) async {
    final node = _myNode;
    if (node == null) return;
    try {
      final updated = await widget.api.updateNode(
        nodeId: node['id'] as int,
        logoFrame: frame ?? 'none',
      );
      if (mounted) {
        setState(() => _myNode = {...node, ...updated});
        _showSnack('Marco actualizado', success: true);
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _pickAndUploadLogo() async {
    final node = _myNode;
    if (node == null) return;
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image == null) return;
    setState(() => _uploadingLogo = true);
    try {
      final result = await widget.api.uploadNodeLogo(node['id'] as int, image.path);
      if (mounted) {
        setState(() {
          _myNode = {...node, 'logo_url': result['logo_url']};
          _uploadingLogo = false;
        });
        _showSnack('Logo actualizado', success: true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploadingLogo = false);
        _showSnack('Error al subir logo: $e');
      }
    }
  }

  Future<void> _acceptRequest(int requestId) async {
    final node = _myNode;
    if (node == null) return;
    try {
      await widget.api.acceptJoinRequest(node['id'] as int, requestId);
      _showSnack('Solicitud aceptada', success: true);
      await _loadMyNode();
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _rejectRequest(int requestId) async {
    final node = _myNode;
    if (node == null) return;
    try {
      await widget.api.rejectJoinRequest(node['id'] as int, requestId);
      _showSnack('Solicitud rechazada');
      await _loadAdminLists(node);
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _kick(int userId, String username) async {
    final l10n = AppLocalizations.of(context);
    final node = _myNode;
    if (node == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.kickMember),
        content: Text('¿Expulsar a $username del nodo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.kickMember),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.api.kickMember(node['id'] as int, userId);
      _showSnack('$username expulsado', success: true);
      await _loadAdminLists(node);
      await _loadMyNode();
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _transfer(int userId, String username) async {
    final l10n = AppLocalizations.of(context);
    final node = _myNode;
    if (node == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.transferLeadership),
        content: Text(
          '¿Ceder el rol de administrador a $username? Pasarás a ser miembro.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.transferLeadership),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.api.transferLeadership(node['id'] as int, userId);
      _showSnack('Liderazgo transferido a $username', success: true);
      await _loadMyNode();
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  void _showSnack(String msg, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: success ? Colors.green : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadAll, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    if (_myNode != null) return _buildMyNodeView(theme, l10n);
    return _buildNoNodeView(theme, l10n);
  }

  Widget _buildLogo(ThemeData theme, Map<String, dynamic> node, {double size = 64}) {
    final logoUrl = node['logo_url'];
    final frame = node['logo_frame']?.toString();

    final logo = logoUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(size * 0.18),
            child: Image.network(
              '${EcoClockApi.baseUrl}$logoUrl',
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _defaultLogo(theme, size: size),
            ),
          )
        : _defaultLogo(theme, size: size);

    final frameAsset = _frameAsset(frame);
    if (frameAsset != null) {
      return SizedBox(
        width: size * 1.25,
        height: size * 1.25,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size * 0.78,
              height: size * 0.78,
              child: logo,
            ),
            Image.asset(
              frameAsset,
              width: size * 1.25,
              height: size * 1.25,
              fit: BoxFit.contain,
            ),
          ],
        ),
      );
    }

    return logo;
  }

  Widget _defaultLogo(ThemeData theme, {double size = 64}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.18),
      ),
      child: Icon(Icons.groups, color: theme.colorScheme.primary, size: size * 0.5),
    );
  }

  String? _frameAsset(String? frameId) {
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

  Widget _buildMyNodeView(ThemeData theme, AppLocalizations l10n) {
    final node = _myNode!;
    final isAdmin = node['my_role'] == 'admin';
    final unlocked = _unlockedFrames(node);
    final currentFrame = node['logo_frame']?.toString();

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: _loadAll,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildLogo(theme, node),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          node['name'] ?? '',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAdmin ? l10n.roleAdmin : l10n.roleMember,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _infoCard(theme, l10n.nodeMembers, '${node['member_count'] ?? 0}'),
              if (isAdmin) ...[
                const SizedBox(height: 12),
                _infoCard(
                  theme,
                  l10n.inviteLink,
                  node['invite_code'] ?? '',
                  copyable: true,
                ),
                const SizedBox(height: 16),
                Text(l10n.logoFrame, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (unlocked.isEmpty)
                  Text(
                    l10n.completeExpeditionsForFrames,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.noneFrame),
                        selected: currentFrame == null || currentFrame.isEmpty,
                        onSelected: (_) => _setLogoFrame('none'),
                      ),
                      ...unlocked.map((f) {
                        final label = _frameLabels[f] ?? f;
                        return ChoiceChip(
                          label: Text(label),
                          selected: currentFrame == f,
                          onSelected: (_) => _setLogoFrame(f),
                        );
                      }),
                    ],
                  ),
              ],
              if (isAdmin) ...[
                const SizedBox(height: 28),
                Text(l10n.nodeRequests, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (_loadingAdminLists)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_joinRequests.isEmpty)
                  Text(
                    l10n.noPendingRequests,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  ..._joinRequests.map((r) {
                    final username = r['username']?.toString() ?? 'Usuario';
                    final rid = r['id'] as int;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(username),
                        subtitle: Text(l10n.wantsToJoin),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _acceptRequest(rid),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _rejectRequest(rid),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
              const SizedBox(height: 28),
              Text(l10n.nodeMembers, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              if (_loadingAdminLists)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_members.isEmpty)
                Text(
                  'No se pudieron cargar los miembros.',
                  style: theme.textTheme.bodySmall,
                )
              else
                ..._members.map((m) {
                  final username = m['username']?.toString() ?? '';
                  final role = m['role']?.toString() ?? 'member';
                  final uid = m['user_id'] as int;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(username),
                      subtitle: Text(role == 'admin' ? l10n.roleAdmin : l10n.roleMember),
                      trailing: isAdmin && role != 'admin'
                          ? PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'kick') _kick(uid, username);
                                if (v == 'transfer') _transfer(uid, username);
                              },
                              itemBuilder: (ctx) => [
                                PopupMenuItem(
                                  value: 'transfer',
                                  child: Text(l10n.transferLeadership),
                                ),
                                PopupMenuItem(
                                  value: 'kick',
                                  child: Text(l10n.kickMember),
                                ),
                              ],
                            )
                          : null,
                    ),
                  );
                }),
              const SizedBox(height: 32),
              if (isAdmin) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _uploadingLogo ? null : _pickAndUploadLogo,
                    icon: _uploadingLogo
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.image),
                    label: Text(_uploadingLogo ? l10n.uploading : l10n.changeLogo),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _renameNode,
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.nodeRename),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _deleteNode,
                    icon: const Icon(Icons.delete_forever),
                    label: Text(l10n.nodeDelete),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _leaveNode,
                  icon: const Icon(Icons.exit_to_app),
                  label: Text(l10n.nodeLeave),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoNodeView(ThemeData theme, AppLocalizations l10n) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nodos Ciudadanos',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Únete a un nodo o crea el tuyo para colaborar con otros ciudadanos.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text(l10n.nodeCreate, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.nodeName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _createNode,
                icon: const Icon(Icons.add),
                label: Text(l10n.nodeCreate),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            Text(l10n.nodeJoinByCode, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l10n.nodeCode,
                border: const OutlineInputBorder(),
                hintText: 'Ej: QY8RY5LD',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _joinByCode,
                icon: const Icon(Icons.login),
                label: Text(l10n.nodeJoinByCode),
              ),
            ),
            const SizedBox(height: 32),
            Text(l10n.nodePublic, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_loadingPublic)
              const Center(child: CircularProgressIndicator())
            else if (_publicNodes.isEmpty)
              Text(
                'No hay nodos públicos disponibles.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ..._publicNodes.map((n) {
                final name = n['name']?.toString() ?? '';
                final id = n['id'] as int;
                final count = n['member_count'] ?? 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text('$count miembros'),
                    trailing: TextButton(
                      onPressed: () => _requestJoin(id, name),
                      child: Text(l10n.nodeJoinRequest),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(ThemeData theme, String label, String value, {bool copyable = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
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
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                _showSnack('Código copiado', success: true);
              },
            ),
        ],
      ),
    );
  }
}
