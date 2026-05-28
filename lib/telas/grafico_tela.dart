import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../menu/menulateral_tela.dart';
import '../services/api_service.dart';

class GraficoTela extends StatefulWidget {
  const GraficoTela({super.key});

  @override
  State<GraficoTela> createState() => _GraficoTelaState();
}

class _GraficoTelaState extends State<GraficoTela> {
  String nomeUsuario = 'Usuario';
  MockCheckIn? ultimoCheckIn;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
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

  Future<void> gerarPDF(Map<String, double> metricas) async {
    final pdf = pw.Document();
    final checkIn = ultimoCheckIn;

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Relatorio Mindful You',
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          pw.Text('Usuario: $nomeUsuario'),
          if (checkIn != null) pw.Text('Data: ${checkIn.formattedDate}'),
          if (checkIn != null) pw.Text('Humor inicial: ${checkIn.mood}'),
          if (checkIn != null) pw.Text('Status: ${checkIn.status}'),
          pw.SizedBox(height: 18),
          pw.Text('Indicadores emocionais'),
          pw.SizedBox(height: 8),
          ...metricas.entries.map(
            (entry) => pw.Text(
              '${entry.key}: ${entry.value.toStringAsFixed(0)}%',
            ),
          ),
          if (checkIn != null) ...[
            pw.SizedBox(height: 18),
            pw.Text('Respostas'),
            pw.SizedBox(height: 8),
            ...List.generate(checkIn.questions.length, (index) {
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(
                  '${index + 1}. ${checkIn.questions[index]} ${checkIn.answers[index]}',
                ),
              );
            }),
          ],
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'relatorio_mindful_you.pdf',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatorio PDF gerado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final metricas = _metricasDaRota(context);
    final cansaco = metricas['cansaco'] ?? 0;
    final ansiedade = metricas['ansiedade'] ?? 0;
    final sono = metricas['sono'] ?? 0;
    final produtividade = metricas['produtividade'] ?? 0;

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
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
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: const Icon(
                                Icons.menu,
                                size: 34,
                                color: Color(0xFFB5ACA4),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Perfil',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/perfil'),
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/img/3.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Text(
                      'Ola, $nomeUsuario',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ultimoCheckIn == null
                          ? 'Resultado emocional mockado'
                          : '${ultimoCheckIn!.mood} - ${ultimoCheckIn!.status}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Grafico',
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
                              _section(
                                color: const Color(0xFF4D79E6),
                                value: cansaco,
                                title: 'Cansaco',
                              ),
                              _section(
                                color: const Color(0xFFA483E6),
                                value: sono,
                                title: 'Sono',
                              ),
                              _section(
                                color: const Color(0xFFE9B366),
                                value: ansiedade,
                                title: 'Ansiedade',
                              ),
                              _section(
                                color: const Color(0xFFF3D34F),
                                value: produtividade,
                                title: 'Produtividade',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        botao(
                          'Historico',
                          Icons.history_rounded,
                          () => Navigator.pushNamed(context, '/historico'),
                        ),
                        botao(
                          'Relatorio',
                          Icons.picture_as_pdf_rounded,
                          () async => gerarPDF(metricas),
                        ),
                        botao(
                          'Novo check-in',
                          Icons.add_task_outlined,
                          () => Navigator.pushReplacementNamed(
                            context,
                            '/inicial',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    const Center(
                      child: Text(
                        'Dicas para melhorar\nsua saude mental',
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
                      'Priorize o sono',
                      'Dormir bem regula o humor, melhora a concentracao e reduz a ansiedade.',
                      const Color(0xFFE5BFC0),
                    ),
                    dicaCard(
                      'Mexa o corpo',
                      'Atividades fisicas ajudam no controle emocional e melhoram sua energia.',
                      const Color(0xFFE7C0A6),
                    ),
                    dicaCard(
                      'Tire um tempo para voce',
                      'Momentos de pausa ajudam a reduzir o estresse e organizar pensamentos.',
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

  Map<String, double> _metricasDaRota(BuildContext context) {
    final dados =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final fonte = dados ?? ultimoCheckIn?.metrics ?? const <String, double>{};

    return {
      'cansaco': _toDouble(fonte['cansaco'], fallback: 25),
      'ansiedade': _toDouble(fonte['ansiedade'], fallback: 15),
      'sono': _toDouble(fonte['sono'], fallback: 20),
      'produtividade': _toDouble(fonte['produtividade'], fallback: 40),
    };
  }

  double _toDouble(Object? value, {required double fallback}) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  PieChartSectionData _section({
    required Color color,
    required double value,
    required String title,
  }) {
    return PieChartSectionData(
      color: color,
      value: value <= 0 ? 1 : value,
      radius: 95,
      title: '$title\n${value.toInt()}%',
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      titlePositionPercentageOffset: 1.24,
    );
  }

  Widget botao(String texto, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 150,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE7DCCB),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        label: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget dicaCard(String titulo, String desc, Color cor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
