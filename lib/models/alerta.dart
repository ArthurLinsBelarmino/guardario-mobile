import 'nivel_risco.dart';

class Alerta {
  Alerta({
    required this.id,
    required this.nivel,
    required this.titulo,
    required this.mensagem,
    required this.area,
    required this.emitidoEm,
    this.ativo = true,
    this.automatico = false,
  });

  final int id;
  final NivelRisco nivel;
  final String titulo;
  final String mensagem;
  final String area;
  final DateTime emitidoEm;
  bool ativo;
  final bool automatico;
}
