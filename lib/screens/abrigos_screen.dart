import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/abrigo.dart';
import '../theme/app_theme.dart';
import 'abrigo_detalhe_screen.dart';

class AbrigosScreen extends StatefulWidget {
  const AbrigosScreen({super.key, this.somenteComVagaInicial = false});

  final bool somenteComVagaInicial;

  @override
  State<AbrigosScreen> createState() => _AbrigosScreenState();
}

class _AbrigosScreenState extends State<AbrigosScreen> {
  bool _aceitaPets = false;
  bool _acessivelPcd = false;
  late bool _comVagas;
  bool _soFavoritos = false;

  @override
  void initState() {
    super.initState();
    _comVagas = widget.somenteComVagaInicial;
  }

  List<Abrigo> get _filtrados {
    final lista = MockData.abrigos.where((a) {
      if (_aceitaPets && !a.aceitaPets) return false;
      if (_acessivelPcd && !a.acessivelPcd) return false;
      if (_comVagas && a.lotado) return false;
      if (_soFavoritos && !MockData.favoritos.contains(a.id)) return false;
      return true;
    }).toList();

    lista.sort((a, b) {
      final favA = MockData.favoritos.contains(a.id) ? 0 : 1;
      final favB = MockData.favoritos.contains(b.id) ? 0 : 1;
      if (favA != favB) return favA.compareTo(favB);
      return a.distanciaKm.compareTo(b.distanciaKm);
    });
    return lista;
  }

  void _alternarFavorito(Abrigo abrigo) {
    setState(() {
      if (!MockData.favoritos.remove(abrigo.id)) {
        MockData.favoritos.add(abrigo.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final abrigos = _filtrados;

    return Scaffold(
      appBar: AppBar(title: const Text('Abrigos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Espaco.m, Espaco.m, Espaco.m, 0),
            child: Wrap(
              spacing: Espaco.p,
              runSpacing: Espaco.p,
              children: [
                FilterChip(
                  label: const Text('Aceita pets'),
                  avatar: const Icon(Icons.pets, size: 18),
                  selected: _aceitaPets,
                  onSelected: (v) => setState(() => _aceitaPets = v),
                ),
                FilterChip(
                  label: const Text('Acessível PcD'),
                  avatar: const Icon(Icons.accessible, size: 18),
                  selected: _acessivelPcd,
                  onSelected: (v) => setState(() => _acessivelPcd = v),
                ),
                FilterChip(
                  label: const Text('Com vagas'),
                  selected: _comVagas,
                  onSelected: (v) => setState(() => _comVagas = v),
                ),
                FilterChip(
                  label: const Text('Favoritos'),
                  avatar: const Icon(Icons.star, size: 18),
                  selected: _soFavoritos,
                  onSelected: (v) => setState(() => _soFavoritos = v),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Espaco.m),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${abrigos.length} abrigo(s) encontrado(s)'),
            ),
          ),
          Expanded(
            child: abrigos.isEmpty
                ? const Center(child: Text('Nenhum abrigo com esses filtros.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(Espaco.m, 0, Espaco.m, Espaco.m),
                    itemCount: abrigos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: Espaco.p),
                    itemBuilder: (context, i) {
                      final abrigo = abrigos[i];
                      return _CardAbrigo(
                        abrigo: abrigo,
                        favorito: MockData.favoritos.contains(abrigo.id),
                        onFavoritar: () => _alternarFavorito(abrigo),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AbrigoDetalheScreen(abrigo: abrigo)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CardAbrigo extends StatelessWidget {
  const _CardAbrigo({
    required this.abrigo,
    required this.favorito,
    required this.onFavoritar,
    required this.onTap,
  });

  final Abrigo abrigo;
  final bool favorito;
  final VoidCallback onFavoritar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final corStatus = abrigo.lotado ? Colors.red : Colors.green;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Espaco.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      abrigo.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoritar,
                    icon: Icon(
                      favorito ? Icons.star : Icons.star_border,
                      color: favorito ? Colors.amber : null,
                    ),
                    tooltip: favorito ? 'Remover dos favoritos' : 'Favoritar',
                  ),
                ],
              ),
              Text('${abrigo.distanciaKm.toStringAsFixed(1)} km · ${abrigo.endereco}'),
              const SizedBox(height: Espaco.p),
              Row(
                children: [
                  Text(
                    abrigo.lotado ? 'LOTADO' : '${abrigo.vagas} vagas',
                    style: TextStyle(color: corStatus, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (abrigo.aceitaPets) const Icon(Icons.pets, size: 20, color: AppTheme.azul),
                  if (abrigo.acessivelPcd) ...[
                    const SizedBox(width: Espaco.p),
                    const Icon(Icons.accessible, size: 20, color: AppTheme.azul),
                  ],
                ],
              ),
              const SizedBox(height: Espaco.p),
              LinearProgressIndicator(
                value: abrigo.percentualOcupado,
                color: corStatus,
                backgroundColor: corStatus.withAlpha(40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
