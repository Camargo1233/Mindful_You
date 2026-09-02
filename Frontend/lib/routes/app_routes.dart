import 'package:flutter/material.dart';

import '../telas/splashscreen_tela.dart';
import '../telas/login_tela.dart';
import '../telas/cadastro_tela.dart';
import '../telas/inicial_tela.dart';
import '../telas/questionario_tela.dart';
import '../telas/grafico_tela.dart';
import '../telas/historico_tela.dart';
import '../telas/registros_tela.dart';
import '../telas/perfil_tela.dart';
import '../telas/configuracoes_tela.dart';

class AppRoutes {
  static const splash = '/splashscreen';
  static const home = '/inicial';
  static const login = '/login';
  static const cadastro = '/cadastro';
  static const questionario = '/questionario';
  static const grafico = '/grafico';
  static const historico = '/historico';
  static const registros = '/relatorio';
  static const perfil = '/perfil';
  static const configuracao = '/configuracao';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreenTela(),
    login: (context) => const LoginTela(),
    cadastro: (context) => const CadastroTela(),
    home: (context) => const InicialTela(),
    questionario: (context) => const QuestionarioTela(),
    grafico: (context) => const GraficoTela(),
    historico: (context) => HistoricoTela(),
    registros: (context) => const RegistrosTela(),
    perfil: (context) => PerfilTela(),
    configuracao: (context) => const ConfiguracaoTela(),
  };
}
