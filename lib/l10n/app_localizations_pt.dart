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
}
