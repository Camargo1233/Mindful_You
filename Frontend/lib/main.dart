import 'package:flutter/material.dart';

import 'telas/splashscreen_tela.dart';
import 'telas/login_tela.dart';
import 'telas/cadastro_tela.dart';
import 'telas/inicial_tela.dart';
import 'telas/perfil_tela.dart';
import 'telas/historico_tela.dart';
import 'telas/questionario_tela.dart';
import 'telas/grafico_tela.dart';
import 'telas/registros_tela.dart';
import 'telas/configuracoes_tela.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mindful You',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF7F4F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC89494),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => const SplashScreenTela(),
        '/login': (context) => const LoginTela(),
        '/cadastro': (context) => const CadastroTela(),
        '/inicial': (context) => const InicialTela(),
        '/perfil': (context) => PerfilTela(),
        '/historico': (context) => HistoricoTela(),
        '/questionario': (context) => const QuestionarioTela(),
        '/grafico': (context) => const GraficoTela(),
        '/relatorio': (context) => const RegistrosTela(),
        '/configuracao': (context) => const ConfiguracaoTela(),
      },
    );
  }
}
