// Pantalla de autenticación (Login / Registro) + selector de idioma

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../main.dart'; // EcoClockThemeExtension + EcoClockApp.setLocale
import '../services/api_service.dart';
import 'forgot_password_screen.dart';

class AuthScreen extends StatefulWidget {
  final EcoClockApi api;
  final VoidCallback onSuccess;

  const AuthScreen({
    super.key,
    required this.api,
    required this.onSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _keepSession = true;
  String? _error;
  bool _loading = false;

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

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      if (_isLogin) {
        await widget.api.login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          keepSession: _keepSession,
        );
      } else {
        await widget.api.register(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          keepSession: _keepSession,
        );
      }
      widget.onSuccess();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ecoTheme = EcoClockThemeExtension.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final currentLocale = Localizations.localeOf(context).languageCode;

    final validCodes = _languages.map((e) => e['code']!).toList();
    final selectedCode = validCodes.contains(currentLocale) ? currentLocale : 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: GoogleFonts.fraunces(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: colorScheme.onSurface,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/logo.svg',
            colorFilter: ColorFilter.mode(
              ecoTheme.accent,
              BlendMode.srcIn,
            ),
          ),
        ),
        actions: [
          // ─── Selector de idioma ────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCode,
                icon: Icon(
                  Icons.language,
                  color: colorScheme.onSurfaceVariant,
                ),
                dropdownColor: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                items: _languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['code'],
                    child: Text(
                      lang['name']!,
                      style: theme.textTheme.bodyMedium,
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
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: 80,
                  height: 80,
                  colorFilter: ColorFilter.mode(
                    ecoTheme.accent,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  _isLogin ? l10n.loginTitle : l10n.registerTitle,
                  style: GoogleFonts.fraunces(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin ? l10n.loginSubtitle : l10n.registerSubtitle,
                  style: GoogleFonts.workSans(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: l10n.username,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  enabled: !_loading,
                  style: GoogleFonts.workSans(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 16),

                // Email (solo registro)
                if (!_isLogin) ...[
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_loading,
                    style: GoogleFonts.workSans(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 16),
                ],

                // Contraseña
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  enabled: !_loading,
                  onSubmitted: (_) => _submit(),
                  style: GoogleFonts.workSans(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 12),

                // Mantener sesión
                CheckboxListTile(
                  value: _keepSession,
                  onChanged: _loading
                      ? null
                      : (v) => setState(() => _keepSession = v ?? true),
                  title: Text(
                    l10n.keepSession,
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: ecoTheme.accent,
                ),

                // Error
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _error!,
                      style: GoogleFonts.workSans(
                        color: colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Botón principal
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF241206)),
                            ),
                          )
                        : Text(
                            _isLogin ? l10n.loginButton : l10n.registerButton,
                            style: GoogleFonts.workSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Olvidé contraseña
                if (_isLogin) ...[
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ForgotPasswordScreen(api: widget.api),
                              ),
                            );
                          },
                    child: Text(
                      l10n.forgotPassword,
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                // Cambiar modo
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin ? l10n.noAccount : l10n.hasAccount,
                    style: GoogleFonts.workSans(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
