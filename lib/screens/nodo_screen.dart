import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
      if (mounted) setState(() {
        _members = [];
        _joinRequests = [];
      });
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
        _showSnack('Nodo creado correctamente', success: true);
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _joinByCode() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    try {
      final node = await widget.api.joinNodeByCode(code);
      if (mounted) {
        setState(() => _myNode = node);
        await _loadAdminLists(node);
        _showSnack('Te has unido al nodo', success: true);
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Salir del nodo'),
        content: const Text('¿Seguro que quieres salir de este nodo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salir')),
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
        _showSnack('Has salido del nodo');
        _loadPublicNodes();
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _deleteNode() async {
    final node = _myNode;
    if (node == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nodo'),
        content: Text('¿Eliminar permanentemente el nodo "${node['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
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
        _showSnack('Nodo eliminado', success: true);
        _loadPublicNodes();
      }
    } catch (e) {
      _showSnack('Error: $e');
    }
  }

  Future<void> _renameNode() async {
    final node = _myNode;
    if (node == null) return;
    final controller = TextEditingController(text: node['name']?.toString() ?? '');
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renombrar nodo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nuevo nombre',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (newName == null || newName.length < 3) return;
    try {
      final updated = await widget.api.renameNode(node['id'] as int, newName);
      if (mounted) {
        setState(() => _myNode = updated);
        _showSnack('Nombre actualizado', success: true);
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
    final node = _myNode;
    if (node == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Expulsar miembro'),
        content: Text('¿Expulsar a $username del nodo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Expulsar'),
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
    final node = _myNode;
    if (node == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transferir liderazgo'),
        content: Text(
          '¿Ceder el rol de administrador a $username? Pasarás a ser miembro.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Transferir')),
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
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadAll, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    if (_myNode != null) return _buildMyNodeView(theme);
    return _buildNoNodeView(theme);
  }

  Widget _buildLogo(ThemeData theme, Map<String, dynamic> node) {
    final logoUrl = node['logo_url'];
    final frame = node['logo_frame']?.toString();
    final child = logoUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              '${EcoClockApi.baseUrl}$logoUrl',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _defaultLogo(theme),
            ),
          )
        : _defaultLogo(theme);

    if (frame == 'autumn_fungi') {
      return Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC4A35A), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC4A35A).withValues(alpha: 0.4),
              blurRadius: 8,
            ),
          ],
        ),
        child: child,
      );
    }
    return child;
  }

  Widget _buildMyNodeView(ThemeData theme) {
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
                          isAdmin ? 'Administrador' : 'Miembro',
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
              _infoCard(theme, 'Miembros', '${node['member_count'] ?? 0}'),
              if (isAdmin) ...[
                const SizedBox(height: 12),
                _infoCard(
                  theme,
                  'Enlace de unión',
                  node['invite_code'] ?? '',
                  copyable: true,
                ),
                const SizedBox(height: 16),
                Text('Marco del logo', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (unlocked.isEmpty)
                  Text(
                    'Completa expediciones para desbloquear marcos.',
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
                        label: const Text('Ninguno'),
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
                Text('Solicitudes pendientes', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                if (_loadingAdminLists)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_joinRequests.isEmpty)
                  Text(
                    'No hay solicitudes pendientes.',
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
                        subtitle: const Text('Quiere unirse'),
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
              Text('Miembros del nodo', style: theme.textTheme.titleMedium),
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
                      subtitle: Text(role == 'admin' ? 'Administrador' : 'Miembro'),
                      trailing: isAdmin && role != 'admin'
                          ? PopupMenuButton<String>(
                              onSelected: (v) {
                                if (v == 'kick') _kick(uid, username);
                                if (v == 'transfer') _transfer(uid, username);
                              },
                              itemBuilder: (ctx) => const [
                                PopupMenuItem(value: 'transfer', child: Text('Transferir liderazgo')),
                                PopupMenuItem(value: 'kick', child: Text('Expulsar')),
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
                    label: Text(_uploadingLogo ? 'Subiendo...' : 'Cambiar logo'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _renameNode,
                    icon: const Icon(Icons.edit),
                    label: const Text('Renombrar nodo'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _deleteNode,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Eliminar nodo'),
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
                  label: const Text('Salir del nodo'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoNodeView(ThemeData theme) {
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
            Text('Crear un nodo', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del nodo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _createNode,
                icon: const Icon(Icons.add),
                label: const Text('Crear nodo'),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            Text('Unirse con enlace de unión', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Código de invitación',
                border: OutlineInputBorder(),
                hintText: 'Ej: QY8RY5LD',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _joinByCode,
                icon: const Icon(Icons.login),
                label: const Text('Unirse al nodo'),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            Text('Explorar nodos públicos', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_loadingPublic)
              const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ))
            else if (_publicNodes.isEmpty)
              Text(
                'No hay nodos públicos todavía.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              ..._publicNodes.map((n) => _publicNodeCard(theme, n)),
          ],
        ),
      ),
    );
  }

  Widget _publicNodeCard(ThemeData theme, dynamic n) {
    final name = n['name'] ?? '';
    final count = n['member_count'] ?? 0;
    final logoUrl = n['logo_url'];
    final id = n['id'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
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
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.groups, color: theme.colorScheme.primary),
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
                Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text('$count miembros', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () => _requestJoin(id, name),
            child: const Text('Solicitar'),
          ),
        ],
      ),
    );
  }

  Widget _defaultLogo(ThemeData theme) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.groups, size: 32, color: theme.colorScheme.primary),
    );
  }

  Widget _infoCard(ThemeData theme, String label, String value, {bool copyable = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
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
                _showSnack('Código copiado');
              },
            ),
        ],
      ),
    );
  }
}
