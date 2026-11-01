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

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get nodeMember => 'Membre du Nœud';

  @override
  String get expeditionFallback => 'Expédition';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal tâches · $percent%';
  }

  @override
  String get userFallback => 'utilisateur';

  @override
  String newTask(String type) {
    return 'Nouvelle tâche: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manuels';

  @override
  String get autoTasks => 'Automatiques';

  @override
  String get taskPayload => 'Données de la tâche (payload):';

  @override
  String get computeAndSubmit => 'Calculer et envoyer';

  @override
  String get noTasksAvailable =>
      'Aucune tâche n\'est disponible pour le moment. Réessayez plus tard.';

  @override
  String get retry => 'Réessayer';

  @override
  String get taskSentSuccess => 'Devoir envoyé correctement';

  @override
  String get totalCredits => 'Total des crédits';

  @override
  String get recentHistory => 'Historique récent';

  @override
  String get noRecentActivity => 'Aucune activité récente';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount crédits · tâche #$taskId';
  }

  @override
  String get streak => 'Série';

  @override
  String get week => 'Semaine';

  @override
  String get totalTasks => 'Total des tâches';

  @override
  String get updateHistory => 'Mettre à jour';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get loginSubtitle =>
      'Accédez à votre compte de dons de matériel informatique';

  @override
  String get registerSubtitle =>
      'Rejoignez le réseau de surveillance environnementale';

  @override
  String get username => 'Utilisateur';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get keepSession => 'Maintenir la session ouverte';

  @override
  String get loginButton => 'Entrer';

  @override
  String get registerButton => 'S\'inscrire';

  @override
  String get forgotPassword => 'Avez-vous oublié votre mot de passe ?';

  @override
  String get noAccount => 'Vous n\'avez pas de compte ? Inscrivez-vous';

  @override
  String get hasAccount => 'Vous avez déjà un compte ? Connectez-vous';

  @override
  String get checkingSession => 'Vérification de la session...';

  @override
  String get donateTitle => 'Soutenez Eco\'clock Network';

  @override
  String get donateDescription =>
      '95 % de votre don est directement reversé aux ONG partenaires. Les 5 % restants servent au maintien et au développement de la plateforme.';

  @override
  String get chooseAmount => 'Choisissez un montant';

  @override
  String get otherAmount => 'Un autre montant';

  @override
  String get donateNow => 'Faire un don maintenant';

  @override
  String get donateRedirectInfo =>
      'Vous serez redirigé vers Stripe pour effectuer le paiement en toute sécurité. Ce lien sera mis à jour une fois le compte bancaire prêt.';

  @override
  String get paymentLinkError => 'Impossible d\'ouvrir le lien de paiement';

  @override
  String get levelExplorer => 'Explorateur';

  @override
  String get levelSensor => 'Capteur';

  @override
  String get levelSentinel => 'Sentinelle';

  @override
  String get levelLighthouse => 'Phare';

  @override
  String nextLevel(String level) {
    return 'Suivant: $level';
  }

  @override
  String streakDays(int days) {
    return 'Série $days d';
  }

  @override
  String get achievementFirstContribution => 'Première contribution';

  @override
  String get achievementWeekActive => 'Semaine active';

  @override
  String get achievementTwoHabitats => 'Deux habitats';

  @override
  String get achievementFirstNode => 'Premier nœud';

  @override
  String get achievementHundredTasks => '100 tâches';

  @override
  String get nodeCreate => 'Créer un nœud';

  @override
  String get nodeJoinByCode => 'Rejoindre avec un code';

  @override
  String get nodeName => 'Nom du nœud';

  @override
  String get nodeCode => 'Code d\'invitation';

  @override
  String get nodeLeave => 'Sortir du nœud';

  @override
  String get nodeDelete => 'Supprimer le nœud';

  @override
  String get nodeRename => 'Renommer le nœud';

  @override
  String get nodeMembers => 'Membres';

  @override
  String get nodeRequests => 'Demandes';

  @override
  String get nodePublic => 'Nœuds publics';

  @override
  String get nodeJoinRequest => 'Demander à rejoindre';

  @override
  String get nodeCreated => 'Nœud créé avec succès';

  @override
  String get nodeJoined => 'Tu as rejoint le nœud';

  @override
  String get nodeLeft => 'Tu es sorti du nœud';

  @override
  String get nodeDeleted => 'Nœud supprimé';

  @override
  String get nodeNameUpdated => 'Nom mis à jour';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get leave => 'Sortir';
}
