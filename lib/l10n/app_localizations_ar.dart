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

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get nodeMember => 'عضو في العقدة';

  @override
  String get expeditionFallback => 'رحلة استكشافية';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal مهام · $percent%';
  }

  @override
  String get userFallback => 'مستخدم';

  @override
  String newTask(String type) {
    return 'مهمة جديدة: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'الأدلة';

  @override
  String get autoTasks => 'تلقائي';

  @override
  String get taskPayload => 'بيانات المهمة (الحمولة):';

  @override
  String get computeAndSubmit => 'احسِب وأرسِل';

  @override
  String get noTasksAvailable =>
      'لا توجد مهام متاحة في الوقت الحالي. يرجى المحاولة مجدداً لاحقاً.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get taskSentSuccess => 'تم تسليم المهمة بنجاح';

  @override
  String get totalCredits => 'إجمالي الوحدات الدراسية';

  @override
  String get recentHistory => 'التاريخ الحديث';

  @override
  String get noRecentActivity => 'لا يوجد نشاط حديث';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount اعتمادات · مهمة #$taskId';
  }

  @override
  String get streak => 'أثَر';

  @override
  String get week => 'أسبوع';

  @override
  String get totalTasks => 'إجمالي المهام';

  @override
  String get updateHistory => 'تحديث';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get loginSubtitle => 'ادخل إلى حساب التبرعات الخاص بك في مجال الحوسبة';

  @override
  String get registerSubtitle => 'انضم إلى شبكة الرصد البيئي';

  @override
  String get username => 'مستخدم';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get keepSession => 'إبقاء الجلسة مفتوحة';

  @override
  String get loginButton => 'يدخل';

  @override
  String get registerButton => 'يسجل';

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get noAccount => 'ألا تملك حساباً؟ اشترك';

  @override
  String get hasAccount => 'هل لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get checkingSession => 'جاري التحقق من الجلسة...';

  @override
  String get donateTitle => 'ادعم شبكة Eco\'clock';

  @override
  String get donateDescription =>
      'تذهب 95% من تبرعك مباشرةً إلى المنظمات غير الحكومية الشريكة، بينما تُستخدم نسبة الـ 5% المتبقية في صيانة المنصة وتطويرها.';

  @override
  String get chooseAmount => 'اختر مبلغاً';

  @override
  String get otherAmount => 'مبلغ آخر';

  @override
  String get donateNow => 'تبرع الآن';

  @override
  String get donateRedirectInfo =>
      'سيتم توجيهك إلى Stripe لإتمام عملية الدفع بشكل آمن. وبمجرد تجهيز الحساب المصرفي، سيتم تحديث هذا الرابط.';

  @override
  String get paymentLinkError => 'تعذّر فتح رابط الدفع';

  @override
  String get levelExplorer => 'مستكشف';

  @override
  String get levelSensor => 'مستشعر';

  @override
  String get levelSentinel => 'حارس';

  @override
  String get levelLighthouse => 'منارة';

  @override
  String nextLevel(String level) {
    return 'التالي: $level';
  }

  @override
  String streakDays(int days) {
    return 'أثَر $days d';
  }

  @override
  String get achievementFirstContribution => 'المساهمة الأولى';

  @override
  String get achievementWeekActive => 'أسبوع حافل بالنشاط';

  @override
  String get achievementTwoHabitats => 'موطنان';

  @override
  String get achievementFirstNode => 'العقدة الأولى';

  @override
  String get achievementHundredTasks => '100 مهمة';

  @override
  String get nodeCreate => 'إنشاء عقدة';

  @override
  String get nodeJoinByCode => 'انضم باستخدام الرمز';

  @override
  String get nodeName => 'اسم العقدة';

  @override
  String get nodeCode => 'رمز الدعوة';

  @override
  String get nodeLeave => 'اخرج من العقدة';

  @override
  String get nodeDelete => 'حذف العقدة';

  @override
  String get nodeRename => 'إعادة تسمية العقدة';

  @override
  String get nodeMembers => 'أعضاء';

  @override
  String get nodeRequests => 'التطبيقات';

  @override
  String get nodePublic => 'عُقد عامة';

  @override
  String get nodeJoinRequest => 'طلب الانضمام';

  @override
  String get nodeCreated => 'تم إنشاء العقدة بنجاح';

  @override
  String get nodeJoined => 'لقد انضممت إلى العقدة';

  @override
  String get nodeLeft => 'لقد غادرت العقدة';

  @override
  String get nodeDeleted => 'تم حذف العقدة';

  @override
  String get nodeNameUpdated => 'الاسم المُحدَّث';

  @override
  String get cancel => 'يلغي';

  @override
  String get confirm => 'يتأكد';

  @override
  String get save => 'يحفظ';

  @override
  String get delete => 'اِسْتَبْعَد';

  @override
  String get leave => 'الخروج';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get roleMember => 'عضو';

  @override
  String get logoFrame => 'إطار الشعار';

  @override
  String get noPendingRequests => 'لا توجد طلبات معلقة.';

  @override
  String get changeLogo => 'تغيير الشعار';

  @override
  String get transferLeadership => 'نقل القيادة';

  @override
  String get kickMember => 'طرد';

  @override
  String get achievementsTitle => 'الإنجازات';

  @override
  String get maxLevel => 'المستوى الأقصى';

  @override
  String get noneFrame => 'لا أحد';

  @override
  String get uploading => 'جارٍ الرفع...';

  @override
  String get wantsToJoin => 'يريد الانضمام';

  @override
  String get inviteLink => 'حلقة وصل';

  @override
  String get completeExpeditionsForFrames => 'أكمل البعثات لفتح الإطارات.';

  @override
  String get navigatorBannerReady => 'ظرف الملاح جاهز';

  @override
  String get navigatorBannerSent => 'تم إرسال الظرف — أكمل النشاط الخارجي';

  @override
  String get navigatorBannerValidated =>
      'تم التحقق من النشاط الخارجي — ملاح الجليد!';

  @override
  String get navigatorSendButton => 'إرسال الظرف';

  @override
  String get navigatorResendButton => 'إعادة الإرسال';

  @override
  String get navigatorSending => 'جارٍ الإرسال…';

  @override
  String get navigatorSentSuccess => 'تم إرسال الظرف! تحقق من بريدك.';

  @override
  String navigatorSendError(String error) {
    return 'خطأ في إرسال الظرف: $error';
  }

  @override
  String navigatorHexTasksCounter(
      int hexCount, int hexThreshold, int taskCount, int taskThreshold) {
    return '$hexCount/$hexThreshold سداسي · $taskCount/$taskThreshold مهام';
  }

  @override
  String get impactMapTitle => 'خريطة الأثر';

  @override
  String get impactTileArctic => 'القطب الشمالي';

  @override
  String get impactTileMediterranean => 'البحر المتوسط';

  @override
  String get impactTabOnlyMe => 'أنا فقط';

  @override
  String get impactTabMyNode => 'عقدتي';

  @override
  String get impactTabNetwork => 'الشبكة';

  @override
  String get impactTabOnlyMeDesc => 'أثرك الشخصي';

  @override
  String get impactTabMyNodeDesc => 'أثر عقدتك';

  @override
  String get impactTabNetworkDesc => 'أثر الشبكة بالكامل';

  @override
  String impactHexesUnlocked(int count) {
    return '$count سداسيات مفتوحة';
  }

  @override
  String impactTotalHexes(int total) {
    return 'المجموع: $total سداسي';
  }

  @override
  String get impactNoHexes => 'لم تفتح أي سداسيات بعد';

  @override
  String get impactGoldenHex => 'السداسي الذهبي';

  @override
  String get impactNavigatorTitle => 'ملاحو الجليد';

  @override
  String get impactScopeNodeSoon => 'عرض العقدة: قريبًا';

  @override
  String get impactScopeNetworkSoon => 'عرض الشبكة: قريبًا';

  @override
  String get impactCenterMap => 'توسيط';

  @override
  String get impactArcticHint => 'القطب الشمالي · اسحب / تكبير';

  @override
  String get impactNoHexesHint =>
      'لم تفتح أي سداسيات بعد. أكمل المهام في مناطق الأثر لتلوين الخريطة.';
}
