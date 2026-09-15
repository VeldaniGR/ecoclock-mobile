# Eco'clock Network — Cliente Móvil (Flutter)

Cliente móvil nativo para Android e iOS que consume la API de Eco'clock Network (FastAPI + JWT).

## 📱 Características

| Función | Endpoint | Estado |
|---------|----------|--------|
| Registro de usuario | `POST /auth/register` | ✅ |
| Login (JWT) | `POST /auth/login` | ✅ |
| Perfil usuario | `GET /me` | ✅ |
| Siguiente tarea | `GET /tasks/next` | ✅ |
| Enviar resultado | `POST /tasks/submit` | ✅ (simulado) |
| Créditos BOINC | `GET /credits/me` | ✅ |
| Logout | Local (borra token) | ✅ |
| Persistencia sesión | `SharedPreferences` | ✅ |

## 🏗️ Estructura del proyecto

```
ecoclock_mobile/
├── lib/
│   ├── main.dart                 # Entry point + AuthGate
│   ├── models/
│   │   └── api_models.dart       # Modelos tipados (UserResponse, TaskNextResponse, CreditsSummary)
│   ├── services/
│   │   └── api_service.dart      # EcoClockApi (HTTP + JWT persistence)
│   ├── screens/
│   │   ├── auth_screen.dart      # Login / Registro
│   │   └── dashboard_screen.dart # Tabs: Inicio / Tarea / Créditos
│   └── widgets/
│       └── json_view.dart        # Visor JSON formateado
├── pubspec.yaml                  # Dependencias
└── README.md                     # Este archivo
```

## 🚀 Cómo ejecutar

### Requisitos previos
- Flutter SDK ≥ 3.19 (Dart ≥ 3.3)
- Android Studio / Xcode para emuladores
- O dispositivo físico con depuración USB

### Pasos

```bash
# 1. Entrar al directorio
cd ecoclock_mobile

# 2. Instalar dependencias
flutter pub get

# 3. Verificar dispositivos disponibles
flutter devices

# 4. Ejecutar en emulador/dispositivo
flutter run
```

### Para desarrollo local (API en localhost)

Edita `lib/services/api_service.dart` y cambia:

```dart
static const String baseUrl = 'https://api.ecoclock.org';
```

Por tu IP local (ej. `http://192.168.1.XXX:8000`) o usa `10.0.2.2` en emulador Android:

```dart
static const String baseUrl = 'http://10.0.2.2:8000'; // Emulador Android → localhost host
```

> **Nota:** En iOS Simulator usa `http://localhost:8000`. En dispositivo físico usa la IP LAN de tu máquina.

## 🔧 Configuración de la API

La app espera que el servidor exponga estos endpoints (ya implementados en `ecoclock-network/server`):

```
POST   /auth/register     {email, password} → {access_token, user}
POST   /auth/login        {email, password} → {access_token, user}
GET    /me                         → UserResponse
GET    /tasks/next                 → TaskNextResponse
POST   /tasks/submit    {task_id, output} → 200 OK
GET    /credits/me                 → CreditsSummary
GET    /health                     → 200 OK (sin auth)
```

## 📦 Build para distribución

### Android (APK / AAB)
```bash
# APK debug
flutter build apk --debug

# APK release
flutter build apk --release

# App Bundle (para Play Store)
flutter build appbundle --release
```

Salida: `build/app/outputs/flutter-apk/` o `build/app/outputs/bundle/release/`

### iOS (IPA)
```bash
# Requiere macOS + Xcode
flutter build ios --release
# Luego: Product → Archive en Xcode
```

## 🎨 Temas y personalización

El tema se define en `lib/main.dart`:
- **Material 3** activado
- **Dark mode** por defecto (color seed: Teal)
- Colores personalizados: `Color(0xFF0D1117)` background, `Color(0xFF161B22)` cards

Para cambiar colores, modifica `ColorScheme.fromSeed(seedColor: Colors.teal, ...)`.

## 🔄 Próximos pasos (para versión final)

1. **Cómputo real**: Reemplazar `_submitDummyTask()` en `dashboard_screen.dart` por lógica NDVI/nativa
2. **Notificaciones push**: FCM / APNs para avisar cuando hay tareas nuevas
3. **Background fetch**: WorkManager (Android) / BGAppRefresh (iOS) para cómputo en segundo plano
4. **Biometría**: `local_auth` para proteger la app con huella/FaceID
5. **Settings**: Pantalla para cambiar `baseUrl`, ver logs, exportar datos
6. **Tests**: `flutter test` + integration tests con `integration_test`

## 📄 Licencia

MIT — igual que el repositorio principal `ecoclock-network`.