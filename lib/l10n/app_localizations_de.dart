// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Start';

  @override
  String get tabTask => 'Aufgabe';

  @override
  String get tabCredits => 'Mitwirkende';

  @override
  String get tabNode => 'Knoten';

  @override
  String get tabDonate => 'Spenden';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String welcome(String name) {
    return 'Willkommen, $name';
  }

  @override
  String userId(String id) {
    return 'Benutzer-ID: $id';
  }

  @override
  String get refreshAll => 'Alles aktualisieren';

  @override
  String get requestTask => 'Hausaufgaben anfordern';

  @override
  String get logout => 'Abmelden';

  @override
  String get taskSent => 'Aufgabe erfolgreich übermittelt';

  @override
  String errorGeneric(String error) {
    return 'Fehlermeldung: $error';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get update => 'Aktualisieren';

  @override
  String get updateDescription => 'Prüfen, ob eine neue Version verfügbar ist';
}
