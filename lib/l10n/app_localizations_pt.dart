// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Eco\'clock Network';

  @override
  String get tabHome => 'Início';

  @override
  String get tabTask => 'Tarefa';

  @override
  String get tabCredits => 'Créditos';

  @override
  String get tabNode => 'Nó';

  @override
  String get tabDonate => 'Doar';

  @override
  String get tabSettings => 'Configurações';

  @override
  String welcome(String name) {
    return 'Bem-vindo, $name';
  }

  @override
  String userId(String id) {
    return 'ID de usuário: $id';
  }

  @override
  String get refreshAll => 'Atualizar tudo';

  @override
  String get requestTask => 'Pedir tarefa';

  @override
  String get logout => 'Encerrar sessão';

  @override
  String get taskSent => 'Tarefa enviada corretamente';

  @override
  String errorGeneric(String error) {
    return 'Erro: $error';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get language => 'Linguagem';

  @override
  String version(String version) {
    return 'Versão $version';
  }

  @override
  String get update => 'Atualizar';

  @override
  String get updateDescription => 'Verificar se há uma nova versão disponível';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get nodeMember => 'Membro do Nó';

  @override
  String get expeditionFallback => 'Expedição';

  @override
  String tasksProgress(int current, int goal, String percent) {
    return '$current / $goal tarefas · $percent%';
  }

  @override
  String get userFallback => 'usuário';

  @override
  String newTask(String type) {
    return 'Nova tarefa: $type';
  }

  @override
  String taskId(String id) {
    return 'ID: $id';
  }

  @override
  String get manualTasks => 'Manuais';

  @override
  String get autoTasks => 'Automático';

  @override
  String get taskPayload => 'Dados da tarefa (payload):';

  @override
  String get computeAndSubmit => 'Calcular e enviar';

  @override
  String get noTasksAvailable =>
      'Não há tarefas disponíveis neste momento. \nTente mais tarde.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get taskSentSuccess => 'Tarefa enviada corretamente';

  @override
  String get totalCredits => 'Total de créditos';

  @override
  String get recentHistory => 'Histórico recente';

  @override
  String get noRecentActivity => 'Sem atividade recente';

  @override
  String creditEntry(String amount, String taskId) {
    return '$amount créditos · tarefa #$taskId';
  }

  @override
  String get streak => 'Onda';

  @override
  String get week => 'Semana';

  @override
  String get totalTasks => 'Total de tarefas';

  @override
  String get updateHistory => 'Atualizar';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get loginSubtitle => 'Acesse sua conta de doação de computação';

  @override
  String get registerSubtitle => 'Junte-se à rede de monitoramento ambiental';

  @override
  String get username => 'Usuário';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get keepSession => 'Manter sessão aberta';

  @override
  String get loginButton => 'Digitar';

  @override
  String get registerButton => 'Cadastrar-se';

  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  @override
  String get noAccount => 'Não tem conta? Cadastre-se';

  @override
  String get hasAccount => 'Já tem uma conta? Faça login';

  @override
  String get checkingSession => 'Verificando sessão...';

  @override
  String get donateTitle => 'Apoie a Eco\'clock Network';

  @override
  String get donateDescription =>
      '95% da sua doação é destinada diretamente às ONGs parceiras. Os 5% restantes são utilizados para a manutenção e o desenvolvimento da plataforma.';

  @override
  String get chooseAmount => 'Escolha uma quantidade';

  @override
  String get otherAmount => 'Outra quantidade';

  @override
  String get donateNow => 'Doar agora';

  @override
  String get donateRedirectInfo =>
      'Você será redirecionado para o Stripe para concluir o pagamento de forma segura. Quando a conta bancária estiver pronta, este link será atualizado.';

  @override
  String get paymentLinkError => 'Não foi possível abrir o link de pagamento';

  @override
  String get levelExplorer => 'Explorador';

  @override
  String get levelSensor => 'Sensor';

  @override
  String get levelSentinel => 'Sentinela';

  @override
  String get levelLighthouse => 'Farol';

  @override
  String nextLevel(String level) {
    return 'Próximo: $level';
  }

  @override
  String streakDays(int days) {
    return 'Onda $days d';
  }

  @override
  String get achievementFirstContribution => 'Primeira contribuição';

  @override
  String get achievementWeekActive => 'Semana ativa';

  @override
  String get achievementTwoHabitats => 'Dois habitats';

  @override
  String get achievementFirstNode => 'Primeiro nó';

  @override
  String get achievementHundredTasks => '100 tarefas';

  @override
  String get nodeCreate => 'Criar nó';

  @override
  String get nodeJoinByCode => 'Entrar com código';

  @override
  String get nodeName => 'Nome do nó';

  @override
  String get nodeCode => 'Código de convite';

  @override
  String get nodeLeave => 'Sair do nó';

  @override
  String get nodeDelete => 'Excluir nó';

  @override
  String get nodeRename => 'Renomear nó';

  @override
  String get nodeMembers => 'Membros';

  @override
  String get nodeRequests => 'Solicitações';

  @override
  String get nodePublic => 'Nós públicos';

  @override
  String get nodeJoinRequest => 'Solicitar entrada';

  @override
  String get nodeCreated => 'Nó criado com sucesso';

  @override
  String get nodeJoined => 'Você se juntou ao nó';

  @override
  String get nodeLeft => 'Você saiu do nó';

  @override
  String get nodeDeleted => 'Nó eliminado';

  @override
  String get nodeNameUpdated => 'Nome atualizado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Eliminar';

  @override
  String get leave => 'Sair';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleMember => 'Membro';

  @override
  String get logoFrame => 'Moldura do logotipo';

  @override
  String get noPendingRequests => 'Não há solicitações pendentes.';

  @override
  String get changeLogo => 'Mudar logo';

  @override
  String get transferLeadership => 'Transferir a liderança';

  @override
  String get kickMember => 'Expulsar';

  @override
  String get achievementsTitle => 'Conquistas';

  @override
  String get maxLevel => 'Nível máximo';

  @override
  String get noneFrame => 'Nenhum';

  @override
  String get uploading => 'Subindo...';

  @override
  String get wantsToJoin => 'Quer se juntar';

  @override
  String get inviteLink => 'Elo de ligação';

  @override
  String get completeExpeditionsForFrames =>
      'Conclua expedições para desbloquear marcos.';

  @override
  String get expeditionArcticName => 'Navegantes do Gelo';

  @override
  String get expeditionArcticDescription =>
      'Expedição de inverno: monitoramento do degelo ártico. Conclua tarefas e a atividade externa usando o mostrador para ganhar a conquista e colorir hexágonos na peça Ártico.';

  @override
  String get expeditionAutumnName => 'Expedição de outono';

  @override
  String get expeditionAutumnDescription =>
      'Expedição de outono: monitoramento da biodiversidade (fungos). Conclua tarefas da rede para avançar na meta coletiva.';

  @override
  String get navigatorBannerReady => 'O teu envelope de navegador está pronto';

  @override
  String get navigatorBannerSent =>
      'Envelope enviado — completa a atividade exterior';

  @override
  String get navigatorBannerValidated =>
      'Atividade exterior validada — Navegador do gelo!';

  @override
  String get navigatorSendButton => 'Enviar envelope';

  @override
  String get navigatorResendButton => 'Reenviar envelope';

  @override
  String get navigatorSending => 'A enviar…';

  @override
  String get navigatorSentSuccess => 'Envelope enviado! Verifica o teu email.';

  @override
  String navigatorSendError(String error) {
    return 'Erro ao enviar o envelope: $error';
  }

  @override
  String navigatorHexTasksCounter(
      int hexCount, int hexThreshold, int taskCount, int taskThreshold) {
    return '$hexCount/$hexThreshold hex · $taskCount/$taskThreshold tarefas';
  }

  @override
  String get impactMapTitle => 'Mapa de impacto';

  @override
  String get impactTileArctic => 'Ártico';

  @override
  String get impactTileMediterranean => 'Mediterrâneo';

  @override
  String get impactTabOnlyMe => 'Só eu';

  @override
  String get impactTabMyNode => 'O meu nó';

  @override
  String get impactTabNetwork => 'Rede';

  @override
  String get impactTabOnlyMeDesc => 'O teu impacto pessoal';

  @override
  String get impactTabMyNodeDesc => 'Impacto do teu nó';

  @override
  String get impactTabNetworkDesc => 'Impacto de toda a rede';

  @override
  String impactHexesUnlocked(int count) {
    return '$count hexágonos desbloqueados';
  }

  @override
  String impactTotalHexes(int total) {
    return 'Total: $total hexágonos';
  }

  @override
  String get impactNoHexes => 'Ainda não desbloqueaste hexágonos';

  @override
  String get impactGoldenHex => 'Hexágono dourado';

  @override
  String get impactNavigatorTitle => 'Navegadores do Gelo';

  @override
  String get impactScopeNodeSoon => 'Vista de nó: em breve';

  @override
  String get impactScopeNetworkSoon => 'Vista de rede: em breve';

  @override
  String get impactCenterMap => 'Centrar';

  @override
  String get impactArcticHint => 'Ártico · arrastar / zoom';

  @override
  String get impactNoHexesHint =>
      'Ainda não desbloqueaste hexágonos. Completa tarefas em zonas de impacto para colorir o mapa.';
}
