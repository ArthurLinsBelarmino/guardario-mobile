import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'boas_vindas_screen.dart';
import 'kit_emergencia_screen.dart';
import 'login_screen.dart';
import 'meus_relatos_screen.dart';

/// Aba Perfil: dados do usuário e atalhos para Meus relatos e Kit.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key, this.usuarioNome});

  final String? usuarioNome;

  @override
  Widget build(BuildContext context) {
    final logado = usuarioNome != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(Espaco.m),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Espaco.m),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.azul,
                    child: Icon(logado ? Icons.person : Icons.person_outline, color: Colors.white),
                  ),
                  const SizedBox(width: Espaco.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuarioNome ?? 'Visitante',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(logado ? MockData.usuarioEmail : 'Entre para enviar relatos'),
                        Text('Área: ${MockData.area}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Espaco.m),
          Card(
            child: Column(
              children: [
                if (logado)
                  ListTile(
                    leading: const Icon(Icons.campaign, color: AppTheme.azul),
                    title: const Text('Meus relatos'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MeusRelatosScreen()),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.backpack, color: AppTheme.azul),
                  title: const Text('Kit de emergência'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const KitEmergenciaScreen()),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.phone_in_talk, color: AppTheme.azul),
                  title: Text('Defesa Civil: 199 · Bombeiros: 193'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Espaco.g),
          if (logado)
            OutlinedButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const BoasVindasScreen()),
                (route) => false,
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
            )
          else
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Entrar'),
            ),
        ],
      ),
    );
  }
}
