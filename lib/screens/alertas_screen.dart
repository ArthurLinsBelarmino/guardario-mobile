import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/alerta.dart';
import '../theme/app_theme.dart';
import '../utils/formatos.dart';
import 'alerta_detalhe_screen.dart';

/// Tela 4: lista de alertas (ListView) com cards coloridos por nível.
class AlertasScreen extends StatelessWidget {
  const AlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertas = MockData.alertas;

    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: alertas.isEmpty
          ? const Center(child: Text('Nenhum alerta para a sua área.'))
          : ListView.separated(
              padding: const EdgeInsets.all(Espaco.m),
              itemCount: alertas.length,
              separatorBuilder: (_, __) => const SizedBox(height: Espaco.p),
              itemBuilder: (context, i) => _CardAlerta(alerta: alertas[i]),
            ),
    );
  }
}

class _CardAlerta extends StatelessWidget {
  const _CardAlerta({required this.alerta});

  final Alerta alerta;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: alerta.ativo ? 1 : 0.6,
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: Espaco.m, vertical: Espaco.p),
          leading: CircleAvatar(
            backgroundColor: alerta.nivel.cor,
            child: Icon(alerta.nivel.icone, color: Colors.white),
          ),
          title: Text(alerta.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${alerta.area} · ${formatarDataHora(alerta.emitidoEm)}'),
          trailing: Chip(
            label: Text(alerta.ativo ? 'ATIVO' : 'ENCERRADO'),
            backgroundColor: alerta.ativo ? alerta.nivel.cor.withAlpha(40) : null,
            visualDensity: VisualDensity.compact,
          ),
          // Passagem de parâmetro: o objeto Alerta vai pelo construtor.
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AlertaDetalheScreen(alerta: alerta)),
          ),
        ),
      ),
    );
  }
}
