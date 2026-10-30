// Pantalla de Ajustes — idioma, versión y botón Actualizar

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../main.dart'; // para EcoClockApp.setLocale

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '…';
  String _buildNumber = '';

  // Lista de idiomas (mismo orden que la landing)
  static const List<Map<String, String>> _languages = [
    {'code': 'ca', 'name': 'Català'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'eu', 'name': 'Euskera'},
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'it', 'name': 'Italiano'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'zh', 'name': '中文'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'ar', 'name': 'العربية'},
  ];

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = info.version;
          _buildNumber = info.buildNumber;
        });
      }
    } catch (_) {
      // Si falla, dejamos el valor por defecto
    }
  }

  Future<void> _openDownloads() async {
    final uri = Uri.parse('https://download.ecoclock.org');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentLocale = Localizations.localeOf(context).languageCode;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Título
          Text(
            l10n.settingsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),

          // ─── Selector de idioma ────────────────────────────────
          Text(
            l10n.language,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: _languages.map((lang) {
                final isSelected = currentLocale == lang['code'];
                return ListTile(
                  title: Text(lang['name']!),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                      : null,
                  selected: isSelected,
                  onTap: () {
                    EcoClockApp.setLocale(context, Locale(lang['code']!));
                  },
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          // ─── Información de versión ────────────────────────────
          Text(
            l10n.version('$_version${_buildNumber.isNotEmpty ? '+$_buildNumber' : ''}'),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Eco\'clock Network',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 32),

          // ─── Botón Actualizar ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.system_update),
              label: Text(l10n.update),
              onPressed: _openDownloads,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.updateDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
