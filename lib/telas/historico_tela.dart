import 'package:flutter/material.dart';

import '../data/historico_global.dart';
import '../menu/menulateral_tela.dart';
import '../services/api_service.dart';

class HistoricoTela extends StatefulWidget {
  const HistoricoTela({super.key});

  @override
  State<HistoricoTela> createState() => _HistoricoTelaState();
}

class _HistoricoTelaState extends State<HistoricoTela> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<MockCheckIn> historicos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final dados = await MockApiService.loadCheckIns();
    await sincronizarHistoricoGlobal();

    if (!mounted) {
      return;
    }

    setState(() {
      historicos = dados;
      carregando = false;
    });
  }

  Future<void> _excluir(MockCheckIn item) async {
    await MockApiService.deleteCheckIn(item.id);
    await _carregarHistorico();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro removido.')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        tooltip: 'Abrir menu',
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                        icon: const Icon(
                          Icons.menu,
                          size: 34,
                          color: Color(0xFFB5ACA4),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Perfil',
                        onPressed: () =>
                            Navigator.pushNamed(context, '/perfil'),
                        icon: const CircleAvatar(
                          radius: 32,
                          backgroundImage: AssetImage('assets/img/3.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  IconButton(
                    tooltip: 'Voltar',
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/inicial',
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFFB5ACA4),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Historico',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: carregando
                        ? const Center(child: CircularProgressIndicator())
                        : historicos.isEmpty
                            ? _estadoVazio(context)
                            : ListView.builder(
                                itemCount: historicos.length,
                                itemBuilder: (context, index) {
                                  return historicoCard(
                                    context,
                                    historicos[index],
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

  Widget _estadoVazio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.event_note_outlined,
            size: 54,
            color: Color(0xFFC89494),
          ),
          const SizedBox(height: 12),
          const Text(
            'Nenhum relatorio ainda',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/inicial'),
            icon: const Icon(Icons.add),
            label: const Text('Fazer check-in'),
          ),
        ],
      ),
    );
  }

  Widget historicoCard(BuildContext context, MockCheckIn item) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.red.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Excluir registro'),
              content: const Text('Deseja remover este check-in do historico?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) => _excluir(item),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/relatorio',
            arguments: item.toLegacyMap(),
          );
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: item.color,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.formattedDate,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${item.mood} - ${item.status}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.white,
                size: 38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
