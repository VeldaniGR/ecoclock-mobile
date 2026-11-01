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

  @override
  String get quickActions => '快速操作';

  @override
  String get nodeMember => '節點成員';

  @override
  String get expeditionFallback => '遠徵';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal 任務 · $percent%';
  }

  @override
  String get userFallback => '使用者';

  @override
  String newTask(String type) {
    return '新任務： $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => '手冊';

  @override
  String get autoTasks => '自動的';

  @override
  String get taskPayload => '任務資料（有效載荷）：';

  @override
  String get computeAndSubmit => '計算並發送';

  @override
  String get noTasksAvailable => '目前沒有可用任務。\n稍後再試。';

  @override
  String get retry => '重試';

  @override
  String get taskSentSuccess => '作業提交成功';

  @override
  String get totalCredits => '總學分';

  @override
  String get recentHistory => '近代史';

  @override
  String get noRecentActivity => '近期無活動';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount 製作名單 · 任務 #$taskId';
  }

  @override
  String get streak => '條紋';

  @override
  String get week => '星期';

  @override
  String get totalTasks => '任務總數';

  @override
  String get updateHistory => '更新';

  @override
  String get loginTitle => '登入';

  @override
  String get registerTitle => '建立帳戶';

  @override
  String get loginSubtitle => '造訪您的計算捐贈帳戶';

  @override
  String get registerSubtitle => '加入環境監測網絡';

  @override
  String get username => '使用者';

  @override
  String get email => '電子郵件';

  @override
  String get password => '密碼';

  @override
  String get keepSession => '保持會話開啟';

  @override
  String get loginButton => '進入';

  @override
  String get registerButton => '登記';

  @override
  String get forgotPassword => '忘記密碼了嗎？';

  @override
  String get noAccount => '還沒有帳戶？註冊';

  @override
  String get hasAccount => '已有帳戶？登入';

  @override
  String get checkingSession => '正在驗證會話…';

  @override
  String get donateTitle => '支持 Eco\'clock 網絡';

  @override
  String get donateDescription =>
      '您捐贈款項的 95% 將直接撥付給合作非政府組織（NGO），其餘 5% 則用於平台的維護與發展。';

  @override
  String get chooseAmount => '選擇金額';

  @override
  String get otherAmount => '另一個金額';

  @override
  String get donateNow => '立即捐贈';

  @override
  String get donateRedirectInfo =>
      '您將被重新導向至 Stripe 以安全完成付款。待銀行帳戶準備就緒後，此連結將會更新。';

  @override
  String get paymentLinkError => '無法開啟支付連結';

  @override
  String get levelExplorer => '探索者';

  @override
  String get levelSensor => '感應器';

  @override
  String get levelSentinel => '哨兵';

  @override
  String get levelLighthouse => '燈塔';

  @override
  String nextLevel(String level) {
    return '下列的: $level';
  }

  @override
  String streakDays(int days) {
    return '條紋 $days d';
  }

  @override
  String get achievementFirstContribution => '首次貢獻';

  @override
  String get achievementWeekActive => '充實的一周';

  @override
  String get achievementTwoHabitats => '兩種棲息地';

  @override
  String get achievementFirstNode => '第一個節點';

  @override
  String get achievementHundredTasks => '100項任務';

  @override
  String get nodeCreate => '建立節點';

  @override
  String get nodeJoinByCode => '使用代碼加入';

  @override
  String get nodeName => '節點名稱';

  @override
  String get nodeCode => '邀請碼';

  @override
  String get nodeLeave => '退出節點';

  @override
  String get nodeDelete => '刪除節點';

  @override
  String get nodeRename => '重新命名節點';

  @override
  String get nodeMembers => '成員';

  @override
  String get nodeRequests => '應用';

  @override
  String get nodePublic => '公共節點';

  @override
  String get nodeJoinRequest => '申請加入';

  @override
  String get nodeCreated => '節點創建成功';

  @override
  String get nodeJoined => '您已加入該節點';

  @override
  String get nodeLeft => '您已離開該節點';

  @override
  String get nodeDeleted => '節點已刪除';

  @override
  String get nodeNameUpdated => '已更新名稱';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get save => '保持';

  @override
  String get delete => '排除';

  @override
  String get leave => '出去';
}
