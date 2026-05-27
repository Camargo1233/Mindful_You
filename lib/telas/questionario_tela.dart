import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../menu/menulateral_tela.dart';
import '../data/historico_global.dart';

class QuestionarioTela extends StatefulWidget {
  const QuestionarioTela({super.key});

  @override
  State<QuestionarioTela> createState() => _QuestionarioTelaState();
}

class _QuestionarioTelaState extends State<QuestionarioTela> {
  int perguntaAtual = 0;

  final List<String> perguntas = [
    "Como está seu humor hoje?",
    "Você dormiu bem esta noite?",
    "Como está sua energia hoje?",
    "Você está se sentindo motivado?",
    "Seu nível de ansiedade hoje está como?",
    "Você conseguiu se concentrar hoje?",
    "Você se sente sobrecarregado?",
    "Como está sua autoestima hoje?",
    "Você teve momentos felizes hoje?",
    "Como está seu nível de estresse?",
    "Você conseguiu descansar hoje?",
    "Como você se sente agora?",
  ];

  final List<String> respostas = [
    "Muito Bom",
    "Bom",
    "Neutro",
    "Ruim",
    "Péssimo",
  ];

  List<String> respostasUsuario = [];

  Future<void> salvarDataQuestionario() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'ultimoQuestionario',
      DateTime.now().toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 200,
              child: Image.asset(
                'assets/img/4.png',
                width: 130,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: const Icon(
                              Icons.menu,
                              size: 34,
                              color: Color(0xFFB9AFA8),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/perfil');
                        },
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/img/3.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  Container(
                    width: double.infinity,
                    height: 255,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC89494),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.08,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 25,
                          left: 0,
                          right: 0,
                          child: Text(
                            "${perguntaAtual + 1}. Questão ${perguntaAtual + 1}/12",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: Text(
                              perguntas[perguntaAtual],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 45),
                  Expanded(
                    child: ListView.builder(
                      itemCount: respostas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 17,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              respostasUsuario.add(
                                respostas[index],
                              );

                              if (perguntaAtual < perguntas.length - 1) {
                                setState(() {
                                  perguntaAtual++;
                                });
                              } else {
                                double cansaco = 0;

                                double ansiedade = 0;

                                double sono = 0;

                                double produtividade = 0;

                                for (var resposta in respostasUsuario) {
                                  switch (resposta) {
                                    case "Muito Bom":
                                      produtividade += 10;
                                      sono += 8;
                                      break;

                                    case "Bom":
                                      produtividade += 7;
                                      sono += 6;
                                      break;

                                    case "Neutro":
                                      ansiedade += 5;
                                      cansaco += 5;
                                      break;

                                    case "Ruim":
                                      ansiedade += 8;
                                      cansaco += 8;
                                      break;

                                    case "Péssimo":
                                      ansiedade += 12;
                                      cansaco += 12;
                                      break;
                                  }
                                }

                                cansaco = cansaco.clamp(
                                  0,
                                  100,
                                );

                                ansiedade = ansiedade.clamp(
                                  0,
                                  100,
                                );

                                sono = sono.clamp(
                                  0,
                                  100,
                                );

                                produtividade = produtividade.clamp(
                                  0,
                                  100,
                                );

                                await salvarDataQuestionario();

                                historicoGlobal.add({
                                  "data":
                                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                                  "status": ansiedade >= 40
                                      ? "Ansiedade elevada"
                                      : cansaco >= 40
                                          ? "Cansaço emocional"
                                          : "Humor estável",
                                  "cor": ansiedade >= 40
                                      ? const Color(
                                          0xFFE8C3C5,
                                        )
                                      : cansaco >= 40
                                          ? const Color(
                                              0xFFC6B2B2,
                                            )
                                          : const Color(
                                              0xFFECC7AF,
                                            ),
                                  "perguntas": perguntas,
                                  "respostas": respostasUsuario,
                                  "dadosGrafico": {
                                    "cansaco": cansaco,
                                    "ansiedade": ansiedade,
                                    "sono": sono,
                                    "produtividade": produtividade,
                                  },
                                });

                                Navigator.pushReplacementNamed(
                                  context,
                                  '/grafico',
                                  arguments: {
                                    'cansaco': cansaco,
                                    'ansiedade': ansiedade,
                                    'sono': sono,
                                    'produtividade': produtividade,
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 3,
                              padding: const EdgeInsets.symmetric(
                                vertical: 17,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  18,
                                ),
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
          ],
        ),
      ),
    );
  }
}
