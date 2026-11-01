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

  @override
  String get quickActions => 'Azioni rapide';

  @override
  String get nodeMember => 'Membro del nodo';

  @override
  String get expeditionFallback => 'Spedizione';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal compiti · $percent%';
  }

  @override
  String get userFallback => 'utente';

  @override
  String newTask(String type) {
    return 'Nuovo compito: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manuali';

  @override
  String get autoTasks => 'Automatico';

  @override
  String get taskPayload => 'Dati dell\'attività (payload):';

  @override
  String get computeAndSubmit => 'Calcola e invia';

  @override
  String get noTasksAvailable =>
      'Al momento non ci sono attività disponibili. Riprova più tardi.';

  @override
  String get retry => 'Riprova';

  @override
  String get taskSentSuccess => 'Compito inviato correttamente';

  @override
  String get totalCredits => 'Crediti totali';

  @override
  String get recentHistory => 'Storia recente';

  @override
  String get noRecentActivity => 'Nessuna attività recente';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount crediti · incarico #$taskId';
  }

  @override
  String get streak => 'Strisciante';

  @override
  String get week => 'Settimana';

  @override
  String get totalTasks => 'Attività totali';

  @override
  String get updateHistory => 'Aggiornamento';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Creare un account';

  @override
  String get loginSubtitle =>
      'Accedi al tuo account per le donazioni di prodotti informatici';

  @override
  String get registerSubtitle =>
      'Unisciti alla rete di monitoraggio ambientale';

  @override
  String get username => 'Utente';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Password';

  @override
  String get keepSession => 'Mantieni la sessione aperta';

  @override
  String get loginButton => 'Entra';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get forgotPassword => 'Hai dimenticato la password?';

  @override
  String get noAccount => 'Non hai un account? Registrati';

  @override
  String get hasAccount => 'Hai già un account? Accedi';

  @override
  String get checkingSession => 'Verifica della sessione in corso...';

  @override
  String get donateTitle => 'Sostieni la rete Eco\'clock';

  @override
  String get donateDescription =>
      'Il 95% della tua donazione va direttamente alle ONG partner. Il restante 5% viene utilizzato per la manutenzione e lo sviluppo della piattaforma.';

  @override
  String get chooseAmount => 'Scegli un importo';

  @override
  String get otherAmount => 'Un altro importo';

  @override
  String get donateNow => 'Dona ora';

  @override
  String get donateRedirectInfo =>
      'Verrai reindirizzato su Stripe per completare il pagamento in modo sicuro. Una volta che il conto bancario sarà pronto, questo link verrà aggiornato.';

  @override
  String get paymentLinkError =>
      'Non è stato possibile aprire il link di pagamento';
}
