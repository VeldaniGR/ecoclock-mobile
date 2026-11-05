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

  @override
  String get levelExplorer => 'Esploratore';

  @override
  String get levelSensor => 'Sensore';

  @override
  String get levelSentinel => 'Sentinella';

  @override
  String get levelLighthouse => 'Faro';

  @override
  String nextLevel(String level) {
    return 'Seguente: $level';
  }

  @override
  String streakDays(int days) {
    return 'Strisciante $days d';
  }

  @override
  String get achievementFirstContribution => 'Primo contributo';

  @override
  String get achievementWeekActive => 'Settimana attiva';

  @override
  String get achievementTwoHabitats => 'Due habitat';

  @override
  String get achievementFirstNode => 'Primo nodo';

  @override
  String get achievementHundredTasks => '100 attività';

  @override
  String get nodeCreate => 'Crea nodo';

  @override
  String get nodeJoinByCode => 'Partecipa con un codice';

  @override
  String get nodeName => 'Nome del nodo';

  @override
  String get nodeCode => 'Codice invito';

  @override
  String get nodeLeave => 'Esci dal nodo';

  @override
  String get nodeDelete => 'Elimina nodo';

  @override
  String get nodeRename => 'Rinomina nodo';

  @override
  String get nodeMembers => 'Membri';

  @override
  String get nodeRequests => 'Applicazioni';

  @override
  String get nodePublic => 'Nodi pubblici';

  @override
  String get nodeJoinRequest => 'Richiesta di partecipazione';

  @override
  String get nodeCreated => 'Nodo creato correttamente';

  @override
  String get nodeJoined => 'Ti sei unito al nodo';

  @override
  String get nodeLeft => 'Hai abbandonato il nodo';

  @override
  String get nodeDeleted => 'Nodo eliminato';

  @override
  String get nodeNameUpdated => 'Nome aggiornato';

  @override
  String get cancel => 'Cancellare';

  @override
  String get confirm => 'Confermare';

  @override
  String get save => 'Mantenere';

  @override
  String get delete => 'Eliminare';

  @override
  String get leave => 'Esci';

  @override
  String get roleAdmin => 'Amministratore';

  @override
  String get roleMember => 'Membro';

  @override
  String get logoFrame => 'Cornice per logo';

  @override
  String get noPendingRequests => 'Non ci sono richieste in sospeso.';

  @override
  String get changeLogo => 'Cambia logo';

  @override
  String get transferLeadership => 'Trasferire la leadership';

  @override
  String get kickMember => 'Espellere';

  @override
  String get achievementsTitle => 'Traguardi';

  @override
  String get maxLevel => 'Livello massimo';

  @override
  String get noneFrame => 'Nessuno';

  @override
  String get uploading => 'Caricamento in corso...';

  @override
  String get wantsToJoin => 'Vuole unirsi';

  @override
  String get inviteLink => 'Anello di collegamento';

  @override
  String get completeExpeditionsForFrames =>
      'Completa le spedizioni per sbloccare i telai.';

  @override
  String get navigatorBannerReady => 'La busta del tuo navigatore è pronta';

  @override
  String get navigatorBannerSent =>
      'Busta inviata: completa l\'attività esterna';

  @override
  String get navigatorBannerValidated =>
      'Attività all\'aperto convalidata: navigatore tra i ghiacci!';

  @override
  String get navigatorSendButton => 'Inviare busta';

  @override
  String get navigatorResendButton => 'Inoltrare busta';

  @override
  String get navigatorSending => 'Invio in corso…';

  @override
  String get navigatorSentSuccess => 'Busta inviata! Controlla la tua email.';

  @override
  String navigatorSendError(String error) {
    return 'Errore durante l\'invio della busta: $error';
  }

  @override
  String navigatorHexTasksCounter(
      int hexCount, int hexThreshold, int taskCount, int taskThreshold) {
    return '$hexCount/$hexThreshold esa · $taskCount/$taskThreshold compiti';
  }

  @override
  String get impactMapTitle => 'Mappa degli impatti';

  @override
  String get impactTileArctic => 'artico';

  @override
  String get impactTileMediterranean => 'mediterraneo';

  @override
  String get impactTabOnlyMe => 'Solo io';

  @override
  String get impactTabMyNode => 'Il mio nodo';

  @override
  String get impactTabNetwork => 'Rete';

  @override
  String get impactTabOnlyMeDesc => 'Il tuo impatto personale';

  @override
  String get impactTabMyNodeDesc => 'Impatto del tuo nodo';

  @override
  String get impactTabNetworkDesc => 'Impatto sull\'intera rete';

  @override
  String impactHexesUnlocked(int count) {
    return '$count esagoni sbloccati';
  }

  @override
  String impactTotalHexes(int total) {
    return 'Totale: $total esagoni';
  }

  @override
  String get impactNoHexes => 'Non hai ancora sbloccato alcun esagono.';

  @override
  String get impactGoldenHex => 'Esagono aureo';

  @override
  String get impactNavigatorTitle => 'Navigatori tra i ghiacci';
}
