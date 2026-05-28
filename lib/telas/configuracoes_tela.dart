import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ConfiguracaoTela extends StatefulWidget {
  const ConfiguracaoTela({super.key});

  @override
  State<ConfiguracaoTela> createState() => _ConfiguracaoTelaState();
}

class _ConfiguracaoTelaState extends State<ConfiguracaoTela> {
  bool notificacao = true;
  bool temaEscuro = false;
  MockUser? usuario;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final user = await MockApiService.currentUser();
    final prefs = await MockApiService.loadPreferences();

    if (!mounted) {
      return;
    }

    setState(() {
      usuario = user;
      notificacao = prefs['notifications'] ?? true;
      temaEscuro = prefs['darkTheme'] ?? false;
    });
  }

  Future<void> salvarPreferencias() async {
    await MockApiService.savePreferences(
      notifications: notificacao,
      darkTheme: temaEscuro,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: 'Fechar',
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/inicial');
                        }
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 28,
                        color: Color(0xFFC8BEB6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Gerenciamento\nde Conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const _SecaoTitulo('Informacoes da Conta'),
                  const SizedBox(height: 16),
                  Text(
                    usuario?.name ?? 'Usuario',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: ${usuario?.email ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: _editarInformacoes,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar informacoes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8DCCF),
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 34),
                  const _SecaoTitulo('Privacidade'),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.password_outlined),
                    title: const Text('Alterar senha'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _alterarSenha,
                  ),
                  const SizedBox(height: 22),
                  const _SecaoTitulo('Preferencias'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notificacoes'),
                    subtitle: const Text(
                        'Mock: lembrete local sera conectado depois.'),
                    value: notificacao,
                    activeThumbColor: const Color(0xFFC7B7A5),
                    onChanged: (value) async {
                      setState(() => notificacao = value);
                      await salvarPreferencias();
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tema escuro'),
                    subtitle:
                        const Text('Preferencia salva para a futura versao.'),
                    value: temaEscuro,
                    activeThumbColor: const Color(0xFFC7B7A5),
                    onChanged: (value) async {
                      setState(() => temaEscuro = value);
                      await salvarPreferencias();
                      _mostrarMensagem(
                        'Preferencia salva. Tema dinamico entra na proxima etapa.',
                      );
                    },
                  ),
                  const SizedBox(height: 34),
                  const _SecaoTitulo('Zona Sensivel'),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _excluirConta,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Excluir conta permanentemente',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editarInformacoes() async {
    final nomeController = TextEditingController(text: usuario?.name ?? '');
    final emailController = TextEditingController(text: usuario?.email ?? '');

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Editar informacoes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
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
                      _mostrarMensagem('Informacoes atualizadas.');
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
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        );
      },
    );

    nomeController.dispose();
    emailController.dispose();
  }

  Future<void> _alterarSenha() async {
    final senhaAtualController = TextEditingController();
    final novaSenhaController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: senhaAtualController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha atual',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: novaSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova senha',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await MockApiService.changePassword(
                    currentPassword: senhaAtualController.text,
                    newPassword: novaSenhaController.text,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pop(context);
                  _mostrarMensagem('Senha alterada.');
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
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    senhaAtualController.dispose();
    novaSenhaController.dispose();
  }

  Future<void> _excluirConta() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir conta'),
          content: const Text(
            'Esta acao remove usuario, sessao e historico mockado deste aparelho.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    await MockApiService.deleteAccount();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _mostrarMensagem(String mensagem) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }
}

class _SecaoTitulo extends StatelessWidget {
  const _SecaoTitulo(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
