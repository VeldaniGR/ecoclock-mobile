# Eco'clock Network — Cliente Móvil (Flutter)

Cliente móvil nativo para **Android** e **iOS** que consume la API de Eco'clock Network (FastAPI + JWT).

## Características principales

| Función                        | Estado | Notas                                      |
|--------------------------------|--------|--------------------------------------------|
| Registro / Login (JWT)         | ✅     | Persistencia con SharedPreferences         |
| Perfil de usuario              | ✅     | `GET /me`                                  |
| Siguiente tarea + envío        | ✅     | Cálculo local + `POST /tasks/submit`       |
| Sistema de créditos BOINC      | ✅     | Total, racha, semana, historial            |
| Niveles / Badges               | ✅     | Explorador → Sensor → Centinela → Faro     |
| Iconos SVG de niveles          | ✅     | Assets vectoriales escalables              |
| Logros (Achievements)          | ✅     | Primera contribución, hábitats, etc.       |
| Pestaña **Donar**              | ✅     | 95 % ONGs + 5 % mantenimiento (Stripe)     |
| Scroll completo en Créditos    | ✅     | Historial siempre accesible                |
| Dark theme (Material 3)        | ✅     | Paleta dark green + dorado                 |
| CI / Builds Android            | ✅     | APK debug + release + AAB                  |

## Estructura del proyecto

```
ecoclock-mobile/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── api_models.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── worker.dart
│   ├── screens/
│   │   ├── auth_screen.dart
│   │   ├── dashboard_screen.dart      # Tabs: Inicio / Tarea / Créditos / Donar
│   │   ├── donar_screen.dart          # Pantalla de donaciones
│   │   └── creditos_screen.dart       # (legacy / referencia)
│   └── widgets/
│       ├── level_card.dart            # Badge de nivel + SVG
│       ├── stat_card.dart
│       └── json_view.dart
├── assets/
│   └── icons/
│       ├── explorador.svg
│       ├── sensor.svg
│       ├── centinela.svg
│       └── faro.svg
├── android/                           # Generado y versionado
├── ios/
├── .github/workflows/
│   └── flutter-android.yml            # CI: build APK + AAB
├── pubspec.yaml
└── README.md
```

## Niveles del sistema

| Nivel       | ID | Icono SVG          | Color aproximado |
|-------------|----|--------------------|------------------|
| Explorador  | 1  | `explorador.svg`   | Verde oliva      |
| Sensor      | 2  | `sensor.svg`       | Dorado           |
| Centinela   | 3  | `centinela.svg`    | Verde oscuro     |
| Faro        | 4  | `faro.svg`         | Dorado claro     |

Los iconos se cargan dinámicamente según el `level.id` que devuelve la API.

## Pestaña Donar

- Texto transparente: **95 %** de la donación va a las ONGs asociadas, **5 %** se destina al mantenimiento de la plataforma.
- Cantidades rápidas: 5 € · 10 € · 25 € · 50 €
- Campo “Otra cantidad” editable
- Botón “Donar ahora” → abre enlace de Stripe (actualmente simulado)
- Cuando se active la cuenta bancaria real solo hay que cambiar el `stripePaymentLink` en `donar_screen.dart`

## Cómo ejecutar

### Requisitos
- Flutter SDK ≥ 3.27 (Dart ≥ 3.6)
- Android Studio / Xcode o dispositivo físico

```bash
cd ecoclock-mobile
flutter pub get
flutter devices
flutter run
```

### API local (desarrollo)

En `lib/services/api_service.dart`:

```dart
// Emulador Android
static const String baseUrl = 'http://10.0.2.2:8000';

// iOS Simulator
static const String baseUrl = 'http://localhost:8000';

// Dispositivo físico (cambia por tu IP LAN)
static const String baseUrl = 'http://192.168.x.x:8000';
```

## Build de producción

```bash
# APK debug
flutter build apk --debug --split-per-abi

# APK release
flutter build apk --release --split-per-abi

# App Bundle (Play Store)
flutter build appbundle --release
```

Los artefactos se generan también automáticamente en cada push a `main` mediante el workflow de GitHub Actions.

## CI / GitHub Actions

El workflow (`.github/workflows/flutter-android.yml`) realiza:

- `flutter pub get`
- Generación de iconos de launcher
- `flutter analyze`
- Build de APK (debug + release split-per-abi)
- Build de AAB (solo en push a main)
- Subida de artefactos

## Próximos pasos (roadmap)

1. **Gamificación avanzada**  
   - Más logros y recompensas  
   - Sistema de hábitats / misiones

2. **Stripe real**  
   - Payment Links o Checkout Session desde backend

3. **Cómputo real**  
   - Sustituir el worker simulado por lógica NDVI / nativa

4. **Notificaciones push**  
   - FCM / APNs cuando haya nuevas tareas

5. **Background work**  
   - WorkManager (Android) + BGAppRefresh (iOS)

6. **Biometría**  
   - `local_auth` para desbloqueo

7. **Pantalla de Ajustes**  
   - Cambiar baseUrl, ver logs, exportar datos

## Licencia

MIT — igual que el repositorio principal `ecoclock-network`.
