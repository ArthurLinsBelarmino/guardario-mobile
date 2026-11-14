import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class KitEmergenciaScreen extends StatefulWidget {
  const KitEmergenciaScreen({super.key});

  @override
  State<KitEmergenciaScreen> createState() => _KitEmergenciaScreenState();
}

class _KitEmergenciaScreenState extends State<KitEmergenciaScreen> {
  void _alternar(String item, bool marcado) {
    setState(() {
      if (marcado) {
        MockData.kitMarcados.add(item);
      } else {
        MockData.kitMarcados.remove(item);
      }
    });
  }

  void _limpar() => setState(() => MockData.kitMarcados.clear());

  @override
  Widget build(BuildContext context) {
    final total = MockData.kitItens.length;
    final prontos = MockData.kitMarcados.length;
    final completo = prontos == total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kit de emergência'),
        actions: [
          IconButton(onPressed: _limpar, icon: const Icon(Icons.refresh), tooltip: 'Limpar'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Espaco.m),
        children: [
          Card(
            color: completo ? Colors.green.shade50 : null,
            child: Padding(
              padding: const EdgeInsets.all(Espaco.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Itens prontos: $prontos de $total',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Espaco.p),
                  LinearProgressIndicator(
                    value: prontos / total,
                    minHeight: 10,
                    color: completo ? Colors.green : AppTheme.azul,
                  ),
                  const SizedBox(height: Espaco.p),
                  Text(
                    completo
                        ? 'Kit completo! Deixe perto da porta.'
                        : 'Prepare o kit antes da chuva: na hora da cheia não dá tempo.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Espaco.m),
          Card(
            child: Column(
              children: [
                for (final item in MockData.kitItens)
                  CheckboxListTile(
                    title: Text(item),
                    value: MockData.kitMarcados.contains(item),
                    onChanged: (v) => _alternar(item, v ?? false),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
