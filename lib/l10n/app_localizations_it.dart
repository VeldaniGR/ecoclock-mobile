// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Inizio';

  @override
  String get tabTask => 'Compito';

  @override
  String get tabCredits => 'Crediti';

  @override
  String get tabNode => 'Nodo';

  @override
  String get tabDonate => 'Donare';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String welcome(String name) {
    return 'Benvenuto, $name';
  }

  @override
  String userId(String id) {
    return 'ID utente: $id';
  }

  @override
  String get refreshAll => 'Aggiorna tutto';

  @override
  String get requestTask => 'Chiedi i compiti';

  @override
  String get logout => 'Disconnettiti';

  @override
  String get taskSent => 'Compito inviato correttamente';

  @override
  String errorGeneric(String error) {
    return 'Errore: $error';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String version(String version) {
    return 'Versione $version';
  }

  @override
  String get update => 'Aggiornamento';

  @override
  String get updateDescription =>
      'Verifica se è disponibile una nuova versione';
}
