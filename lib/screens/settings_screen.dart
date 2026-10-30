// Pantalla de Ajustes — idioma (dropdown), versión y botón Actualizar

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
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currentLocale = Localizations.localeOf(context).languageCode;

    // Aseguramos que el valor del dropdown exista en la lista
    final validCodes = _languages.map((e) => e['code']!).toList();
    final selectedCode = validCodes.contains(currentLocale)
        ? currentLocale
        : 'es';

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          // Título
          Text(
            l10n.settingsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),

          // ─── Selector de idioma (Dropdown) ─────────────────────
          Text(
            l10n.language,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCode,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                dropdownColor: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                items: _languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['code'],
                    child: Text(
                      lang['name']!,
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }).toList(),
                onChanged: (String? newCode) {
                  if (newCode != null) {
                    EcoClockApp.setLocale(context, Locale(newCode));
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 40),

          // ─── Información de versión ────────────────────────────
          Text(
            l10n.version(
              '$_version${_buildNumber.isNotEmpty ? '+$_buildNumber' : ''}',
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Eco\'clock Network',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 36),

          // ─── Botón Actualizar ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              icon: const Icon(Icons.system_update_alt, size: 22),
              label: Text(
                l10n.update,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: _openDownloads,
            ),
          ),
          const SizedBox(height: 12),
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
