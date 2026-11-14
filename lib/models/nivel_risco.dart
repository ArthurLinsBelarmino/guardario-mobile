import 'package:flutter/material.dart';

/// Régua de risco do GuardaRio (a mesma da estação IoT, da API Java e do PL/SQL).
enum NivelRisco {
  normal('NORMAL', Color(0xFF2E7D32), Icons.check_circle),
  atencao('ATENÇÃO', Color(0xFFF9A825), Icons.info),
  alerta('ALERTA', Color(0xFFEF6C00), Icons.warning_amber),
  emergencia('EMERGÊNCIA', Color(0xFFC62828), Icons.crisis_alert);

  const NivelRisco(this.rotulo, this.cor, this.icone);

  final String rotulo;
  final Color cor;
  final IconData icone;

  /// RN01: compara o nível com as cotas; chuva >= 50 mm/h sobe um nível.
  static NivelRisco calcular({
    required int nivelCm,
    required double chuvaMmH,
    required int cotaAtencao,
    required int cotaAlerta,
    required int cotaTransbordo,
  }) {
    var risco = NivelRisco.normal;
    if (nivelCm >= cotaTransbordo) {
      risco = NivelRisco.emergencia;
    } else if (nivelCm >= cotaAlerta) {
      risco = NivelRisco.alerta;
    } else if (nivelCm >= cotaAtencao) {
      risco = NivelRisco.atencao;
    }

    if (chuvaMmH >= 50 && risco != NivelRisco.emergencia) {
      risco = NivelRisco.values[risco.index + 1];
    }
    return risco;
  }

  String get resumo {
    switch (this) {
      case NivelRisco.normal:
        return 'Rio dentro do normal. Aproveite para preparar seu kit.';
      case NivelRisco.atencao:
        return 'O rio está subindo. Fique atento aos avisos.';
      case NivelRisco.alerta:
        return 'Risco de enchente. Prepare-se para sair de casa.';
      case NivelRisco.emergencia:
        return 'O rio vai transbordar. Saia agora para um abrigo.';
    }
  }

  List<String> get oQueFazer {
    switch (this) {
      case NivelRisco.normal:
        return [
          'Monte o kit de emergência.',
          'Descubra qual abrigo fica mais perto de você.',
        ];
      case NivelRisco.atencao:
        return [
          'Acompanhe o nível do rio no app.',
          'Deixe documentos e remédios em saco plástico.',
          'Combine com a família onde se encontrar.',
        ];
      case NivelRisco.alerta:
        return [
          'Desligue a energia e o gás se a água se aproximar.',
          'Leve o kit de emergência e os animais.',
          'Escolha um abrigo com vaga no app.',
          'Ajude vizinhos idosos ou com deficiência.',
        ];
      case NivelRisco.emergencia:
        return [
          'Saia de casa agora pelo caminho mais alto.',
          'Não atravesse ruas alagadas a pé ou de carro.',
          'Vá para o abrigo com vaga mais próximo.',
          'Em perigo, ligue 199 (Defesa Civil) ou 193 (Bombeiros).',
        ];
    }
  }
}
