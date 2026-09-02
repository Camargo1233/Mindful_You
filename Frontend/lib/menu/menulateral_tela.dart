import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLateral extends StatefulWidget {
  const MenuLateral({super.key});

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  String nomeUsuario = "Tio Chico";

  @override
  void initState() {
    super.initState();

    carregarNome();
  }

  Future<void> carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nomeUsuario = prefs.getString('nomeUsuario') ?? "Tio Chico";
    });
  }

  Future<void> abrirInicio(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final ultimaResposta = prefs.getString('ultimoQuestionario');

    if (ultimaResposta == null) {
      Navigator.pushReplacementNamed(
        context,
        '/inicial',
      );

      return;
    }

    final dataResposta = DateTime.parse(ultimaResposta);

    final agora = DateTime.now();

    final diferenca = agora.difference(dataResposta);

    if (diferenca.inHours < 24) {
      Navigator.pushReplacementNamed(
        context,
        '/grafico',
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/inicial',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: -120,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/img/6.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage(
                          'assets/img/3.jpg',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeUsuario,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Mindful You",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  itemMenu(
                    context,
                    Icons.home_rounded,
                    "Início",
                    onTap: () async {
                      Navigator.pop(context);

                      await abrirInicio(
                        context,
                      );
                    },
                  ),
                  itemMenu(
                    context,
                    Icons.history_rounded,
                    "Histórico",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacementNamed(
                        context,
                        '/historico',
                      );
                    },
                  ),
                  itemMenu(
                    context,
                    Icons.person_rounded,
                    "Perfil",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacementNamed(
                        context,
                        '/perfil',
                      );
                    },
                  ),
                  itemMenu(
                    context,
                    Icons.settings_rounded,
                    "Configurações",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.pushReplacementNamed(
                        context,
                        '/configuracao',
                      );
                    },
                  ),
                  const Spacer(),
                  itemMenu(
                    context,
                    Icons.logout_rounded,
                    "Sair",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                22,
                              ),
                            ),
                            title: const Text(
                              "Sair da conta",
                            ),
                            content: const Text(
                              "Tem certeza que deseja sair?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text(
                                  "Cancelar",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                    0xFFC89494,
                                  ),
                                ),
                                child: const Text(
                                  "Sair",
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemMenu(
    BuildContext context,
    IconData icon,
    String texto, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.05,
                ),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 26,
                color: const Color(
                  0xFFC89494,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
