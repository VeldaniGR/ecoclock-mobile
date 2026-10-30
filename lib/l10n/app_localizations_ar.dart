// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'يبدأ';

  @override
  String get tabTask => 'مهمة';

  @override
  String get tabCredits => 'طاقم العمل';

  @override
  String get tabNode => 'العقدة';

  @override
  String get tabDonate => 'يتبرع';

  @override
  String get tabSettings => 'إعدادات';

  @override
  String welcome(String name) {
    return 'مرحباً, $name';
  }

  @override
  String userId(String id) {
    return 'معرِّف المستخدم: $id';
  }

  @override
  String get refreshAll => 'تحديث الكل';

  @override
  String get requestTask => 'اطلب الواجب المنزلي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get taskSent => 'تم تسليم المهمة بنجاح';

  @override
  String errorGeneric(String error) {
    return 'خطأ: $error';
  }

  @override
  String get settingsTitle => 'إعدادات';

  @override
  String get language => 'لغة';

  @override
  String version(String version) {
    return 'إصدار $version';
  }

  @override
  String get update => 'تحديث';

  @override
  String get updateDescription => 'تحقق مما إذا كان هناك إصدار جديد متاح';
}
