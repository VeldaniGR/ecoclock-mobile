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
}
