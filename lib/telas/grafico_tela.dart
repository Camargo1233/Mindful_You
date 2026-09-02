import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../menu/menulateral_tela.dart';

class GraficoTela extends StatefulWidget {
  const GraficoTela({super.key});

  @override
  State<GraficoTela> createState() => _GraficoTelaState();
}

class _GraficoTelaState extends State<GraficoTela> {
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

  Future<void> gerarPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            "Relatório Mindful You",
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 25),
          pw.Text(
            "Usuário: $nomeUsuario",
            style: const pw.TextStyle(fontSize: 18),
          ),
          pw.SizedBox(height: 15),
          pw.Text(
            "Resultado emocional do questionário.",
            style: const pw.TextStyle(fontSize: 16),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      '${dir.path}/relatorio_mindful_you.pdf',
    );

    await file.writeAsBytes(await pdf.save());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "PDF baixado com sucesso!",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dados =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};

    final double cansaco = (dados['cansaco'] ?? 55).toDouble();

    final double ansiedade = (dados['ansiedade'] ?? 15).toDouble();

    final double sono = (dados['sono'] ?? 25).toDouble();

    final double produtividade = (dados['produtividade'] ?? 5).toDouble();

    return Scaffold(
      drawer: const MenuLateral(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -130,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/img/6.png',
                  width: 340,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: SingleChildScrollView(
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
                                color: Color(
                                  0xFFB5ACA4,
                                ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(
                                    0,
                                    4,
                                  ),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/img/3.jpg',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Text(
                      "Olá, $nomeUsuario 👋",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 35),
                    const Text(
                      "Gráfico",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: 270,
                        height: 270,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            borderData: FlBorderData(show: false),
                            sections: [
                              PieChartSectionData(
                                color: const Color(
                                  0xFF4D79E6,
                                ),
                                value: cansaco,
                                radius: 95,
                                title: "Cansaço\n${cansaco.toInt()}%",
                                titleStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                titlePositionPercentageOffset: 1.22,
                              ),
                              PieChartSectionData(
                                color: const Color(
                                  0xFFA483E6,
                                ),
                                value: sono,
                                radius: 95,
                                title: "Falta de Sono\n${sono.toInt()}%",
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                titlePositionPercentageOffset: 1.20,
                              ),
                              PieChartSectionData(
                                color: const Color(
                                  0xFFE9B366,
                                ),
                                value: ansiedade,
                                radius: 95,
                                title: "Ansiedade\n${ansiedade.toInt()}%",
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                titlePositionPercentageOffset: 1.23,
                              ),
                              PieChartSectionData(
                                color: const Color(
                                  0xFFF3D34F,
                                ),
                                value: produtividade,
                                radius: 95,
                                title:
                                    "Produtividade\n${produtividade.toInt()}%",
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                titlePositionPercentageOffset: 1.35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        botao(
                          context,
                          "Histórico",
                          () {
                            Navigator.pushNamed(
                              context,
                              '/historico',
                            );
                          },
                        ),
                        botao(
                          context,
                          "Gerar relatório",
                          () async {
                            await gerarPDF();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Dicas para melhorar\nsua saúde mental",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    dicaCard(
                      "😴 Priorize o sono",
                      "Dormir bem regula o humor, melhora a concentração e reduz a ansiedade.",
                      const Color(0xFFE5BFC0),
                    ),
                    dicaCard(
                      "🏃 Mexa o corpo",
                      "Atividades físicas ajudam muito no controle emocional.",
                      const Color(0xFFE7C0A6),
                    ),
                    dicaCard(
                      "🧘 Tire um tempo para você",
                      "Momentos de pausa ajudam a reduzir o estresse.",
                      const Color(0xFFD9CFC7),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget botao(
    BuildContext context,
    String texto,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 145,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFFE7DCCB,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget dicaCard(
    String titulo,
    String desc,
    Color cor,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
