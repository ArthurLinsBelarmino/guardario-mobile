import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/relato.dart';
import '../theme/app_theme.dart';
import '../utils/formatos.dart';
import 'novo_relato_screen.dart';

class MeusRelatosScreen extends StatefulWidget {
  const MeusRelatosScreen({super.key});

  @override
  State<MeusRelatosScreen> createState() => _MeusRelatosScreenState();
}

class _MeusRelatosScreenState extends State<MeusRelatosScreen> {
  Future<void> _novoRelato() async {
    final relato = await Navigator.push<Relato>(
      context,
      MaterialPageRoute(builder: (_) => const NovoRelatoScreen()),
    );
    if (relato == null || !mounted) return;

    setState(() => MockData.relatos.insert(0, relato));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Relato enviado! Prioridade ${relato.prioridade} de 5.'),
      ),
    );
  }

  Color _corPrioridade(int p) {
    if (p >= 5) return const Color(0xFFC62828);
    if (p == 4) return const Color(0xFFEF6C00);
    if (p == 3) return const Color(0xFFF9A825);
    return AppTheme.azul;
  }

  @override
  Widget build(BuildContext context) {
    final relatos = MockData.relatos;

    return Scaffold(
      appBar: AppBar(title: const Text('Meus relatos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novoRelato,
        icon: const Icon(Icons.add),
        label: const Text('Novo relato'),
      ),
      body: relatos.isEmpty
          ? const Center(child: Text('Você ainda não enviou relatos.'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(Espaco.m, Espaco.m, Espaco.m, 96),
              itemCount: relatos.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: Espaco.p),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Text(
                    'Total: ${relatos.length} relato(s)',
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                }
                final relato = relatos[i - 1];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(Espaco.m),
                    leading: CircleAvatar(
                      backgroundColor: _corPrioridade(relato.prioridade),
                      child: Text(
                        '${relato.prioridade}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      relato.tipo.rotulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${relato.bairro} · ${formatarDataHora(relato.criadoEm)}\n${relato.descricao}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Chip(
                      label: Text(relato.status, style: const TextStyle(fontSize: 11)),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
