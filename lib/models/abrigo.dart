class Abrigo {
  const Abrigo({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.telefone,
    required this.capacidade,
    required this.ocupacao,
    required this.aceitaPets,
    required this.acessivelPcd,
    required this.distanciaKm,
  });

  final int id;
  final String nome;
  final String endereco;
  final String telefone;
  final int capacidade;
  final int ocupacao;
  final bool aceitaPets;
  final bool acessivelPcd;
  final double distanciaKm;

  int get vagas => capacidade - ocupacao < 0 ? 0 : capacidade - ocupacao;

  bool get lotado => ocupacao >= capacidade;

  double get percentualOcupado => capacidade == 0 ? 1 : ocupacao / capacidade;

  String get status => lotado ? 'LOTADO' : 'ABERTO';
}
