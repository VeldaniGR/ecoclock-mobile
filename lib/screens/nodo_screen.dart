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
  bool _loading = true;
  bool _loadingPublic = false;
  bool _uploadingLogo = false;
  String? _error;

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _picker = ImagePicker();

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
      if (mounted) setState(() => _myNode = node);
    } catch (e) {
      if (mounted) {
        setState(() {
          _myNode = null;
          if (!e.toString().contains('404')) _error = e.toString();
        });
      }
    }
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
        setState(() => _myNode = null);
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
        content: Text('¿Eliminar permanentemente el nodo "${node['name']}"? Esta acción no se puede deshacer.'),
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
        setState(() => _myNode = null);
        _showSnack('Nodo eliminado', success: true);
        _loadPublicNodes();
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

  Widget _buildMyNodeView(ThemeData theme) {
    final node = _myNode!;
    final isAdmin = node['my_role'] == 'admin';
    final logoUrl = node['logo_url'];

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (logoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '${EcoClockApi.baseUrl}$logoUrl',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultLogo(theme),
                    ),
                  )
                else
                  _defaultLogo(theme),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node['name'] ?? '',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isAdmin ? 'Administrador' : 'Miembro',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
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
              _infoCard(theme, 'Enlace de unión', node['invite_code'] ?? '', copyable: true),
            ],
            const SizedBox(height: 32),
            if (isAdmin) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _uploadingLogo ? null : _pickAndUploadLogo,
                  icon: _uploadingLogo
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.image),
                  label: Text(_uploadingLogo ? 'Subiendo...' : 'Cambiar logo'),
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
            Text('Nodos Ciudadanos', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Únete a un nodo o crea el tuyo para colaborar con otros ciudadanos.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            Text('Crear un nodo', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del nodo', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(onPressed: _createNode, icon: const Icon(Icons.add), label: const Text('Crear nodo')),
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
              child: OutlinedButton.icon(onPressed: _joinByCode, icon: const Icon(Icons.login), label: const Text('Unirse al nodo')),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            Text('Explorar nodos públicos', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_loadingPublic)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (_publicNodes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No hay nodos públicos todavía. ¡Sé el primero en crear uno!',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                errorBuilder: (_, __, ___) => Icon(Icons.groups, color: theme.colorScheme.primary),
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
                Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
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
