import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../menu/menulateral_tela.dart';

class InicialTela extends StatefulWidget {
  const InicialTela({super.key});

  @override
  State<InicialTela> createState() => _InicialTelaState();
}

class _InicialTelaState extends State<InicialTela> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -150,
              right: -160,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/img/6.png',
                  width: 420,
                  height: 320,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔝 TOPO
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
                              size: 32,
                              color: Color(0xFFB5ACA4),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/perfil',
                          );
                        },
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage(
                            'assets/img/3.jpg',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Olá, $nomeUsuario 👋",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Como você se sente hoje?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      emoji(
                        context,
                        'assets/img/7.png',
                        'Feliz',
                      ),
                      emoji(
                        context,
                        'assets/img/8.png',
                        'Calmo',
                      ),
                      emoji(
                        context,
                        'assets/img/9.png',
                        'Neutro',
                      ),
                      emoji(
                        context,
                        'assets/img/10.png',
                        'Cansado',
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Dicas para melhorar sua saúde mental",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: Column(
                      children: [
                        dicaCard(
                          "🗣️ Converse com alguém de confiança",
                          "Compartilhar o que sente reduz a carga emocional e melhora seu bem-estar.",
                          const Color(0xFFE8C3C5),
                        ),
                        dicaCard(
                          "🧠 Organize sua rotina",
                          "Ter horários definidos ajuda seu cérebro a funcionar melhor e reduz ansiedade.",
                          const Color(0xFFE7D1B7),
                        ),
                        dicaCard(
                          "📝 Escreva o que está sentindo",
                          "Colocar sentimentos no papel ajuda a entender melhor suas emoções.",
                          const Color(0xFFECC7AF),
                        ),
                      ],
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

  Widget emoji(
    BuildContext context,
    String path,
    String texto,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/questionario',
        );
      },
      child: Column(
        children: [
          Image.asset(
            path,
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 6),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget dicaCard(
    String titulo,
    String desc,
    Color cor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
