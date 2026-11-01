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

  @override
  String get quickActions => 'Accions ràpides';

  @override
  String get nodeMember => 'Membre del Node';

  @override
  String get expeditionFallback => 'Expedició';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal tasques · $percent%';
  }

  @override
  String get userFallback => 'usuari';

  @override
  String newTask(String type) {
    return 'Tasca nova: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manuals';

  @override
  String get autoTasks => 'Automàtiques';

  @override
  String get taskPayload => 'Dades de la tasca (payload):';

  @override
  String get computeAndSubmit => 'Calcular i enviar';

  @override
  String get noTasksAvailable =>
      'No hi ha tasques disponibles ara mateix.\nTorna-ho a intentar més tard.';

  @override
  String get retry => 'Reintentar';

  @override
  String get taskSentSuccess => 'Tasca enviada correctament';

  @override
  String get totalCredits => 'Total crèdits';

  @override
  String get recentHistory => 'Historial recent';

  @override
  String get noRecentActivity => 'Sense activitat recent';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount crèdits · tasca #$taskId';
  }

  @override
  String get streak => 'Ratxa';

  @override
  String get week => 'Setmana';

  @override
  String get totalTasks => 'Tasques totals';

  @override
  String get updateHistory => 'Actualitzar';

  @override
  String get loginTitle => 'Obrir sessió';

  @override
  String get registerTitle => 'Crear conta';

  @override
  String get loginSubtitle => 'Accedeix a la teva conta de donació de còmput';

  @override
  String get registerSubtitle =>
      'Uneix-te a la xarxa de monitorització ambiental';

  @override
  String get username => 'Usuari';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contrasenya';

  @override
  String get keepSession => 'Romandre amb sessió oberta';

  @override
  String get loginButton => 'Entrar';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get forgotPassword => 'Has oblidat la contrasenya?';

  @override
  String get noAccount => 'No tens compte? Registra\'t';

  @override
  String get hasAccount => 'Ja tens compte? Inicia sessió';

  @override
  String get checkingSession => 'Verificant sessió...';

  @override
  String get donateTitle => 'Recolza Eco\'clock Network';

  @override
  String get donateDescription =>
      'El 95% de la teva donació es destina directament a les ONG associades. El 5% restant s\'utilitza per al manteniment i el desenvolupament de la plataforma.';

  @override
  String get chooseAmount => 'Trieu una quantitat';

  @override
  String get otherAmount => 'Una altra quantitat';

  @override
  String get donateNow => 'Donar ara';

  @override
  String get donateRedirectInfo =>
      'Seràs redirigit a Stripe per completar el pagament de manera segura. Quan tinguem el compte bancari llest, aquest enllaç s\'actualitzarà.';

  @override
  String get paymentLinkError => 'No s\'ha pogut obrir l\'enllaç de pagament';
}
