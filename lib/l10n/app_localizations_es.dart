// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabTask => 'Tarea';

  @override
  String get tabCredits => 'Créditos';

  @override
  String get tabNode => 'Nodo';

  @override
  String get tabDonate => 'Donar';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String welcome(String name) {
    return 'Bienvenido, $name';
  }

  @override
  String userId(String id) {
    return 'ID de usuario: $id';
  }

  @override
  String get refreshAll => 'Refrescar todo';

  @override
  String get requestTask => 'Pedir tarea';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get taskSent => 'Tarea enviada correctamente';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get update => 'Actualizar';

  @override
  String get updateDescription =>
      'Comprobar si hay una nueva versión disponible';
}
