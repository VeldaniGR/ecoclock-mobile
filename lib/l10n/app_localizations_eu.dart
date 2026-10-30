// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Hasi';

  @override
  String get tabTask => 'Ataza';

  @override
  String get tabCredits => 'Kredituak';

  @override
  String get tabNode => 'Nodoa';

  @override
  String get tabDonate => 'Eman dohaintza';

  @override
  String get tabSettings => 'Ezarpenak';

  @override
  String welcome(String name) {
    return 'Ongi etorri, $name';
  }

  @override
  String userId(String id) {
    return 'Erabiltzaile-identifikatzailea: $id';
  }

  @override
  String get refreshAll => 'Freskatu dena';

  @override
  String get requestTask => 'Eskatu etxeko lanak';

  @override
  String get logout => 'Saioa itxi';

  @override
  String get taskSent => 'Zeregina behar bezala bidali da';

  @override
  String errorGeneric(String error) {
    return 'Akatsa: $error';
  }

  @override
  String get settingsTitle => 'Ezarpenak';

  @override
  String get language => 'Hizkuntza';

  @override
  String version(String version) {
    return 'Bertsioa $version';
  }

  @override
  String get update => 'Eguneratu';

  @override
  String get updateDescription =>
      'Egiaztatu bertsio berri bat eskuragarri dagoen';
}
