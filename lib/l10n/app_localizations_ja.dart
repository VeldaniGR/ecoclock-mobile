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

  @override
  String get levelExplorer => 'エクスプローラ';

  @override
  String get levelSensor => 'センサー';

  @override
  String get levelSentinel => 'センチネル';

  @override
  String get levelLighthouse => '灯台';

  @override
  String nextLevel(String level) {
    return '続く: $level';
  }

  @override
  String streakDays(int days) {
    return '連続 $days d';
  }

  @override
  String get achievementFirstContribution => '最初の貢献';

  @override
  String get achievementWeekActive => 'アクティブな一週間';

  @override
  String get achievementTwoHabitats => '2つの生息環境';

  @override
  String get achievementFirstNode => '最初のノード';

  @override
  String get achievementHundredTasks => '100のタスク';

  @override
  String get nodeCreate => 'ノードを作成';

  @override
  String get nodeJoinByCode => 'コードで参加';

  @override
  String get nodeName => 'ノード名';

  @override
  String get nodeCode => '招待コード';

  @override
  String get nodeLeave => 'ノードから出る';

  @override
  String get nodeDelete => 'ノードを削除';

  @override
  String get nodeRename => 'ノードの名前を変更';

  @override
  String get nodeMembers => 'メンバー';

  @override
  String get nodeRequests => '用途';

  @override
  String get nodePublic => 'パブリックノード';

  @override
  String get nodeJoinRequest => '参加リクエスト';

  @override
  String get nodeCreated => 'ノードが正常に作成されました';

  @override
  String get nodeJoined => 'ノードに参加しました';

  @override
  String get nodeLeft => 'ノードから離れました';

  @override
  String get nodeDeleted => 'ノードが削除されました';

  @override
  String get nodeNameUpdated => '更新された名前';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認する';

  @override
  String get save => '保つ';

  @override
  String get delete => 'なくす';

  @override
  String get leave => '外出';

  @override
  String get roleAdmin => '管理者';

  @override
  String get roleMember => 'メンバー';

  @override
  String get logoFrame => 'ロゴフレーム';

  @override
  String get noPendingRequests => '保留中のリクエストはありません。';

  @override
  String get changeLogo => 'ロゴを変更';

  @override
  String get transferLeadership => 'リーダーシップの引き継ぎ';

  @override
  String get kickMember => '追放する';

  @override
  String get achievementsTitle => '実績';

  @override
  String get maxLevel => '最大レベル';

  @override
  String get noneFrame => 'なし';

  @override
  String get uploading => 'アップロード中...';

  @override
  String get wantsToJoin => '彼は参加したがっている。';

  @override
  String get inviteLink => 'つなぎのリンク';

  @override
  String get completeExpeditionsForFrames => '遠征を完了して、フレームをアンロックしよう。';

  @override
  String get navigatorBannerReady => 'ナビゲーターの封筒の準備ができました';

  @override
  String get navigatorBannerSent => '封筒を送信しました — 屋外アクティビティを完了してください';

  @override
  String get navigatorBannerValidated => '屋外アクティビティ認証済み — 氷のナビゲーター！';

  @override
  String get navigatorSendButton => '封筒を送信';

  @override
  String get navigatorResendButton => '再送信';

  @override
  String get navigatorSending => '送信中…';

  @override
  String get navigatorSentSuccess => '封筒を送信しました！メールを確認してください。';

  @override
  String navigatorSendError(String error) {
    return '封筒の送信エラー: $error';
  }

  @override
  String navigatorHexTasksCounter(
      int hexCount, int hexThreshold, int taskCount, int taskThreshold) {
    return '$hexCount/$hexThreshold ヘクス · $taskCount/$taskThreshold タスク';
  }

  @override
  String get impactMapTitle => 'インパクトマップ';

  @override
  String get impactTileArctic => '北極';

  @override
  String get impactTileMediterranean => '地中海';

  @override
  String get impactTabOnlyMe => '自分のみ';

  @override
  String get impactTabMyNode => '自分のノード';

  @override
  String get impactTabNetwork => 'ネットワーク';

  @override
  String get impactTabOnlyMeDesc => '個人のインパクト';

  @override
  String get impactTabMyNodeDesc => 'ノードのインパクト';

  @override
  String get impactTabNetworkDesc => 'ネットワーク全体のインパクト';

  @override
  String impactHexesUnlocked(int count) {
    return '$count 個のヘクスを解除';
  }

  @override
  String impactTotalHexes(int total) {
    return '合計: $total ヘクス';
  }

  @override
  String get impactNoHexes => 'まだヘクスを解除していません';

  @override
  String get impactGoldenHex => '黄金のヘクス';

  @override
  String get impactNavigatorTitle => '氷のナビゲーター';

  @override
  String get impactScopeNodeSoon => 'ノード表示: 近日公開';

  @override
  String get impactScopeNetworkSoon => 'ネットワーク表示: 近日公開';

  @override
  String get impactCenterMap => '中央に戻す';

  @override
  String get impactArcticHint => '北極 · ドラッグ / ズーム';

  @override
  String get impactNoHexesHint =>
      'まだヘクスを解除していません。インパクトゾーンのタスクを完了してマップを色付けしましょう。';
}
