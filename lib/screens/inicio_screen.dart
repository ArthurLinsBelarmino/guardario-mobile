import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/alerta.dart';
import '../models/nivel_risco.dart';
import '../models/relato.dart';
import '../theme/app_theme.dart';
import '../widgets/nivel_chip.dart';
import 'alerta_detalhe_screen.dart';
import 'kit_emergencia_screen.dart';
import 'login_screen.dart';
import 'meus_relatos_screen.dart';
import 'novo_relato_screen.dart';

/// Tela 3: nível do rio, alerta ativo e atalhos.
/// Estado: "Simular subida" altera o nível e a tela muda de cor via setState().
class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key, required this.logado, required this.onIrPara});

  final bool logado;
  final ValueChanged<int> onIrPara;

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  void _simularSubida() {
    if (MockData.simulacaoNoMaximo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nível máximo da simulação. Toque em "Rio baixou".')),
      );
      return;
    }

    Alerta? novoAlerta;
    setState(() {
      novoAlerta = MockData.simularSubida();
    });

    final alerta = novoAlerta;
    if (alerta != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: alerta.nivel.cor,
          content: Text('Novo alerta automático: ${alerta.titulo}'),
        ),
      );
    }
  }

  void _reiniciar() {
    setState(() => MockData.reiniciarSimulacao());
  }

  Future<void> _novoRelato() async {
    if (!widget.logado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Entre na sua conta para enviar um relato.'),
          action: SnackBarAction(
            label: 'Entrar',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ),
      );
      return;
    }

    // Parâmetro de volta: o formulário devolve o Relato com Navigator.pop.
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
        action: SnackBarAction(
          label: 'Ver',
          textColor: Colors.white,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MeusRelatosScreen()),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final risco = MockData.riscoAtual;
    final alertaAtivo = MockData.alertaAtivo;

    return Scaffold(
      appBar: AppBar(title: const Text('GuardaRio')),
      body: ListView(
        padding: const EdgeInsets.all(Espaco.m),
        children: [
          if (alertaAtivo != null) ...[
            _BannerAlerta(
              alerta: alertaAtivo,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AlertaDetalheScreen(alerta: alertaAtivo)),
              ),
            ),
            const SizedBox(height: Espaco.m),
          ],
          _CardNivel(risco: risco),
          const SizedBox(height: Espaco.m),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _simularSubida,
                  icon: const Icon(Icons.trending_up),
                  label: const Text('Simular subida'),
                ),
              ),
              const SizedBox(width: Espaco.p),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _reiniciar,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Rio baixou'),
                ),
              ),
            ],
          ),
          const SizedBox(height: Espaco.g),
          Text('Atalhos', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Espaco.p),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: Espaco.p,
            mainAxisSpacing: Espaco.p,
            childAspectRatio: 1.6,
            children: [
              _Atalho(
                icone: Icons.notifications_active,
                rotulo: 'Alertas',
                onTap: () => widget.onIrPara(1),
              ),
              _Atalho(
                icone: Icons.home_work,
                rotulo: 'Abrigos',
                onTap: () => widget.onIrPara(2),
              ),
              _Atalho(icone: Icons.campaign, rotulo: 'Novo relato', onTap: _novoRelato),
              _Atalho(
                icone: Icons.backpack,
                rotulo: 'Kit de emergência',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KitEmergenciaScreen()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerAlerta extends StatelessWidget {
  const _BannerAlerta({required this.alerta, required this.onTap});

  final Alerta alerta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: alerta.nivel.cor,
      child: ListTile(
        onTap: onTap,
        leading: Icon(alerta.nivel.icone, color: Colors.white, size: 32),
        title: Text(
          alerta.titulo,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Toque para ver o que fazer', style: TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }
}

class _CardNivel extends StatelessWidget {
  const _CardNivel({required this.risco});

  final NivelRisco risco;

  @override
  Widget build(BuildContext context) {
    final progresso = (MockData.nivelAtualCm / MockData.cotaTransbordo).clamp(0.0, 1.0).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espaco.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sensors, color: AppTheme.azul),
                const SizedBox(width: Espaco.p),
                Expanded(
                  child: Text(
                    '${MockData.estacaoNome}\n${MockData.rio}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espaco.m),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${MockData.nivelAtualCm} cm',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: risco.cor),
                ),
                const Spacer(),
                NivelChip(nivel: risco),
              ],
            ),
            const SizedBox(height: Espaco.p),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progresso,
                minHeight: 12,
                color: risco.cor,
                backgroundColor: risco.cor.withAlpha(40),
              ),
            ),
            const SizedBox(height: Espaco.p),
            // Régua colorida: destaca o nível atual
            Row(
              children: [
                for (final nivel in NivelRisco.values)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: nivel == risco ? nivel.cor : nivel.cor.withAlpha(50),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        nivel.rotulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: nivel == risco ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Espaco.m),
            Text(risco.resumo, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: Espaco.p),
            Text(
              'Chuva: ${MockData.chuvaMmH.toStringAsFixed(0)} mm/h · '
              'Cotas: atenção ${MockData.cotaAtencao}, alerta ${MockData.cotaAlerta}, '
              'transbordo ${MockData.cotaTransbordo} cm',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Atalho extends StatelessWidget {
  const _Atalho({required this.icone, required this.rotulo, required this.onTap});

  final IconData icone;
  final String rotulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 32, color: AppTheme.azul),
            const SizedBox(height: Espaco.p),
            Text(rotulo, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
