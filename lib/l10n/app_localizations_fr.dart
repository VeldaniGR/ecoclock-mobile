// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabTask => 'Tâche';

  @override
  String get tabCredits => 'Crédits';

  @override
  String get tabNode => 'Nœud';

  @override
  String get tabDonate => 'Faire un don';

  @override
  String get tabSettings => 'Paramètres';

  @override
  String welcome(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String userId(String id) {
    return 'ID utilisateur: $id';
  }

  @override
  String get refreshAll => 'Tout actualiser';

  @override
  String get requestTask => 'Demander un devoir';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get taskSent => 'Devoir envoyé correctement';

  @override
  String errorGeneric(String error) {
    return 'Erreur: $error';
  }

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get update => 'Mettre à jour';

  @override
  String get updateDescription =>
      'Vérifier si une nouvelle version est disponible';
}
