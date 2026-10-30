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
}
