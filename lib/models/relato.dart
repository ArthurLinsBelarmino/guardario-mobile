import 'dart:math';

enum TipoRelato {
  pessoaIlhada('Pessoa ilhada', 5),
  deslizamento('Deslizamento', 4),
  rioSubindo('Rio subindo', 3),
  alagamentoVia('Rua alagada', 3),
  bueiroEntupido('Bueiro entupido', 2),
  outro('Outro', 1);

  const TipoRelato(this.rotulo, this.pesoBase);

  final String rotulo;
  final int pesoBase;
}

class Relato {
  Relato({
    required this.tipo,
    required this.bairro,
    required this.descricao,
    required this.pessoasEmRisco,
    required this.areaEmAlerta,
    required this.criadoEm,
    this.status = 'ABERTO',
  });

  final TipoRelato tipo;
  final String bairro;
  final String descricao;
  final bool pessoasEmRisco;
  final bool areaEmAlerta;
  final DateTime criadoEm;
  final String status;

  int get prioridade => min(5, tipo.pesoBase + (areaEmAlerta ? 1 : 0));
}
