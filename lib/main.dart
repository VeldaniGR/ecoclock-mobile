// Eco'clock Network — Cliente móvil Flutter
//
// Punto de entrada de la aplicación.
// Maneja el estado de autenticación y navega entre AuthScreen y DashboardScreen.

import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/api_service.dart';

void main() => runApp(const EcoClockApp());

class EcoClockApp extends StatelessWidget {
  const EcoClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco\'clock Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF161B22),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white10),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF161B22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.tealAccent[400]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent[400]!),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.tealAccent[400],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

/// Widget que decide qué pantalla mostrar según el estado de autenticación
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _api = EcoClockApi();
  bool _checking = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      await _api.getMe();
      _loggedIn = true;
    } catch (_) {
      _loggedIn = false;
    }
    if (mounted) setState(() => _checking = false);
  }

  void _onAuthSuccess() => setState(() => _loggedIn = true);
  void _onLogout() => setState(() => _loggedIn = false);

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verificando sesión...'),
            ],
          ),
        ),
      );
    }

    return _loggedIn
        ? DashboardScreen(api: _api, onLogout: _onLogout)
        : AuthScreen(api: _api, onSuccess: _onAuthSuccess);
  }
}