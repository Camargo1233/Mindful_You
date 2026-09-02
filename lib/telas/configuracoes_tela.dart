import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracaoTela extends StatefulWidget {
  const ConfiguracaoTela({super.key});

  @override
  State<ConfiguracaoTela> createState() => _ConfiguracaoTelaState();
}

class _ConfiguracaoTelaState extends State<ConfiguracaoTela> {
  bool notificacao = false;

  bool temaEscuro = false;

  String nomeUsuario = "Tio Chico";

  String emailUsuario = "tio.chico@gmail.com";

  @override
  void initState() {
    super.initState();

    carregarDados();
  }

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nomeUsuario = prefs.getString('nomeUsuario') ?? "Tio Chico";

      emailUsuario = prefs.getString('emailUsuario') ?? "tio.chico@gmail.com";

      notificacao = prefs.getBool('notificacao') ?? false;

      temaEscuro = prefs.getBool('temaEscuro') ?? false;
    });
  }

  Future<void> salvarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      'notificacao',
      notificacao,
    );

    await prefs.setBool(
      'temaEscuro',
      temaEscuro,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F1ED,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close,
                      size: 28,
                      color: Color(
                        0xFFC8BEB6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Gerenciamento\nde Conta",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 55),
                  const Text(
                    "Informações da Conta",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    nomeUsuario,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email: $emailUsuario",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFE8DCCF,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Editar informações",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Privacidade",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    "Alterar senha",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 38),
                  const Text(
                    "Preferências",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Notificações",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Switch(
                        value: notificacao,
                        activeColor: const Color(
                          0xFFC7B7A5,
                        ),
                        onChanged: (
                          value,
                        ) {
                          setState(() {
                            notificacao = value;
                          });

                          salvarPreferencias();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tema claro/escuro",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Switch(
                        value: temaEscuro,
                        activeColor: const Color(
                          0xFFC7B7A5,
                        ),
                        onChanged: (
                          value,
                        ) {
                          setState(() {
                            temaEscuro = value;
                          });

                          salvarPreferencias();
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    "Zona Sensível",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Excluir conta permanentemente",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
