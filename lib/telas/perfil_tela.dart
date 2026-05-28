import 'package:flutter/material.dart';

import '../menu/menulateral_tela.dart';
import '../services/api_service.dart';

class PerfilTela extends StatefulWidget {
  const PerfilTela({super.key});

  @override
  State<PerfilTela> createState() => _PerfilTelaState();
}

class _PerfilTelaState extends State<PerfilTela> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String fotoPerfil = 'assets/img/3.jpg';
  MockUser? usuario;
  int totalCheckIns = 0;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final user = await MockApiService.currentUser();
    final historico = await MockApiService.loadCheckIns();

    if (!mounted) {
      return;
    }

    setState(() {
      usuario = user;
      totalCheckIns = historico.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = usuario;
    final criadoEm = user == null
        ? '--/--/----'
        : '${user.createdAt.day.toString().padLeft(2, '0')}/${user.createdAt.month.toString().padLeft(2, '0')}/${user.createdAt.year}';

    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuLateral(),
      backgroundColor: const Color(0xFFF7F4F1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              color: const Color(0xFFE7E0D8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 18,
                    left: 18,
                    child: IconButton(
                      tooltip: 'Abrir menu',
                      onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        size: 34,
                        color: Color(0xFFB5ACA4),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -70,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 155,
                            height: 155,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(fotoPerfil),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _mostrarFotoMock,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9DDCF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
            Text(
              user?.name ?? 'Usuario',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Membro desde $criadoEm',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Chip(
              avatar: const Icon(Icons.check_circle_outline, size: 18),
              label: Text('$totalCheckIns check-ins registrados'),
              backgroundColor: const Color(0xFFE9DDCF),
            ),
            const SizedBox(height: 34),
            botao('Editar', Icons.edit_outlined, mostrarEditarPerfil),
            const SizedBox(height: 16),
            botao(
              'Historico',
              Icons.history_rounded,
              () => Navigator.pushNamed(context, '/historico'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: botao('Sair', Icons.logout_rounded, mostrarDialogLogout),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarFotoMock() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mock: upload de foto sera integrado ao backend futuro.'),
      ),
    );
  }

  void mostrarEditarPerfil() {
    final nomeController = TextEditingController(text: usuario?.name ?? '');
    final emailController = TextEditingController(text: usuario?.email ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            top: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Editar perfil',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: nomeController,
                textCapitalization: TextCapitalization.words,
                decoration: _sheetDecoration('Nome'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _sheetDecoration('Email'),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await MockApiService.updateProfile(
                        name: nomeController.text,
                        email: emailController.text,
                      );
                      await carregarDados();

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perfil atualizado.')),
                      );
                    } catch (error) {
                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString().replaceFirst('Exception: ', ''),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC89494),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      nomeController.dispose();
      emailController.dispose();
    });
  }

  void mostrarDialogLogout() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text('Sair da conta'),
          content: const Text('Tem certeza que deseja deslogar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await MockApiService.logout();

                if (!context.mounted) {
                  return;
                }

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC89494),
              ),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  Widget botao(String texto, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 170,
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black87, size: 19),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE9DDCF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        label: Text(
          texto,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  InputDecoration _sheetDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF3EEE8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}
