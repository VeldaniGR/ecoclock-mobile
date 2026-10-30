// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Home';

  @override
  String get tabTask => 'Task';

  @override
  String get tabCredits => 'Credits';

  @override
  String get tabNode => 'Node';

  @override
  String get tabDonate => 'Donate';

  @override
  String get tabSettings => 'Settings';

  @override
  String welcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String userId(String id) {
    return 'User ID: $id';
  }

  @override
  String get refreshAll => 'Refresh all';

  @override
  String get requestTask => 'Request task';

  @override
  String get logout => 'Log out';

  @override
  String get taskSent => 'Task submitted successfully';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get update => 'Update';

  @override
  String get updateDescription => 'Check for a new version';
}
