import 'package:flutter/material.dart';

import '../services/api_service.dart';

class MenuLateral extends StatefulWidget {
  const MenuLateral({super.key});

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  String nomeUsuario = 'Usuario';
  String emailUsuario = '';

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    final usuario = await MockApiService.currentUser();

    if (!mounted) {
      return;
    }

    setState(() {
      nomeUsuario = usuario?.name ?? 'Usuario';
      emailUsuario = usuario?.email ?? '';
    });
  }

  Future<void> abrirInicio(BuildContext context) async {
    final ultimo = await MockApiService.lastCheckIn();

    if (!context.mounted) {
      return;
    }

    if (ultimo == null) {
      Navigator.pushReplacementNamed(context, '/inicial');
      return;
    }

    final diferenca = DateTime.now().difference(ultimo.createdAt);
    Navigator.pushReplacementNamed(
      context,
      diferenca.inHours < 24 ? '/grafico' : '/inicial',
      arguments: diferenca.inHours < 24 ? ultimo.metrics : null,
    );
  }

  Future<void> _sair(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('Sair da conta'),
          content: const Text('Tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC89494),
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    await MockApiService.logout();

    if (!context.mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        backgroundImage: AssetImage('assets/img/3.jpg'),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nomeUsuario,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              emailUsuario.isEmpty
                                  ? 'Mindful You'
                                  : emailUsuario,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  itemMenu(
                    Icons.home_rounded,
                    'Inicio',
                    onTap: () async {
                      Navigator.pop(context);
                      await abrirInicio(context);
                    },
                  ),
                  itemMenu(
                    Icons.history_rounded,
                    'Historico',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/historico');
                    },
                  ),
                  itemMenu(
                    Icons.person_rounded,
                    'Perfil',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/perfil');
                    },
                  ),
                  itemMenu(
                    Icons.settings_rounded,
                    'Configuracoes',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/configuracao');
                    },
                  ),
                  const Spacer(),
                  itemMenu(
                    Icons.logout_rounded,
                    'Sair',
                    onTap: () async {
                      Navigator.pop(context);
                      await _sair(context);
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
    IconData icon,
    String texto, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 26, color: const Color(0xFFC89494)),
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
