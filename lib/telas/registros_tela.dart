import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RegistrosTela extends StatelessWidget {
  const RegistrosTela({super.key});

  @override
  Widget build(BuildContext context) {
    final dados =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    final perguntas =
        (dados['perguntas'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final respostas =
        (dados['respostas'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final metricas = dados['dadosGrafico'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Relatorio',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (perguntas.isNotEmpty)
            IconButton(
              tooltip: 'Compartilhar PDF',
              onPressed: () => _gerarPdf(context, dados, perguntas, respostas),
              icon: const Icon(Icons.picture_as_pdf_outlined),
            ),
        ],
      ),
      body: perguntas.isEmpty
          ? const Center(
              child: Text(
                'Nenhum relatorio encontrado.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _ResumoCard(dados: dados, metricas: metricas),
                const SizedBox(height: 16),
                ...List.generate(perguntas.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          perguntas[index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D5D5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            respostas[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 80),
              ],
            ),
      floatingActionButton: perguntas.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFFC89494),
              onPressed: () => _gerarPdf(context, dados, perguntas, respostas),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'Baixar PDF',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Future<void> _gerarPdf(
    BuildContext context,
    Map<String, dynamic> dados,
    List<String> perguntas,
    List<String> respostas,
  ) async {
    final metricas = dados['dadosGrafico'] as Map<String, dynamic>? ?? {};
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Relatorio Mindful You',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Text('Data: ${dados['data'] ?? '-'}'),
          pw.Text('Humor: ${dados['humor'] ?? '-'}'),
          pw.Text('Status: ${dados['status'] ?? '-'}'),
          pw.SizedBox(height: 18),
          pw.Text('Indicadores'),
          ...metricas.entries.map(
            (entry) => pw.Text('${entry.key}: ${entry.value}%'),
          ),
          pw.SizedBox(height: 18),
          ...List.generate(perguntas.length, (index) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    perguntas[index],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(respostas[index]),
                ],
              ),
            );
          }),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'relatorio_mindful_you.pdf',
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatorio PDF gerado.')),
      );
    }
  }
}

class _ResumoCard extends StatelessWidget {
  const _ResumoCard({
    required this.dados,
    required this.metricas,
  });

  final Map<String, dynamic> dados;
  final Map<String, dynamic> metricas;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8D5D5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dados['status']?.toString() ?? 'Resumo emocional',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Data: ${dados['data'] ?? '-'}'),
          Text('Humor inicial: ${dados['humor'] ?? '-'}'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: metricas.entries.map((entry) {
              return Chip(
                label: Text('${entry.key}: ${entry.value.toString()}%'),
                backgroundColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
