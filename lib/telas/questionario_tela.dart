import 'package:flutter/material.dart';

import '../data/historico_global.dart';
import '../menu/menulateral_tela.dart';
import '../services/api_service.dart';

class QuestionarioTela extends StatefulWidget {
  const QuestionarioTela({super.key});

  @override
  State<QuestionarioTela> createState() => _QuestionarioTelaState();
}

class _QuestionarioTelaState extends State<QuestionarioTela> {
  int perguntaAtual = 0;
  bool salvando = false;

  final List<String> perguntas = const [
    'Como esta seu humor hoje?',
    'Voce dormiu bem esta noite?',
    'Como esta sua energia hoje?',
    'Voce esta se sentindo motivado?',
    'Seu nivel de ansiedade hoje esta como?',
    'Voce conseguiu se concentrar hoje?',
    'Voce se sente sobrecarregado?',
    'Como esta sua autoestima hoje?',
    'Voce teve momentos felizes hoje?',
    'Como esta seu nivel de estresse?',
    'Voce conseguiu descansar hoje?',
    'Como voce se sente agora?',
  ];

  final List<String> respostas = const [
    'Muito bom',
    'Bom',
    'Neutro',
    'Ruim',
    'Pessimo',
  ];

  final List<String> respostasUsuario = [];

  @override
  Widget build(BuildContext context) {
    final mood =
        ModalRoute.of(context)?.settings.arguments?.toString() ?? 'Neutro';
    final progresso = (perguntaAtual + 1) / perguntas.length;

    return Scaffold(
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 200,
              child: Image.asset('assets/img/4.png', width: 130),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            tooltip: 'Abrir menu',
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(
                              Icons.menu,
                              size: 34,
                              color: Color(0xFFB9AFA8),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Perfil',
                        onPressed: () =>
                            Navigator.pushNamed(context, '/perfil'),
                        icon: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/img/3.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Check-in: $mood',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progresso,
                    color: const Color(0xFFC89494),
                    backgroundColor: const Color(0xFFF0E7E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 230),
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC89494),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Questao ${perguntaAtual + 1}/${perguntas.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          perguntas[perguntaAtual],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (perguntaAtual > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: salvando ? null : _voltarPergunta,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar pergunta'),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: respostas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ElevatedButton(
                            onPressed: salvando
                                ? null
                                : () => _responder(respostas[index], mood),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              respostas[index],
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (salvando)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x66FFFFFF),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _voltarPergunta() {
    setState(() {
      perguntaAtual--;
      respostasUsuario.removeLast();
    });
  }

  Future<void> _responder(String resposta, String mood) async {
    respostasUsuario.add(resposta);

    if (perguntaAtual < perguntas.length - 1) {
      setState(() => perguntaAtual++);
      return;
    }

    setState(() => salvando = true);

    final metrics = _calcularMetricas(respostasUsuario);
    final checkIn = await MockApiService.saveCheckIn(
      mood: mood,
      questions: perguntas,
      answers: List<String>.from(respostasUsuario),
      metrics: metrics,
    );
    await sincronizarHistoricoGlobal();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/grafico',
      arguments: checkIn.metrics,
    );
  }

  Map<String, double> _calcularMetricas(List<String> respostas) {
    var cansaco = 0.0;
    var ansiedade = 0.0;
    var sono = 0.0;
    var produtividade = 0.0;

    for (var index = 0; index < respostas.length; index++) {
      final valor = _valorResposta(respostas[index]);
      final invertido = 5 - valor;

      switch (index) {
        case 1:
        case 10:
          sono += invertido * 10;
          break;
        case 4:
        case 6:
        case 9:
          ansiedade += invertido * 8;
          cansaco += invertido * 4;
          break;
        case 2:
        case 3:
        case 5:
          produtividade += valor * 8;
          cansaco += invertido * 3;
          break;
        default:
          produtividade += valor * 4;
          ansiedade += invertido * 3;
      }
    }

    return {
      'cansaco': cansaco.clamp(0, 100).toDouble(),
      'ansiedade': ansiedade.clamp(0, 100).toDouble(),
      'sono': sono.clamp(0, 100).toDouble(),
      'produtividade': produtividade.clamp(0, 100).toDouble(),
    };
  }

  int _valorResposta(String resposta) {
    switch (resposta) {
      case 'Muito bom':
        return 5;
      case 'Bom':
        return 4;
      case 'Neutro':
        return 3;
      case 'Ruim':
        return 2;
      default:
        return 1;
    }
  }
}
