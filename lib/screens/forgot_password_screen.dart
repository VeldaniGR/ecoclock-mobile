// Pantalla: olvidé / restablecer contraseña

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final EcoClockApi api;

  const ForgotPasswordScreen({super.key, required this.api});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailOrUserController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  /// false = pedir email/usuario | true = introducir token + nueva pass
  bool _stepReset = false;
  bool _loading = false;
  String? _message;
  String? _error;

  Future<void> _sendLink() async {
    final value = _emailOrUserController.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Introduce tu email o nombre de usuario');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _message = null;
    });

    try {
      final msg = await widget.api.forgotPassword(emailOrUsername: value);
      if (!mounted) return;
      setState(() {
        _message = msg;
        _stepReset = true;
      });
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Error inesperado: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final token = _tokenController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmController.text;

    if (token.isEmpty) {
      setState(() => _error = 'Pega el código o token del correo');
      return;
    }
    if (pass.length < 8) {
      setState(() => _error = 'La contraseña debe tener al menos 8 caracteres');
      return;
    }
    if (pass != confirm) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _message = null;
    });

    try {
      final msg = await widget.api.resetPassword(
        token: token,
        newPassword: pass,
      );
      if (!mounted) return;
      setState(() => _message = msg);
      // Volver al login tras un momento
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();
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
    _emailOrUserController.dispose();
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ecoTheme = EcoClockThemeExtension.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restablecer contraseña',
          style: GoogleFonts.fraunces(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _stepReset
                    ? 'Introduce el código del correo y tu nueva contraseña'
                    : 'Te enviaremos instrucciones a tu correo',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              if (!_stepReset) ...[
                TextField(
                  controller: _emailOrUserController,
                  decoration: InputDecoration(
                    labelText: 'Email o usuario',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  enabled: !_loading,
                  onSubmitted: (_) => _sendLink(),
                  style: GoogleFonts.workSans(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _loading ? null : _sendLink,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Enviar instrucciones',
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    labelText: 'Código / token del correo',
                    prefixIcon: Icon(Icons.vpn_key_outlined),
                  ),
                  enabled: !_loading,
                  style: GoogleFonts.workSans(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Nueva contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  enabled: !_loading,
                  style: GoogleFonts.workSans(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  enabled: !_loading,
                  onSubmitted: (_) => _resetPassword(),
                  style: GoogleFonts.workSans(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _loading ? null : _resetPassword,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Cambiar contraseña',
                            style: GoogleFonts.workSans(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() {
                            _stepReset = false;
                            _error = null;
                            _message = null;
                          }),
                  child: Text(
                    'Volver a pedir el correo',
                    style: GoogleFonts.workSans(color: ecoTheme.accent),
                  ),
                ),
              ],

              if (_message != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    _message!,
                    style: GoogleFonts.workSans(color: Colors.green.shade200),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
