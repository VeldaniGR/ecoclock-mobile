// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => '開始';

  @override
  String get tabTask => '任務';

  @override
  String get tabCredits => '製作名單';

  @override
  String get tabNode => '節點';

  @override
  String get tabDonate => '捐';

  @override
  String get tabSettings => '設定';

  @override
  String welcome(String name) {
    return '歡迎, $name';
  }

  @override
  String userId(String id) {
    return '使用者身分: $id';
  }

  @override
  String get refreshAll => '全部刷新';

  @override
  String get requestTask => '詢問作業';

  @override
  String get logout => '登出登入';

  @override
  String get taskSent => '作業提交成功';

  @override
  String errorGeneric(String error) {
    return '錯誤: $error';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '語言';

  @override
  String version(String version) {
    return '版本 $version';
  }

  @override
  String get update => '更新';

  @override
  String get updateDescription => '檢查是否有新版本可用';
}
