// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Inici';

  @override
  String get tabTask => 'Tasca';

  @override
  String get tabCredits => 'Crèdits';

  @override
  String get tabNode => 'Node';

  @override
  String get tabDonate => 'Donar';

  @override
  String get tabSettings => 'Paràmetres';

  @override
  String welcome(String name) {
    return 'Benvingut, $name';
  }

  @override
  String userId(String id) {
    return 'ID de usuari: $id';
  }

  @override
  String get refreshAll => 'Refrescar tot';

  @override
  String get requestTask => 'Demanar tasca';

  @override
  String get logout => 'Tancar sessió';

  @override
  String get taskSent => 'Tasca enviada correctament';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get settingsTitle => 'Paràmetres';

  @override
  String get language => 'Idioma';

  @override
  String version(String version) {
    return 'Versió $version';
  }

  @override
  String get update => 'Actualitzar';

  @override
  String get updateDescription =>
      'Comprovar si hi ha una nova versió disponible';
}
