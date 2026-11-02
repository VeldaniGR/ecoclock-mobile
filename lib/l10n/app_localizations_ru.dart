// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Начинать';

  @override
  String get tabTask => 'Задача';

  @override
  String get tabCredits => 'Авторы';

  @override
  String get tabNode => 'Узел';

  @override
  String get tabDonate => 'Пожертвовать';

  @override
  String get tabSettings => 'Настройки';

  @override
  String welcome(String name) {
    return 'Добро пожаловать, $name';
  }

  @override
  String userId(String id) {
    return 'ID пользователя: $id';
  }

  @override
  String get refreshAll => 'Обновить всё';

  @override
  String get requestTask => 'Попросить задать домашнее задание';

  @override
  String get logout => 'Выйти';

  @override
  String get taskSent => 'Задание успешно отправлено';

  @override
  String errorGeneric(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String version(String version) {
    return 'Версия $version';
  }

  @override
  String get update => 'Обновлять';

  @override
  String get updateDescription => 'Проверьте, доступна ли новая версия';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get nodeMember => 'Участник узла';

  @override
  String get expeditionFallback => 'Экспедиция';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal задачи · $percent%';
  }

  @override
  String get userFallback => 'пользователь';

  @override
  String newTask(String type) {
    return 'Новая задача: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Руководства';

  @override
  String get autoTasks => 'Автоматический';

  @override
  String get taskPayload => 'Данные задачи (полезная нагрузка):';

  @override
  String get computeAndSubmit => 'Рассчитать и отправить';

  @override
  String get noTasksAvailable =>
      'В данный момент нет доступных задач.\nПопробуйте позже.';

  @override
  String get retry => 'Повторить';

  @override
  String get taskSentSuccess => 'Задание успешно отправлено';

  @override
  String get totalCredits => 'Общее количество зачетных единиц';

  @override
  String get recentHistory => 'Недавняя история';

  @override
  String get noRecentActivity => 'В последнее время активности нет';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount зачётные единицы · задание #$taskId';
  }

  @override
  String get streak => 'Серия';

  @override
  String get week => 'Неделя';

  @override
  String get totalTasks => 'Всего задач';

  @override
  String get updateHistory => 'Обновлять';

  @override
  String get loginTitle => 'Авторизоваться';

  @override
  String get registerTitle => 'Зарегистрироваться';

  @override
  String get loginSubtitle =>
      'Получите доступ к своему счету для пожертвований на оплату компьютеров.';

  @override
  String get registerSubtitle =>
      'Присоединяйтесь к сети экологического мониторинга';

  @override
  String get username => 'Пользователь';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get keepSession => 'Оставить сеанс открытым';

  @override
  String get loginButton => 'Входить';

  @override
  String get registerButton => 'Зарегистрироваться';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get noAccount => 'Нет аккаунта? Зарегистрируйтесь';

  @override
  String get hasAccount => 'Уже есть аккаунт? Войдите';

  @override
  String get checkingSession => 'Проверка сеанса...';

  @override
  String get donateTitle => 'Поддержите сеть Eco\'clock';

  @override
  String get donateDescription =>
      '95 % вашего пожертвования направляются непосредственно партнерским НКО. Оставшиеся 5 % используются для поддержания и развития платформы.';

  @override
  String get chooseAmount => 'Выберите сумму';

  @override
  String get otherAmount => 'Другая сумма';

  @override
  String get donateNow => 'Пожертвовать сейчас';

  @override
  String get donateRedirectInfo =>
      'Вы будете перенаправлены на сайт Stripe для безопасного завершения оплаты. Как только банковский счет будет готов, эта ссылка обновится.';

  @override
  String get paymentLinkError => 'Не удалось открыть ссылку для оплаты';

  @override
  String get levelExplorer => 'Исследователь';

  @override
  String get levelSensor => 'Датчик';

  @override
  String get levelSentinel => 'Часовой';

  @override
  String get levelLighthouse => 'Маяк';

  @override
  String nextLevel(String level) {
    return 'Следующий: $level';
  }

  @override
  String streakDays(int days) {
    return 'Серия $days d';
  }

  @override
  String get achievementFirstContribution => 'Первый вклад';

  @override
  String get achievementWeekActive => 'Активная неделя';

  @override
  String get achievementTwoHabitats => 'Две среды обитания';

  @override
  String get achievementFirstNode => 'Первый узел';

  @override
  String get achievementHundredTasks => '100 задач';

  @override
  String get nodeCreate => 'Создать узел';

  @override
  String get nodeJoinByCode => 'Присоединиться по коду';

  @override
  String get nodeName => 'Имя узла';

  @override
  String get nodeCode => 'Код приглашения';

  @override
  String get nodeLeave => 'Выйти из узла';

  @override
  String get nodeDelete => 'Удалить узел';

  @override
  String get nodeRename => 'Переименовать узел';

  @override
  String get nodeMembers => 'Участники';

  @override
  String get nodeRequests => 'Приложения';

  @override
  String get nodePublic => 'Публичные узлы';

  @override
  String get nodeJoinRequest => 'Запрос на присоединение';

  @override
  String get nodeCreated => 'Узел успешно создан';

  @override
  String get nodeJoined => 'Вы присоединились к узлу';

  @override
  String get nodeLeft => 'Вы покинули узел';

  @override
  String get nodeDeleted => 'Узел удален';

  @override
  String get nodeNameUpdated => 'Обновлённое название';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтверждать';

  @override
  String get save => 'Держать';

  @override
  String get delete => 'Устранять';

  @override
  String get leave => 'Выходить';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get roleMember => 'Член';

  @override
  String get logoFrame => 'Рамка для логотипа';

  @override
  String get noPendingRequests => 'Ожидающих запросов нет.';

  @override
  String get changeLogo => 'Изменить логотип';

  @override
  String get transferLeadership => 'Передача руководства';

  @override
  String get kickMember => 'Исключить';

  @override
  String get achievementsTitle => 'Достижения';

  @override
  String get maxLevel => 'Максимальный уровень';

  @override
  String get noneFrame => 'Никто';

  @override
  String get uploading => 'Загрузка...';

  @override
  String get wantsToJoin => 'Он хочет присоединиться';

  @override
  String get inviteLink => 'Связующее звено';

  @override
  String get completeExpeditionsForFrames =>
      'Завершайте экспедиции, чтобы разблокировать рамки.';
}
