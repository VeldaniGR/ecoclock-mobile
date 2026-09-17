// Eco'clock Network — Cliente móvil Flutter
//
// Punto de entrada de la aplicación.
// Maneja el estado de autenticación y navega entre AuthScreen y DashboardScreen.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/api_service.dart';

void main() => runApp(const EcoClockApp());

/// Tema claro (día) - basado en el design system de ecoclock.org
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF145560), // teal-600
    brightness: Brightness.light,
    primary: const Color(0xFF145560),
    onPrimary: Colors.white,
    secondary: const Color(0xFFFF8A65), // coral-500
    onSecondary: const Color(0xFF241206),
    surface: const Color(0xFFFFFDF7),
    onSurface: const Color(0xFF1C231B),
    surfaceContainerHighest: const Color(0xFFEFE6CE),
    outline: const Color(0x1E182019),
  ),
  scaffoldBackgroundColor: const Color(0xFFF6F1E3),
  textTheme: GoogleFonts.workSansTextTheme().apply(
    bodyColor: const Color(0xFF1C231B),
    displayColor: const Color(0xFF1C231B),
  ),
  fontFamily: GoogleFonts.workSans().fontFamily,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: CardTheme(
    color: const Color(0xFFFFFDF7),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22), // radius-lg
      side: const BorderSide(color: Color(0x1E182019)),
    ),
    shadowColor: Colors.black26,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFDF7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14), // radius-md
      borderSide: const BorderSide(color: Color(0x1E182019)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0x1E182019)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFFF8A65), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFC9553F)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFFFF8A65), // coral-500
      foregroundColor: const Color(0xFF241206),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14), // radius-md
      ),
      textStyle: GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  extensions: const <ThemeExtension<dynamic>>[
    EcoClockThemeExtension.light,
  ],
);

/// Tema oscuro (noche) - basado en el design system de ecoclock.org
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF9CCB5F), // leaf-400
    brightness: Brightness.dark,
    primary: const Color(0xFF9CCB5F),
    onPrimary: const Color(0xFF0C1712),
    secondary: const Color(0xFFFF8A65), // coral-500
    onSecondary: const Color(0xFF241206),
    surface: const Color(0xFF12201A),
    onSurface: const Color(0xFFEEF2EA),
    surfaceContainerHighest: const Color(0xFF182A21),
    outline: const Color(0x1AEEF2EA),
  ),
  scaffoldBackgroundColor: const Color(0xFF0C1712),
  textTheme: GoogleFonts.workSansTextTheme().apply(
    bodyColor: const Color(0xFFEEF2EA),
    displayColor: const Color(0xFFEEF2EA),
  ),
  fontFamily: GoogleFonts.workSans().fontFamily,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF12201A),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: Color(0x1AEEF2EA)),
    ),
    shadowColor: Colors.black54,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF12201A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0x1AEEF2EA)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0x1AEEF2EA)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF9CCB5F), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFC9553F)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFFFF8A65), // coral-500
      foregroundColor: const Color(0xFF241206),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  extensions: const <ThemeExtension<dynamic>>[
    EcoClockThemeExtension.dark,
  ],
);

/// Tema crepúsculo (dusk) - basado en el design system de ecoclock.org
final ThemeData duskTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF8A65), // coral-500
    brightness: Brightness.dark,
    primary: const Color(0xFFFF8A65),
    onPrimary: const Color(0xFF241206),
    secondary: const Color(0xFF1F8A92), // teal-400
    onSecondary: Colors.white,
    surface: const Color(0xFF362D1F),
    onSurface: const Color(0xFFF3E8CF),
    surfaceContainerHighest: const Color(0xFF41351F),
    outline: const Color(0x24F3E8CF),
  ),
  scaffoldBackgroundColor: const Color(0xFF2B2418),
  textTheme: GoogleFonts.workSansTextTheme().apply(
    bodyColor: const Color(0xFFF3E8CF),
    displayColor: const Color(0xFFF3E8CF),
  ),
  fontFamily: GoogleFonts.workSans().fontFamily,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF362D1F),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: const BorderSide(color: Color(0x24F3E8CF)),
    ),
    shadowColor: Colors.black54,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF362D1F),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0x24F3E8CF)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0x24F3E8CF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFFF8A65), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFC9553F)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFFFF8A65), // coral-500
      foregroundColor: const Color(0xFF241206),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  extensions: const <ThemeExtension<dynamic>>[
    EcoClockThemeExtension.dusk,
  ],
);

/// Extensión de tema personalizada para colores semánticos del design system
class EcoClockThemeExtension extends ThemeExtension<EcoClockThemeExtension> {
  // Colores de marca (fijos independientemente del tema)
  final Color pine950 = const Color(0xFF0A1B13);
  final Color pine900 = const Color(0xFF0F2418);
  final Color pine800 = const Color(0xFF17352A);
  final Color pine600 = const Color(0xFF2F5B41);
  final Color pine400 = const Color(0xFF4D7D5C);
  final Color parchment = const Color(0xFFF3E8CF);
  final Color parchmentDim = const Color(0xFFE7D9B8);
  final Color wood700 = const Color(0xFF6E4526);
  final Color wood500 = const Color(0xFFA06A3F);
  final Color wood300 = const Color(0xFFC99B6A);
  final Color teal800 = const Color(0xFF0D3A41);
  final Color teal600 = const Color(0xFF145560);
  final Color teal400 = const Color(0xFF1F8A92);
  final Color coral500 = const Color(0xFFFF8A65);
  final Color coral400 = const Color(0xFFFFAB91);
  final Color leaf400 = const Color(0xFF9CCB5F);
  final Color gold300 = const Color(0xFFE8CAA0);
  final Color ink = const Color(0xFF182019);
  final Color danger = const Color(0xFFC9553F);

  // Colores semánticos que cambian por tema
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color text;
  final Color textDim;
  final Color border;
  final Color topbarBg;
  final Color accent;
  final Color accentInk;
  final Color scrim;

  const EcoClockThemeExtension._({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.text,
    required this.textDim,
    required this.border,
    required this.topbarBg,
    required this.accent,
    required this.accentInk,
    required this.scrim,
  });

  // Tema día (light)
  static const EcoClockThemeExtension light = EcoClockThemeExtension._(
    bg: Color(0xFFF6F1E3),
    surface: Color(0xFFFFFDF7),
    surface2: Color(0xFFEFE6CE),
    text: Color(0xFF1C231B),
    textDim: Color(0xFF5B6357),
    border: Color(0x1E182019),
    topbarBg: Color(0xD1F6F1E3),
    accent: Color(0xFF145560),
    accentInk: Colors.white,
    scrim: Color(0x140A140F),
  );

  // Tema noche (dark)
  static const EcoClockThemeExtension dark = EcoClockThemeExtension._(
    bg: Color(0xFF0C1712),
    surface: Color(0xFF12201A),
    surface2: Color(0xFF182A21),
    text: Color(0xFFEEF2EA),
    textDim: Color(0xFF9DB3A4),
    border: Color(0x1AEEF2EA),
    topbarBg: Color(0xD10C1712),
    accent: Color(0xFF9CCB5F),
    accentInk: Color(0xFF0C1712),
    scrim: Color(0x8C000000),
  );

  // Tema crepúsculo (dusk)
  static const EcoClockThemeExtension dusk = EcoClockThemeExtension._(
    bg: Color(0xFF2B2418),
    surface: Color(0xFF362D1F),
    surface2: Color(0xFF41351F),
    text: Color(0xFFF3E8CF),
    textDim: Color(0xFFC9B998),
    border: Color(0x24F3E8CF),
    topbarBg: Color(0xD12B2418),
    accent: Color(0xFFFF8A65),
    accentInk: Color(0xFF241206),
    scrim: Color(0x59000000),
  );

  @override
  EcoClockThemeExtension copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? text,
    Color? textDim,
    Color? border,
    Color? topbarBg,
    Color? accent,
    Color? accentInk,
    Color? scrim,
  }) {
    return EcoClockThemeExtension._(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      text: text ?? this.text,
      textDim: textDim ?? this.textDim,
      border: border ?? this.border,
      topbarBg: topbarBg ?? this.topbarBg,
      accent: accent ?? this.accent,
      accentInk: accentInk ?? this.accentInk,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  EcoClockThemeExtension lerp(ThemeExtension<EcoClockThemeExtension>? other, double t) {
    if (other is! EcoClockThemeExtension) return this;
    return EcoClockThemeExtension._(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      text: Color.lerp(text, other.text, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      border: Color.lerp(border, other.border, t)!,
      topbarBg: Color.lerp(topbarBg, other.topbarBg, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentInk: Color.lerp(accentInk, other.accentInk, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }

  /// Obtiene la extensión del tema actual
  static EcoClockThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<EcoClockThemeExtension>() ?? light;
  }
}

class EcoClockApp extends StatelessWidget {
  const EcoClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco\'clock Network',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark, // Forzar tema oscuro por defecto
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
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Verificando sesión...',
                style: GoogleFonts.workSans(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
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