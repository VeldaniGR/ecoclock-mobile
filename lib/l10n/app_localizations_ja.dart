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

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get nodeMember => 'ノードメンバー';

  @override
  String get expeditionFallback => '遠征';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal タスク · $percent%';
  }

  @override
  String get userFallback => 'ユーザー';

  @override
  String newTask(String type) {
    return '新しいタスク: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'マニュアル';

  @override
  String get autoTasks => '自動';

  @override
  String get taskPayload => 'タスクデータ（ペイロード）:';

  @override
  String get computeAndSubmit => '計算して送信する';

  @override
  String get noTasksAvailable => '現在、利用可能なタスクはありません。\n後でもう一度試してください。';

  @override
  String get retry => 'リトライ';

  @override
  String get taskSentSuccess => '課題の提出が完了しました';

  @override
  String get totalCredits => '合計単位数';

  @override
  String get recentHistory => '近年の歴史';

  @override
  String get noRecentActivity => '最近の活動はありません';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount クレジット · 割り当て #$taskId';
  }

  @override
  String get streak => '連続';

  @override
  String get week => '週';

  @override
  String get totalTasks => 'タスク合計';

  @override
  String get updateHistory => 'アップデート';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get registerTitle => 'アカウントを作成する';

  @override
  String get loginSubtitle => 'コンピューティング寄付アカウントにアクセスする';

  @override
  String get registerSubtitle => '環境モニタリングネットワークに参加しよう';

  @override
  String get username => 'ユーザー';

  @override
  String get email => 'Eメール';

  @override
  String get password => 'パスワード';

  @override
  String get keepSession => 'セッションを維持する';

  @override
  String get loginButton => '入力';

  @override
  String get registerButton => '登録する';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？登録する';

  @override
  String get hasAccount => 'すでにアカウントをお持ちですか？ログイン';

  @override
  String get checkingSession => 'セッションを検証中...';

  @override
  String get donateTitle => 'Eco\'clock Networkを支援する';

  @override
  String get donateDescription =>
      '寄付金の95%は、提携NGOに直接届けられます。残りの5%は、プラットフォームの維持・開発に充てられます。';

  @override
  String get chooseAmount => '金額を選択してください';

  @override
  String get otherAmount => '別の金額';

  @override
  String get donateNow => '今すぐ寄付する';

  @override
  String get donateRedirectInfo =>
      '安全に決済を完了していただくため、Stripeのページへリダイレクトされます。銀行口座の準備が整い次第、このリンクは更新されます。';

  @override
  String get paymentLinkError => '支払いリンクを開くことができませんでした。';
}
