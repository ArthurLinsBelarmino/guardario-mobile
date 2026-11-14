import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/relato.dart';
import '../theme/app_theme.dart';

/// Tela 8: formulário de novo relato.
/// Form + GlobalKey<FormState>, validators, AlertDialog de confirmação
/// e o Relato volta para a tela anterior com Navigator.pop(context, relato).
class NovoRelatoScreen extends StatefulWidget {
  const NovoRelatoScreen({super.key});

  @override
  State<NovoRelatoScreen> createState() => _NovoRelatoScreenState();
}

class _NovoRelatoScreenState extends State<NovoRelatoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bairroController = TextEditingController(text: MockData.area);
  final _descricaoController = TextEditingController();

  TipoRelato? _tipo;
  bool _pessoasEmRisco = false;

  @override
  void dispose() {
    _bairroController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Corrija os campos destacados em vermelho.'),
        ),
      );
      return;
    }

    final relato = Relato(
      tipo: _tipo!,
      bairro: _bairroController.text.trim(),
      descricao: _descricaoController.text.trim(),
      pessoasEmRisco: _pessoasEmRisco,
      areaEmAlerta: MockData.areaEmAlerta,
      criadoEm: DateTime.now(),
    );

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar envio'),
        content: Text(
          'Tipo: ${relato.tipo.rotulo}\n'
          'Bairro: ${relato.bairro}\n'
          'Pessoas em risco: ${relato.pessoasEmRisco ? 'sim' : 'não'}\n'
          'Prioridade calculada: ${relato.prioridade} de 5\n\n'
          'A Defesa Civil vai receber este relato.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Revisar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );

    if (confirmou == true && mounted) {
      Navigator.pop(context, relato); // parâmetro de volta
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo relato')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Espaco.m),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Conte o que está acontecendo. A Defesa Civil atende primeiro os casos mais graves.',
                ),
                const SizedBox(height: Espaco.m),
                DropdownButtonFormField<TipoRelato>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de ocorrência',
                    prefixIcon: Icon(Icons.report),
                  ),
                  items: [
                    for (final tipo in TipoRelato.values)
                      DropdownMenuItem(value: tipo, child: Text(tipo.rotulo)),
                  ],
                  onChanged: (valor) => setState(() => _tipo = valor),
                  validator: (valor) => valor == null ? 'Escolha o tipo de ocorrência.' : null,
                ),
                const SizedBox(height: Espaco.m),
                TextFormField(
                  controller: _bairroController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (valor) {
                    final bairro = valor?.trim() ?? '';
                    if (bairro.isEmpty) return 'Informe o bairro.';
                    if (bairro.length < 3) return 'Nome do bairro muito curto.';
                    return null;
                  },
                ),
                const SizedBox(height: Espaco.m),
                TextFormField(
                  controller: _descricaoController,
                  maxLines: 4,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex.: a água já chegou no portão da casa 45.',
                    alignLabelWithHint: true,
                  ),
                  validator: (valor) {
                    final texto = valor?.trim() ?? '';
                    if (texto.length < 10) return 'Descreva com pelo menos 10 caracteres.';
                    if (texto.length > 500) return 'Use no máximo 500 caracteres.';
                    return null;
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Há pessoas em risco?'),
                  subtitle: const Text('Idosos, crianças, pessoas ilhadas ou feridas'),
                  value: _pessoasEmRisco,
                  onChanged: (v) => setState(() => _pessoasEmRisco = v),
                ),
                const SizedBox(height: Espaco.m),
                FilledButton.icon(
                  onPressed: _enviar,
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar relato'),
                ),
                const SizedBox(height: Espaco.p),
                const Text(
                  'Em perigo imediato, ligue 199 (Defesa Civil) ou 193 (Bombeiros).',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
