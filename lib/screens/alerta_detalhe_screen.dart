import 'package:flutter/material.dart';

import '../models/alerta.dart';
import '../theme/app_theme.dart';
import '../utils/formatos.dart';
import '../widgets/nivel_chip.dart';
import 'abrigos_screen.dart';

/// Tela 5: detalhe do alerta. Recebe o Alerta como parâmetro.
class AlertaDetalheScreen extends StatelessWidget {
  const AlertaDetalheScreen({super.key, required this.alerta});

  final Alerta alerta;

  @override
  Widget build(BuildContext context) {
    final passos = alerta.nivel.oQueFazer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do alerta'),
        backgroundColor: alerta.nivel.cor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(Espaco.m),
        children: [
          Row(
            children: [
              NivelChip(nivel: alerta.nivel),
              const SizedBox(width: Espaco.p),
              Text(alerta.ativo ? 'Ativo' : 'Encerrado'),
              const Spacer(),
              if (alerta.automatico)
                const Tooltip(
                  message: 'Gerado automaticamente pela estação',
                  child: Icon(Icons.sensors, color: Colors.black54),
                ),
            ],
          ),
          const SizedBox(height: Espaco.m),
          Text(alerta.titulo, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Espaco.p),
          Text('${alerta.area} · ${formatarDataHora(alerta.emitidoEm)}'),
          const SizedBox(height: Espaco.m),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Espaco.m),
              child: Text(alerta.mensagem),
            ),
          ),
          const SizedBox(height: Espaco.g),
          Text('O que fazer agora', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Espaco.p),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < passos.length; i++)
                  ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: alerta.nivel.cor,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    title: Text(passos[i]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Espaco.g),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AbrigosScreen(somenteComVagaInicial: true),
              ),
            ),
            icon: const Icon(Icons.home_work),
            label: const Text('Ver abrigos com vaga'),
          ),
        ],
      ),
    );
  }
}
