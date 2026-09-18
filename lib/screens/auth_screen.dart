// Pantalla de autenticación (Login / Registro)

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../main.dart'; // Para EcoClockThemeExtension

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
      setState(() => _error = 'Error inesperado: $e');
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eco\'clock Network',
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
                  _isLogin ? 'Iniciar sesión' : 'Crear cuenta',
                  style: GoogleFonts.fraunces(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? 'Accede a tu cuenta de donación de cómputo'
                      : 'Únete a la red de monitorización ambiental',
                  style: GoogleFonts.workSans(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Username (siempre)
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
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

                // Email (solo en registro)
                if (!_isLogin) ...[
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                    labelText: 'Contraseña',
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

                // Checkbox mantener sesión
                CheckboxListTile(
                  value: _keepSession,
                  onChanged: _loading
                      ? null
                      : (v) => setState(() => _keepSession = v ?? true),
                  title: Text(
                    'Mantener sesión abierta',
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
                            _isLogin ? 'Entrar' : 'Registrarse',
                            style: GoogleFonts.workSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cambiar modo
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? '¿No tienes cuenta? Regístrate'
                        : '¿Ya tienes cuenta? Inicia sesión',
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