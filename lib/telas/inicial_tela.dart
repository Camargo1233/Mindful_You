import 'package:flutter/material.dart';

import '../menu/menulateral_tela.dart';
import '../services/api_service.dart';

class InicialTela extends StatefulWidget {
  const InicialTela({super.key});

  @override
  State<InicialTela> createState() => _InicialTelaState();
}

class _InicialTelaState extends State<InicialTela> {
  String nomeUsuario = 'Usuario';
  MockCheckIn? ultimoCheckIn;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final usuario = await MockApiService.currentUser();
    final checkIn = await MockApiService.lastCheckIn();

    if (!mounted) {
      return;
    }

    setState(() {
      nomeUsuario = usuario?.name ?? 'Usuario';
      ultimoCheckIn = checkIn;
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              size: 32,
                              color: Color(0xFFB5ACA4),
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
                  const SizedBox(height: 20),
                  Text(
                    'Ola, $nomeUsuario',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (ultimoCheckIn != null) ...[
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/grafico',
                          arguments: ultimoCheckIn!.metrics,
                        );
                      },
                      icon: const Icon(Icons.insights_outlined),
                      label: Text(
                        'Ultimo check-in: ${ultimoCheckIn!.status}',
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const Text(
                    'Como voce se sente hoje?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      emoji(context, 'assets/img/7.png', 'Feliz'),
                      emoji(context, 'assets/img/8.png', 'Calmo'),
                      emoji(context, 'assets/img/9.png', 'Neutro'),
                      emoji(context, 'assets/img/10.png', 'Cansado'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Dicas para melhorar sua saude mental',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Ver historico',
                        onPressed: () =>
                            Navigator.pushNamed(context, '/historico'),
                        icon: const Icon(Icons.history_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: [
                        dicaCard(
                          'Converse com alguem de confianca',
                          'Compartilhar o que sente reduz a carga emocional e melhora seu bem-estar.',
                          const Color(0xFFE8C3C5),
                        ),
                        dicaCard(
                          'Organize sua rotina',
                          'Ter horarios definidos ajuda seu cerebro a funcionar melhor e reduz ansiedade.',
                          const Color(0xFFE7D1B7),
                        ),
                        dicaCard(
                          'Escreva o que esta sentindo',
                          'Colocar sentimentos no papel ajuda a entender melhor suas emocoes.',
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

  Widget emoji(BuildContext context, String path, String texto) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(context, '/questionario', arguments: texto);
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Image.asset(path, width: 48, height: 48),
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
      ),
    );
  }

  Widget dicaCard(String titulo, String desc, Color cor) {
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
