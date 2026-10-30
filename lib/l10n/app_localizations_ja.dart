// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => '始める';

  @override
  String get tabTask => 'タスク';

  @override
  String get tabCredits => 'クレジット';

  @override
  String get tabNode => 'クレジット';

  @override
  String get tabDonate => '寄付する';

  @override
  String get tabSettings => '設定';

  @override
  String welcome(String name) {
    return 'いらっしゃいませ, $name';
  }

  @override
  String userId(String id) {
    return 'ユーザーID: $id';
  }

  @override
  String get refreshAll => 'すべて更新';

  @override
  String get requestTask => '宿題について尋ねる';

  @override
  String get logout => 'ログアウト';

  @override
  String get taskSent => '課題の提出が完了しました';

  @override
  String errorGeneric(String error) {
    return '間違い: $error';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '言語';

  @override
  String version(String version) {
    return 'バージョン $version';
  }

  @override
  String get update => 'アップデート';

  @override
  String get updateDescription => '新しいバージョンが利用可能か確認する';
}
