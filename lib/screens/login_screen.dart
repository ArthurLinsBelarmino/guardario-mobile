import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'home_shell.dart';

/// Tela 2: login com Form + GlobalKey e validação.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) return 'Informe o e-mail.';
    final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formato.hasMatch(email)) return 'E-mail inválido.';
    return null; // null = campo válido
  }

  String? _validarSenha(String? valor) {
    final senha = valor ?? '';
    if (senha.isEmpty) return 'Informe a senha.';
    if (senha.length < 6) return 'A senha tem pelo menos 6 caracteres.';
    return null;
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim().toLowerCase();
    final senha = _senhaController.text;

    if (email != MockData.usuarioEmail || senha != MockData.usuarioSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('E-mail ou senha incorretos.'),
        ),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeShell(usuarioNome: MockData.usuarioNome)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Espaco.g),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.water_drop, size: 64, color: AppTheme.azul),
                const SizedBox(height: Espaco.m),
                Text(
                  'Entre para enviar relatos à Defesa Civil.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: Espaco.g),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: _validarEmail,
                ),
                const SizedBox(height: Espaco.m),
                TextFormField(
                  controller: _senhaController,
                  obscureText: _ocultarSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_ocultarSenha ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                    ),
                  ),
                  validator: _validarSenha,
                ),
                const SizedBox(height: Espaco.g),
                FilledButton(onPressed: _entrar, child: const Text('Entrar')),
                const SizedBox(height: Espaco.m),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Espaco.m),
                    child: Text(
                      'Usuário de teste:\n${MockData.usuarioEmail} / ${MockData.usuarioSenha}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
