import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('eu'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// Título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'Eco\'clock Network'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get tabHome;

  /// No description provided for @tabTask.
  ///
  /// In es, this message translates to:
  /// **'Tarea'**
  String get tabTask;

  /// No description provided for @tabCredits.
  ///
  /// In es, this message translates to:
  /// **'Créditos'**
  String get tabCredits;

  /// No description provided for @tabNode.
  ///
  /// In es, this message translates to:
  /// **'Nodo'**
  String get tabNode;

  /// No description provided for @tabDonate.
  ///
  /// In es, this message translates to:
  /// **'Donar'**
  String get tabDonate;

  /// No description provided for @tabSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get tabSettings;

  /// No description provided for @welcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido, {name}'**
  String welcome(String name);

  /// No description provided for @userId.
  ///
  /// In es, this message translates to:
  /// **'ID de usuario: {id}'**
  String userId(String id);

  /// No description provided for @refreshAll.
  ///
  /// In es, this message translates to:
  /// **'Refrescar todo'**
  String get refreshAll;

  /// No description provided for @requestTask.
  ///
  /// In es, this message translates to:
  /// **'Pedir tarea'**
  String get requestTask;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @taskSent.
  ///
  /// In es, this message translates to:
  /// **'Tarea enviada correctamente'**
  String get taskSent;

  /// No description provided for @errorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(String error);

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String version(String version);

  /// No description provided for @update.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get update;

  /// No description provided for @updateDescription.
  ///
  /// In es, this message translates to:
  /// **'Comprobar si hay una nueva versión disponible'**
  String get updateDescription;

  /// No description provided for @quickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones rápidas'**
  String get quickActions;

  /// No description provided for @nodeMember.
  ///
  /// In es, this message translates to:
  /// **'Miembro del Nodo'**
  String get nodeMember;

  /// No description provided for @expeditionFallback.
  ///
  /// In es, this message translates to:
  /// **'Expedición'**
  String get expeditionFallback;

  /// No description provided for @tasksProgress.
  ///
  /// In es, this message translates to:
  /// **'{current} / {goal} tareas · {percent}%'**
  String tasksProgress(int current, int goal, String percent);

  /// No description provided for @userFallback.
  ///
  /// In es, this message translates to:
  /// **'usuario'**
  String get userFallback;

  /// No description provided for @newTask.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea: {type}'**
  String newTask(String type);

  /// No description provided for @taskId.
  ///
  /// In es, this message translates to:
  /// **'ID: {id}'**
  String taskId(String id);

  /// No description provided for @manualTasks.
  ///
  /// In es, this message translates to:
  /// **'Manuales'**
  String get manualTasks;

  /// No description provided for @autoTasks.
  ///
  /// In es, this message translates to:
  /// **'Automáticas'**
  String get autoTasks;

  /// No description provided for @taskPayload.
  ///
  /// In es, this message translates to:
  /// **'Datos de la tarea (payload):'**
  String get taskPayload;

  /// No description provided for @computeAndSubmit.
  ///
  /// In es, this message translates to:
  /// **'Calcular y enviar'**
  String get computeAndSubmit;

  /// No description provided for @noTasksAvailable.
  ///
  /// In es, this message translates to:
  /// **'No hay tareas disponibles ahora mismo.\nInténtalo más tarde.'**
  String get noTasksAvailable;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @taskSentSuccess.
  ///
  /// In es, this message translates to:
  /// **'Tarea enviada correctamente'**
  String get taskSentSuccess;

  /// No description provided for @totalCredits.
  ///
  /// In es, this message translates to:
  /// **'Total créditos'**
  String get totalCredits;

  /// No description provided for @recentHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial reciente'**
  String get recentHistory;

  /// No description provided for @noRecentActivity.
  ///
  /// In es, this message translates to:
  /// **'Sin actividad reciente'**
  String get noRecentActivity;

  /// No description provided for @creditEntry.
  ///
  /// In es, this message translates to:
  /// **'{amount} créditos · tarea #{taskId}'**
  String creditEntry(String amount, String taskId);

  /// No description provided for @streak.
  ///
  /// In es, this message translates to:
  /// **'Racha'**
  String get streak;

  /// No description provided for @week.
  ///
  /// In es, this message translates to:
  /// **'Semana'**
  String get week;

  /// No description provided for @totalTasks.
  ///
  /// In es, this message translates to:
  /// **'Tareas totales'**
  String get totalTasks;

  /// No description provided for @updateHistory.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get updateHistory;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Accede a tu cuenta de donación de cómputo'**
  String get loginSubtitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Únete a la red de monitorización ambiental'**
  String get registerSubtitle;

  /// No description provided for @username.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get username;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @keepSession.
  ///
  /// In es, this message translates to:
  /// **'Mantener sesión abierta'**
  String get keepSession;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Regístrate'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? Inicia sesión'**
  String get hasAccount;

  /// No description provided for @checkingSession.
  ///
  /// In es, this message translates to:
  /// **'Verificando sesión...'**
  String get checkingSession;

  /// No description provided for @donateTitle.
  ///
  /// In es, this message translates to:
  /// **'Apoya Eco\'clock Network'**
  String get donateTitle;

  /// No description provided for @donateDescription.
  ///
  /// In es, this message translates to:
  /// **'El 95 % de tu donación se destina directamente a las ONGs asociadas. El 5 % restante se utiliza para el mantenimiento y desarrollo de la plataforma.'**
  String get donateDescription;

  /// No description provided for @chooseAmount.
  ///
  /// In es, this message translates to:
  /// **'Elige una cantidad'**
  String get chooseAmount;

  /// No description provided for @otherAmount.
  ///
  /// In es, this message translates to:
  /// **'Otra cantidad'**
  String get otherAmount;

  /// No description provided for @donateNow.
  ///
  /// In es, this message translates to:
  /// **'Donar ahora'**
  String get donateNow;

  /// No description provided for @donateRedirectInfo.
  ///
  /// In es, this message translates to:
  /// **'Serás redirigido a Stripe para completar el pago de forma segura. Cuando tengamos la cuenta bancaria lista, este enlace se actualizará.'**
  String get donateRedirectInfo;

  /// No description provided for @paymentLinkError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir el enlace de pago'**
  String get paymentLinkError;

  /// No description provided for @levelExplorer.
  ///
  /// In es, this message translates to:
  /// **'Explorador'**
  String get levelExplorer;

  /// No description provided for @levelSensor.
  ///
  /// In es, this message translates to:
  /// **'Sensor'**
  String get levelSensor;

  /// No description provided for @levelSentinel.
  ///
  /// In es, this message translates to:
  /// **'Centinela'**
  String get levelSentinel;

  /// No description provided for @levelLighthouse.
  ///
  /// In es, this message translates to:
  /// **'Faro'**
  String get levelLighthouse;

  /// No description provided for @nextLevel.
  ///
  /// In es, this message translates to:
  /// **'Siguiente: {level}'**
  String nextLevel(String level);

  /// No description provided for @streakDays.
  ///
  /// In es, this message translates to:
  /// **'Racha {days} d'**
  String streakDays(int days);

  /// No description provided for @achievementFirstContribution.
  ///
  /// In es, this message translates to:
  /// **'Primera contribución'**
  String get achievementFirstContribution;

  /// No description provided for @achievementWeekActive.
  ///
  /// In es, this message translates to:
  /// **'Semana activo'**
  String get achievementWeekActive;

  /// No description provided for @achievementTwoHabitats.
  ///
  /// In es, this message translates to:
  /// **'Dos hábitats'**
  String get achievementTwoHabitats;

  /// No description provided for @achievementFirstNode.
  ///
  /// In es, this message translates to:
  /// **'Primer nodo'**
  String get achievementFirstNode;

  /// No description provided for @achievementHundredTasks.
  ///
  /// In es, this message translates to:
  /// **'100 tareas'**
  String get achievementHundredTasks;

  /// No description provided for @nodeCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear nodo'**
  String get nodeCreate;

  /// No description provided for @nodeJoinByCode.
  ///
  /// In es, this message translates to:
  /// **'Unirse con código'**
  String get nodeJoinByCode;

  /// No description provided for @nodeName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del nodo'**
  String get nodeName;

  /// No description provided for @nodeCode.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación'**
  String get nodeCode;

  /// No description provided for @nodeLeave.
  ///
  /// In es, this message translates to:
  /// **'Salir del nodo'**
  String get nodeLeave;

  /// No description provided for @nodeDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar nodo'**
  String get nodeDelete;

  /// No description provided for @nodeRename.
  ///
  /// In es, this message translates to:
  /// **'Renombrar nodo'**
  String get nodeRename;

  /// No description provided for @nodeMembers.
  ///
  /// In es, this message translates to:
  /// **'Miembros'**
  String get nodeMembers;

  /// No description provided for @nodeRequests.
  ///
  /// In es, this message translates to:
  /// **'Solicitudes'**
  String get nodeRequests;

  /// No description provided for @nodePublic.
  ///
  /// In es, this message translates to:
  /// **'Nodos públicos'**
  String get nodePublic;

  /// No description provided for @nodeJoinRequest.
  ///
  /// In es, this message translates to:
  /// **'Solicitar unirse'**
  String get nodeJoinRequest;

  /// No description provided for @nodeCreated.
  ///
  /// In es, this message translates to:
  /// **'Nodo creado correctamente'**
  String get nodeCreated;

  /// No description provided for @nodeJoined.
  ///
  /// In es, this message translates to:
  /// **'Te has unido al nodo'**
  String get nodeJoined;

  /// No description provided for @nodeLeft.
  ///
  /// In es, this message translates to:
  /// **'Has salido del nodo'**
  String get nodeLeft;

  /// No description provided for @nodeDeleted.
  ///
  /// In es, this message translates to:
  /// **'Nodo eliminado'**
  String get nodeDeleted;

  /// No description provided for @nodeNameUpdated.
  ///
  /// In es, this message translates to:
  /// **'Nombre actualizado'**
  String get nodeNameUpdated;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @leave.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get leave;

  /// No description provided for @roleAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In es, this message translates to:
  /// **'Miembro'**
  String get roleMember;

  /// No description provided for @logoFrame.
  ///
  /// In es, this message translates to:
  /// **'Marco del logo'**
  String get logoFrame;

  /// No description provided for @noPendingRequests.
  ///
  /// In es, this message translates to:
  /// **'No hay solicitudes pendientes.'**
  String get noPendingRequests;

  /// No description provided for @changeLogo.
  ///
  /// In es, this message translates to:
  /// **'Cambiar logo'**
  String get changeLogo;

  /// No description provided for @transferLeadership.
  ///
  /// In es, this message translates to:
  /// **'Transferir liderazgo'**
  String get transferLeadership;

  /// No description provided for @kickMember.
  ///
  /// In es, this message translates to:
  /// **'Expulsar'**
  String get kickMember;

  /// No description provided for @achievementsTitle.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get achievementsTitle;

  /// No description provided for @maxLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel máximo'**
  String get maxLevel;

  /// No description provided for @noneFrame.
  ///
  /// In es, this message translates to:
  /// **'Ninguno'**
  String get noneFrame;

  /// No description provided for @uploading.
  ///
  /// In es, this message translates to:
  /// **'Subiendo...'**
  String get uploading;

  /// No description provided for @wantsToJoin.
  ///
  /// In es, this message translates to:
  /// **'Quiere unirse'**
  String get wantsToJoin;

  /// No description provided for @inviteLink.
  ///
  /// In es, this message translates to:
  /// **'Enlace de unión'**
  String get inviteLink;

  /// No description provided for @completeExpeditionsForFrames.
  ///
  /// In es, this message translates to:
  /// **'Completa expediciones para desbloquear marcos.'**
  String get completeExpeditionsForFrames;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'ca',
        'de',
        'en',
        'es',
        'eu',
        'fr',
        'it',
        'ja',
        'pt',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'eu':
      return AppLocalizationsEu();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
