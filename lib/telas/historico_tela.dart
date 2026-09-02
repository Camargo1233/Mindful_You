import 'package:flutter/material.dart';
import '../data/historico_global.dart';
import '../menu/menulateral_tela.dart';

class HistoricoTela extends StatelessWidget {
  HistoricoTela({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final historicos = historicoGlobal;

    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -160,
              right: -190,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/img/6.png',
                  width: 460,
                  height: 360,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 34,
                          color: Color(
                            0xFFB5ACA4,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/perfil',
                          );
                        },
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage(
                            'assets/img/3.jpg',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/inicial',
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFFB5ACA4),
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Histórico",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 📄 LISTA HISTÓRICO
                  Expanded(
                    child: historicos.isEmpty
                        ? const Center(
                            child: Text(
                              "Nenhum relatório ainda",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: historicos.length,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              final item = historicos[index];

                              return historicoCard(
                                context,
                                item,
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

  Widget historicoCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/relatorio',
          arguments: item,
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 18,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: item['cor'],
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['data'],
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['status'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.picture_as_pdf_rounded,
              color: Colors.white,
              size: 38,
            ),
          ],
        ),
      ),
    );
  }
}
