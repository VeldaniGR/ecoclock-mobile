// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabTask => 'Tarea';

  @override
  String get tabCredits => 'Créditos';

  @override
  String get tabNode => 'Nodo';

  @override
  String get tabDonate => 'Donar';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String welcome(String name) {
    return 'Bienvenido, $name';
  }

  @override
  String userId(String id) {
    return 'ID de usuario: $id';
  }

  @override
  String get refreshAll => 'Refrescar todo';

  @override
  String get requestTask => 'Pedir tarea';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get taskSent => 'Tarea enviada correctamente';

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get update => 'Actualizar';

  @override
  String get updateDescription =>
      'Comprobar si hay una nueva versión disponible';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get nodeMember => 'Miembro del Nodo';

  @override
  String get expeditionFallback => 'Expedición';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal tareas · $percent%';
  }

  @override
  String get userFallback => 'usuario';

  @override
  String newTask(String type) {
    return 'Nueva tarea: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manuales';

  @override
  String get autoTasks => 'Automáticas';

  @override
  String get taskPayload => 'Datos de la tarea (payload):';

  @override
  String get computeAndSubmit => 'Calcular y enviar';

  @override
  String get noTasksAvailable =>
      'No hay tareas disponibles ahora mismo.\nInténtalo más tarde.';

  @override
  String get retry => 'Reintentar';

  @override
  String get taskSentSuccess => 'Tarea enviada correctamente';

  @override
  String get totalCredits => 'Total créditos';

  @override
  String get recentHistory => 'Historial reciente';

  @override
  String get noRecentActivity => 'Sin actividad reciente';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount créditos · tarea #$taskId';
  }

  @override
  String get streak => 'Racha';

  @override
  String get week => 'Semana';

  @override
  String get totalTasks => 'Tareas totales';

  @override
  String get updateHistory => 'Actualizar';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get loginSubtitle => 'Accede a tu cuenta de donación de cómputo';

  @override
  String get registerSubtitle => 'Únete a la red de monitorización ambiental';

  @override
  String get username => 'Usuario';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get keepSession => 'Mantener sesión abierta';

  @override
  String get loginButton => 'Entrar';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get noAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get hasAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get checkingSession => 'Verificando sesión...';

  @override
  String get donateTitle => 'Apoya Eco\'clock Network';

  @override
  String get donateDescription =>
      'El 95 % de tu donación se destina directamente a las ONGs asociadas. El 5 % restante se utiliza para el mantenimiento y desarrollo de la plataforma.';

  @override
  String get chooseAmount => 'Elige una cantidad';

  @override
  String get otherAmount => 'Otra cantidad';

  @override
  String get donateNow => 'Donar ahora';

  @override
  String get donateRedirectInfo =>
      'Serás redirigido a Stripe para completar el pago de forma segura. Cuando tengamos la cuenta bancaria lista, este enlace se actualizará.';

  @override
  String get paymentLinkError => 'No se pudo abrir el enlace de pago';

  @override
  String get levelExplorer => 'Explorador';

  @override
  String get levelSensor => 'Sensor';

  @override
  String get levelSentinel => 'Centinela';

  @override
  String get levelLighthouse => 'Faro';

  @override
  String nextLevel(String level) {
    return 'Siguiente: $level';
  }

  @override
  String streakDays(int days) {
    return 'Racha $days d';
  }

  @override
  String get achievementFirstContribution => 'Primera contribución';

  @override
  String get achievementWeekActive => 'Semana activo';

  @override
  String get achievementTwoHabitats => 'Dos hábitats';

  @override
  String get achievementFirstNode => 'Primer nodo';

  @override
  String get achievementHundredTasks => '100 tareas';

  @override
  String get nodeCreate => 'Crear nodo';

  @override
  String get nodeJoinByCode => 'Unirse con código';

  @override
  String get nodeName => 'Nombre del nodo';

  @override
  String get nodeCode => 'Código de invitación';

  @override
  String get nodeLeave => 'Salir del nodo';

  @override
  String get nodeDelete => 'Eliminar nodo';

  @override
  String get nodeRename => 'Renombrar nodo';

  @override
  String get nodeMembers => 'Miembros';

  @override
  String get nodeRequests => 'Solicitudes';

  @override
  String get nodePublic => 'Nodos públicos';

  @override
  String get nodeJoinRequest => 'Solicitar unirse';

  @override
  String get nodeCreated => 'Nodo creado correctamente';

  @override
  String get nodeJoined => 'Te has unido al nodo';

  @override
  String get nodeLeft => 'Has salido del nodo';

  @override
  String get nodeDeleted => 'Nodo eliminado';

  @override
  String get nodeNameUpdated => 'Nombre actualizado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get leave => 'Salir';
}
