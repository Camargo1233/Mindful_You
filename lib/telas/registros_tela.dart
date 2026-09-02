import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class RegistrosTela extends StatelessWidget {
  const RegistrosTela({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dados =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
            {};
    final List<String> perguntas =
        (dados['perguntas'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final List<String> respostas =
        (dados['respostas'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Relatório",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: perguntas.isEmpty
          ? const Center(
              child: Text(
                "Nenhum relatório encontrado.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: perguntas.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
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
              },
            ),
      floatingActionButton: perguntas.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFFC89494),
              onPressed: () async {
                final pdf = pw.Document();

                pdf.addPage(
                  pw.MultiPage(
                    build: (context) => [
                      pw.Text(
                        "Relatório Mindful You",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      ...List.generate(
                        perguntas.length,
                        (index) {
                          return pw.Container(
                            margin: const pw.EdgeInsets.only(bottom: 15),
                            padding: const pw.EdgeInsets.all(12),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  perguntas[index],
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.SizedBox(height: 8),
                                pw.Text(
                                  respostas[index],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );

                final dir = await getApplicationDocumentsDirectory();

                final file = File(
                  '${dir.path}/relatorio_mindful_you.pdf',
                );

                await file.writeAsBytes(
                  await pdf.save(),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'PDF baixado com sucesso!',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              ),
              label: const Text(
                "Baixar PDF",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
