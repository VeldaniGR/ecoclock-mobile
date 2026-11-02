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

  @override
  String get quickActions => 'Quick actions';

  @override
  String get nodeMember => 'Node Member';

  @override
  String get expeditionFallback => 'Expedition';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal tasks · $percent%';
  }

  @override
  String get userFallback => 'user';

  @override
  String newTask(String type) {
    return 'New task: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manual';

  @override
  String get autoTasks => 'Automatic';

  @override
  String get taskPayload => 'Task details (payload):';

  @override
  String get computeAndSubmit => 'Calculate and send';

  @override
  String get noTasksAvailable =>
      'There are no tasks available right now. Please try again later.';

  @override
  String get retry => 'Retry';

  @override
  String get taskSentSuccess => 'Assignment submitted successfully';

  @override
  String get totalCredits => 'Total credits';

  @override
  String get recentHistory => 'Recent history';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount credits · assignment #$taskId';
  }

  @override
  String get streak => 'Streak';

  @override
  String get week => 'Week';

  @override
  String get totalTasks => 'Total tasks';

  @override
  String get updateHistory => 'Update';

  @override
  String get loginTitle => 'Login';

  @override
  String get registerTitle => 'Create account';

  @override
  String get loginSubtitle => 'Access your computing donation account';

  @override
  String get registerSubtitle => 'Join the environmental monitoring network';

  @override
  String get username => 'User';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get keepSession => 'Keep session open';

  @override
  String get loginButton => 'Enter';

  @override
  String get registerButton => 'Register';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get hasAccount => 'Already have an account? Log in';

  @override
  String get checkingSession => 'Verifying session...';

  @override
  String get donateTitle => 'Support Eco\'clock Network';

  @override
  String get donateDescription =>
      '95% of your donation goes directly to the partner NGOs. The remaining 5% is used for the maintenance and development of the platform.';

  @override
  String get chooseAmount => 'Choose an amount';

  @override
  String get otherAmount => 'Another amount';

  @override
  String get donateNow => 'Donate now';

  @override
  String get donateRedirectInfo =>
      'You will be redirected to Stripe to complete the payment securely. Once the bank account is ready, this link will be updated.';

  @override
  String get paymentLinkError => 'The payment link could not be opened';

  @override
  String get levelExplorer => 'Explorer';

  @override
  String get levelSensor => 'Sensor';

  @override
  String get levelSentinel => 'Sentinel';

  @override
  String get levelLighthouse => 'Lighthouse';

  @override
  String nextLevel(String level) {
    return 'Next: $level';
  }

  @override
  String streakDays(int days) {
    return 'Streak $days d';
  }

  @override
  String get achievementFirstContribution => 'First contribution';

  @override
  String get achievementWeekActive => 'Active week';

  @override
  String get achievementTwoHabitats => 'Two habitats';

  @override
  String get achievementFirstNode => 'First node';

  @override
  String get achievementHundredTasks => '100 tasks';

  @override
  String get nodeCreate => 'Create node';

  @override
  String get nodeJoinByCode => 'Join with code';

  @override
  String get nodeName => 'Node name';

  @override
  String get nodeCode => 'Invitation code';

  @override
  String get nodeLeave => 'Exit the node';

  @override
  String get nodeDelete => 'Delete node';

  @override
  String get nodeRename => 'Rename node';

  @override
  String get nodeMembers => 'Members';

  @override
  String get nodeRequests => 'Applications';

  @override
  String get nodePublic => 'Public nodes';

  @override
  String get nodeJoinRequest => 'Request to join';

  @override
  String get nodeCreated => 'Node created successfully';

  @override
  String get nodeJoined => 'You have joined the node';

  @override
  String get nodeLeft => 'You have left the node';

  @override
  String get nodeDeleted => 'Node deleted';

  @override
  String get nodeNameUpdated => 'Updated name';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Keep';

  @override
  String get delete => 'Eliminate';

  @override
  String get leave => 'Exit';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleMember => 'Miembro';

  @override
  String get logoFrame => 'Marco del logo';

  @override
  String get noPendingRequests => 'No hay solicitudes pendientes.';

  @override
  String get changeLogo => 'Cambiar logo';

  @override
  String get transferLeadership => 'Transferir liderazgo';

  @override
  String get kickMember => 'Expulsar';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String get maxLevel => 'Nivel máximo';

  @override
  String get noneFrame => 'Ninguno';

  @override
  String get uploading => 'Subiendo...';

  @override
  String get wantsToJoin => 'Quiere unirse';

  @override
  String get inviteLink => 'Enlace de unión';

  @override
  String get completeExpeditionsForFrames =>
      'Complete expeditions to unlock frames.';
}
