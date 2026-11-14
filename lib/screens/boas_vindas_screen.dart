import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_shell.dart';
import 'login_screen.dart';

class BoasVindasScreen extends StatelessWidget {
  const BoasVindasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.azul,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Espaco.g),
          child: Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset('assets/logo.png', width: 140, height: 140),
              ),
              const SizedBox(height: Espaco.g),
              const Text(
                'GuardaRio',
                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: Espaco.p),
              const Text(
                'O rio avisa antes de subir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.azul,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: const Text('Entrar'),
                ),
              ),
              const SizedBox(height: Espaco.m),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                  ),
                  child: const Text('Continuar sem conta'),
                ),
              ),
              const SizedBox(height: Espaco.m),
              const Text(
                'Alertas, abrigos e nível do rio não exigem login.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
