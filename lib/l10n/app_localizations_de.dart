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

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get nodeMember => 'Mitglied des Knotens';

  @override
  String get expeditionFallback => 'Expedition';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal Aufgaben · $percent%';
  }

  @override
  String get userFallback => 'Benutzer';

  @override
  String newTask(String type) {
    return 'Neue Aufgabe: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manuelle';

  @override
  String get autoTasks => 'Automatische';

  @override
  String get taskPayload => 'Aufgabendaten (Payload):';

  @override
  String get computeAndSubmit => 'Berechnen und senden';

  @override
  String get noTasksAvailable =>
      'Im Moment sind keine Aufgaben verfügbar. Versuche es später noch einmal.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get taskSentSuccess => 'Aufgabe erfolgreich übermittelt';

  @override
  String get totalCredits => 'Gesamt-Credits';

  @override
  String get recentHistory => 'Kürzliche Historie';

  @override
  String get noRecentActivity => 'Keine kürzliche Aktivität';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount Credits · Aufgabe #$taskId';
  }

  @override
  String get streak => 'Glückssträhne';

  @override
  String get week => 'Woche';

  @override
  String get totalTasks => 'Gesamtaufgaben';

  @override
  String get updateHistory => 'Aktualisieren';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get loginSubtitle =>
      'Greifen Sie auf Ihr Konto für Computer-Spenden zu';

  @override
  String get registerSubtitle =>
      'Schließe dich dem Netzwerk zur Umweltüberwachung an';

  @override
  String get username => 'Benutzer';

  @override
  String get email => 'Email';

  @override
  String get password => 'Passwort';

  @override
  String get keepSession => 'Angemeldet bleiben';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get registerButton => 'Registrieren';

  @override
  String get forgotPassword => 'Hast du dein Passwort vergessen?';

  @override
  String get noAccount => 'Hast du kein Konto? Registriere dich';

  @override
  String get hasAccount => 'Hast du schon ein Konto? Melde dich an.';

  @override
  String get checkingSession => 'Sitzung wird überprüft...';

  @override
  String get donateTitle => 'Unterstütze das Eco\'clock Network';

  @override
  String get donateDescription =>
      '95 % deiner Spende fließen direkt an die Partner-NGOs. Die restlichen 5 % werden für den Unterhalt und die Weiterentwicklung der Plattform verwendet.';

  @override
  String get chooseAmount => 'Wähle eine Menge';

  @override
  String get otherAmount => 'Ein anderer Betrag';

  @override
  String get donateNow => 'Jetzt spenden';

  @override
  String get donateRedirectInfo =>
      'Du wirst zu Stripe weitergeleitet, um die Zahlung sicher abzuschließen. Sobald das Bankkonto bereitsteht, wird dieser Link aktualisiert.';

  @override
  String get paymentLinkError =>
      'Der Zahlungslink konnte nicht geöffnet werden.';

  @override
  String get levelExplorer => 'Entdecker';

  @override
  String get levelSensor => 'Sensor';

  @override
  String get levelSentinel => 'Wächter';

  @override
  String get levelLighthouse => 'Leuchtturm';

  @override
  String nextLevel(String level) {
    return 'Nächstes: $level';
  }

  @override
  String streakDays(int days) {
    return 'Glückssträhne $days d';
  }

  @override
  String get achievementFirstContribution => 'Erster Beitrag';

  @override
  String get achievementWeekActive => 'Aktive Woche';

  @override
  String get achievementTwoHabitats => 'Zwei Lebensräume';

  @override
  String get achievementFirstNode => 'Erster Knoten';

  @override
  String get achievementHundredTasks => '100 Aufgaben';

  @override
  String get nodeCreate => 'Knoten erstellen';

  @override
  String get nodeJoinByCode => 'Mit Code beitreten';

  @override
  String get nodeName => 'Knotenname';

  @override
  String get nodeCode => 'Einladungscode';

  @override
  String get nodeLeave => 'Den Knoten verlassen';

  @override
  String get nodeDelete => 'Knoten löschen';

  @override
  String get nodeRename => 'Knoten umbenennen';

  @override
  String get nodeMembers => 'Mitglieder';

  @override
  String get nodeRequests => 'Anträge';

  @override
  String get nodePublic => 'Öffentliche Knoten';

  @override
  String get nodeJoinRequest => 'Beitritt beantragen';

  @override
  String get nodeCreated => 'Knoten erfolgreich erstellt';

  @override
  String get nodeJoined => 'Du bist dem Knoten beigetreten.';

  @override
  String get nodeLeft => 'Du hast den Knoten verlassen.';

  @override
  String get nodeDeleted => 'Knoten gelöscht';

  @override
  String get nodeNameUpdated => 'Aktualisierter Name';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get leave => 'Beenden';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleMember => 'Mitglied';

  @override
  String get logoFrame => 'Logo-Rahmen';

  @override
  String get noPendingRequests => 'Es liegen keine ausstehenden Anträge vor.';

  @override
  String get changeLogo => 'Logo ändern';

  @override
  String get transferLeadership => 'Führung übertragen';

  @override
  String get kickMember => 'Ausweisen';

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String get maxLevel => 'Maximales Niveau';

  @override
  String get noneFrame => 'Keiner';

  @override
  String get uploading => 'Wird hochgeladen...';

  @override
  String get wantsToJoin => 'Möchte sich anschließen.';

  @override
  String get inviteLink => 'Verbindungsglied';

  @override
  String get completeExpeditionsForFrames =>
      'Schließe Expeditionen ab, um Rahmen freizuschalten.';
}
