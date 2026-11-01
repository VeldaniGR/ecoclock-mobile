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

  @override
  String get quickActions => 'Ekintza azkarrak';

  @override
  String get nodeMember => 'Nodo-kidea';

  @override
  String get expeditionFallback => 'Espedizioa';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal zereginak · $percent%';
  }

  @override
  String get userFallback => 'erabiltzailea';

  @override
  String newTask(String type) {
    return 'Zeregin berria: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Eskuzko';

  @override
  String get autoTasks => 'Automatikoa';

  @override
  String get taskPayload => 'Ataza-datuak (karga):';

  @override
  String get computeAndSubmit => 'Kalkulatu eta bidali';

  @override
  String get noTasksAvailable =>
      'Une honetan ez dago zereginik eskuragarri. Mesedez, saiatu berriro geroago.';

  @override
  String get retry => 'Saiatu berriro';

  @override
  String get taskSentSuccess => 'Zeregina behar bezala bidali da';

  @override
  String get totalCredits => 'Kreditu-kopuru osoa';

  @override
  String get recentHistory => 'Azkenaldiko historia';

  @override
  String get noRecentActivity => 'Azkenaldiko jarduerarik ez';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount kredituak · zeregina #$taskId';
  }

  @override
  String get streak => 'Segida';

  @override
  String get week => 'Astea';

  @override
  String get totalTasks => 'Zeregin guztiak';

  @override
  String get updateHistory => 'Eguneratu';

  @override
  String get loginTitle => 'Saioa hasi';

  @override
  String get registerTitle => 'Sortu kontua';

  @override
  String get loginSubtitle => 'Sartu zure informatika-dohaintzen kontuan';

  @override
  String get registerSubtitle => 'Bat egin ingurumen-jarraipeneko sarearekin';

  @override
  String get username => 'Erabiltzailea';

  @override
  String get email => 'Posta elektronikoa';

  @override
  String get password => 'Pasahitza';

  @override
  String get keepSession => 'Mantendu saioa irekita';

  @override
  String get loginButton => 'Sartu';

  @override
  String get registerButton => 'Erregistratu';

  @override
  String get forgotPassword => 'Pasahitza ahaztu duzu?';

  @override
  String get noAccount => 'Ez duzu konturik? Eman izena';

  @override
  String get hasAccount => 'Baduzu konturik? Hasi saioa';

  @override
  String get checkingSession => 'Saioa egiaztatzen...';

  @override
  String get donateTitle => 'Babestu Eco\'clock Network';

  @override
  String get donateDescription =>
      'Zure dohaintzaren % 95 zuzenean bazkide diren GKEetara bideratzen da. Gainerako % 5a plataforma mantentzeko eta garatzeko erabiltzen da.';

  @override
  String get chooseAmount => 'Aukeratu zenbateko bat';

  @override
  String get otherAmount => 'Beste kopuru bat';

  @override
  String get donateNow => 'Egin dohaintza orain';

  @override
  String get donateRedirectInfo =>
      'Stripe-ra bideratuko zaitugu, ordainketa modu seguruan burutzeko. Banku-kontua prest dagoenean, esteka hau eguneratu egingo da.';

  @override
  String get paymentLinkError => 'Ezin izan da ordainketa-esteka ireki';
}
