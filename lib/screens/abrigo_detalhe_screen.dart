import 'package:flutter/material.dart';

import '../models/abrigo.dart';
import '../theme/app_theme.dart';

/// Tela 7: detalhe do abrigo. Recebe o Abrigo como parâmetro.
class AbrigoDetalheScreen extends StatelessWidget {
  const AbrigoDetalheScreen({super.key, required this.abrigo});

  final Abrigo abrigo;

  @override
  Widget build(BuildContext context) {
    final corStatus = abrigo.lotado ? Colors.red : Colors.green;
    final percentual = (abrigo.percentualOcupado * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text(abrigo.nome)),
      body: ListView(
        padding: const EdgeInsets.all(Espaco.m),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(Espaco.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(abrigo.status),
                        backgroundColor: corStatus.withAlpha(40),
                      ),
                      const Spacer(),
                      Text('$percentual% ocupado'),
                    ],
                  ),
                  const SizedBox(height: Espaco.p),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: abrigo.percentualOcupado,
                      minHeight: 14,
                      color: corStatus,
                      backgroundColor: corStatus.withAlpha(40),
                    ),
                  ),
                  const SizedBox(height: Espaco.p),
                  Text(
                    '${abrigo.ocupacao} de ${abrigo.capacidade} pessoas · '
                    '${abrigo.vagas} vagas livres',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Espaco.m),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.place, color: AppTheme.azul),
                  title: Text(abrigo.endereco),
                  subtitle: Text('${abrigo.distanciaKm.toStringAsFixed(1)} km de você'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: AppTheme.azul),
                  title: Text(abrigo.telefone),
                ),
                ListTile(
                  leading: Icon(
                    Icons.pets,
                    color: abrigo.aceitaPets ? Colors.green : Colors.grey,
                  ),
                  title: Text(abrigo.aceitaPets ? 'Aceita animais' : 'Não aceita animais'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.accessible,
                    color: abrigo.acessivelPcd ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    abrigo.acessivelPcd ? 'Acessível para PcD' : 'Sem acessibilidade para PcD',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Espaco.g),
          FilledButton.icon(
            onPressed: abrigo.lotado
                ? null
                : () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rota até ${abrigo.nome} (simulação).')),
                    ),
            icon: const Icon(Icons.directions),
            label: Text(abrigo.lotado ? 'Abrigo lotado' : 'Como chegar'),
          ),
        ],
      ),
    );
  }
}
