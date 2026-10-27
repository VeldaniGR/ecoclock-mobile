import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class NodoScreen extends StatefulWidget {
  final EcoClockApi api;

  const NodoScreen({super.key, required this.api});

  @override
  State<NodoScreen> createState() => _NodoScreenState();
}

class _NodoScreenState extends State<NodoScreen> {
  Map<String, dynamic>? _myNode;
  bool _loading = true;
  String? _error;

  // Controllers
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMyNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadMyNode() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final node = await widget.api.getMyNode();
      if (mounted) {
        setState(() {
          _myNode = node;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _myNode = null;
          _loading = false;
          // 404 = no tiene nodo, no es error real
          if (!e.toString().contains('404')) {
            _error = e.toString();
          }
        });
      }
    }
  }

  Future<void> _createNode() async {
    final name = _nameController.text.trim();
    if (name.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre debe tener al menos 3 caracteres')),
      );
      return;
    }
    try {
      final node = await widget.api.createNode(name);
      if (mounted) {
        setState(() => _myNode = node);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nodo creado correctamente'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _joinByCode() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    try {
      final node = await widget.api.joinNodeByCode(code);
      if (mounted) {
        setState(() => _myNode = node);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Te has unido al nodo'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Has salido del nodo')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadMyNode, child: const Text('Reintentar')),
          ],
        ),
      );
    }

    // ========== TIENE NODO ==========
    if (_myNode != null) {
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
              // Header con logo
              Row(
                children: [
                  if (logoUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'http://localhost:8000$logoUrl', // TODO: usar baseUrl real
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultLogo(),
                      ),
                    )
                  else
                    _defaultLogo(),
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

              // Info
              _infoCard(theme, 'Miembros', '${node['member_count'] ?? 0}'),
              const SizedBox(height: 12),

              if (isAdmin) ...[
                _infoCard(
                  theme,
                  'Enlace de unión',
                  node['invite_code'] ?? '',
                  copyable: true,
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 32),

              // Acciones
              if (isAdmin)
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: subir logo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Subida de logo próximamente')),
                    );
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Cambiar logo'),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _leaveNode,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Salir del nodo'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        ),
      );
    }

    // ========== NO TIENE NODO ==========
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

            // Crear nodo
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

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 24),

            // Unirse por código
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
          ],
        ),
      ),
    );
  }

  Widget _defaultLogo() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.groups, size: 32, color: Colors.green),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Código copiado')),
                );
              },
            ),
        ],
      ),
    );
  }
}
