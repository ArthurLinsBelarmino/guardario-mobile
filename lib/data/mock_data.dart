import '../models/abrigo.dart';
import '../models/alerta.dart';
import '../models/nivel_risco.dart';
import '../models/relato.dart';


class MockData {
  static const String usuarioNome = 'Cida Souza';
  static const String usuarioEmail = 'cida@guardario.com';
  static const String usuarioSenha = '123456';

  static const String area = 'Jardim Pantanal';
  static const String estacaoNome = 'Estação Ponte Jardim Pantanal';
  static const String rio = 'Rio Tietê';
  static const int cotaAtencao = 250;
  static const int cotaAlerta = 320;
  static const int cotaTransbordo = 400;

  static const int _nivelInicial = 230;
  static const double _chuvaInicial = 8;
  static const int _nivelMaximoSimulacao = 440;

  static int nivelAtualCm = _nivelInicial;
  static double chuvaMmH = _chuvaInicial;

  static NivelRisco get riscoAtual => NivelRisco.calcular(
        nivelCm: nivelAtualCm,
        chuvaMmH: chuvaMmH,
        cotaAtencao: cotaAtencao,
        cotaAlerta: cotaAlerta,
        cotaTransbordo: cotaTransbordo,
      );

  static bool get areaEmAlerta => riscoAtual.index >= NivelRisco.alerta.index;

  static int _proximoIdAlerta = 4;

  static final List<Alerta> alertas = [
    Alerta(
      id: 3,
      nivel: NivelRisco.atencao,
      titulo: 'Atenção: chuva forte prevista',
      mensagem: 'Previsão de chuva forte à tarde. Acompanhe o nível do rio.',
      area: area,
      emitidoEm: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      ativo: false,
    ),
    Alerta(
      id: 2,
      nivel: NivelRisco.alerta,
      titulo: 'Alerta: rio subindo rápido',
      mensagem: 'O Tietê passou da cota de alerta na ponte do Jardim Pantanal.',
      area: area,
      emitidoEm: DateTime.now().subtract(const Duration(days: 6)),
      ativo: false,
      automatico: true,
    ),
    Alerta(
      id: 1,
      nivel: NivelRisco.emergencia,
      titulo: 'Emergência: rio transbordou',
      mensagem: 'Transbordo na Rua das Garças. Abrigos abertos na região.',
      area: area,
      emitidoEm: DateTime.now().subtract(const Duration(days: 20)),
      ativo: false,
      automatico: true,
    ),
  ];

  static Alerta? get alertaAtivo {
    for (final a in alertas) {
      if (a.ativo) return a;
    }
    return null;
  }

  static Alerta? simularSubida() {
    if (nivelAtualCm >= _nivelMaximoSimulacao) return null;
    nivelAtualCm += 40;
    chuvaMmH += 12;
    return _verificarAlerta();
  }

  static void reiniciarSimulacao() {
    nivelAtualCm = _nivelInicial;
    chuvaMmH = _chuvaInicial;
    for (final a in alertas) {
      a.ativo = false;
    }
  }

  static bool get simulacaoNoMaximo => nivelAtualCm >= _nivelMaximoSimulacao;

  static Alerta? _verificarAlerta() {
    final risco = riscoAtual;
    if (risco.index < NivelRisco.alerta.index) return null;

    final jaExiste = alertas.any((a) => a.ativo && a.nivel.index >= risco.index);
    if (jaExiste) return null;

    for (final a in alertas) {
      if (a.ativo && a.nivel.index < risco.index) a.ativo = false;
    }

    final emergencia = risco == NivelRisco.emergencia;
    final novo = Alerta(
      id: _proximoIdAlerta++,
      nivel: risco,
      titulo: emergencia ? 'Emergência: rio vai transbordar' : 'Alerta: rio subindo rápido',
      mensagem: 'A $estacaoNome mediu $nivelAtualCm cm e chuva de '
          '${chuvaMmH.toStringAsFixed(0)} mm/h. ${risco.resumo}',
      area: area,
      emitidoEm: DateTime.now(),
      automatico: true,
    );
    alertas.insert(0, novo);
    return novo;
  }

  static const List<Abrigo> abrigos = [
    Abrigo(
      id: 1,
      nome: 'EMEF Jardim Pantanal',
      endereco: 'Rua das Garças, 120 - Jardim Pantanal',
      telefone: '(11) 2025-1001',
      capacidade: 120,
      ocupacao: 45,
      aceitaPets: true,
      acessivelPcd: true,
      distanciaKm: 0.8,
    ),
    Abrigo(
      id: 2,
      nome: 'Escola Estadual Pantanal II',
      endereco: 'Rua Capitão Ventura, 55 - Jardim Pantanal',
      telefone: '(11) 2025-1002',
      capacidade: 80,
      ocupacao: 79,
      aceitaPets: true,
      acessivelPcd: true,
      distanciaKm: 1.1,
    ),
    Abrigo(
      id: 3,
      nome: 'Paróquia São Miguel',
      endereco: 'Av. Marechal Tito, 3500 - São Miguel',
      telefone: '(11) 2025-1003',
      capacidade: 60,
      ocupacao: 60,
      aceitaPets: false,
      acessivelPcd: true,
      distanciaKm: 1.5,
    ),
    Abrigo(
      id: 4,
      nome: 'Ginásio Vila Itaim',
      endereco: 'Rua Dr. Assis Ribeiro, 900 - Vila Itaim',
      telefone: '(11) 2025-1004',
      capacidade: 200,
      ocupacao: 130,
      aceitaPets: true,
      acessivelPcd: false,
      distanciaKm: 2.3,
    ),
    Abrigo(
      id: 5,
      nome: 'CEU Jardim Helena',
      endereco: 'Rua Pedro de Alcântara, 300 - Jardim Helena',
      telefone: '(11) 2025-1005',
      capacidade: 150,
      ocupacao: 20,
      aceitaPets: false,
      acessivelPcd: true,
      distanciaKm: 3.1,
    ),
  ];

  static final Set<int> favoritos = {};

  static final List<Relato> relatos = [
    Relato(
      tipo: TipoRelato.bueiroEntupido,
      bairro: 'Jardim Pantanal',
      descricao: 'Bueiro entupido na esquina da Rua das Garças, água acumulando.',
      pessoasEmRisco: false,
      areaEmAlerta: false,
      criadoEm: DateTime.now().subtract(const Duration(days: 3)),
      status: 'RESOLVIDO',
    ),
  ];

  static const List<String> kitItens = [
    'Documentos em saco plástico',
    'Remédios de uso contínuo',
    'Lanterna',
    'Pilhas extras',
    'Carregador portátil (power bank)',
    'Água potável (2 L por pessoa)',
    'Alimentos não perecíveis',
    'Rádio a pilha',
    'Apito',
    'Kit de primeiros socorros',
    'Roupas e cobertor',
    'Ração, guia e coleira do pet',
  ];

  static final Set<String> kitMarcados = {};
}
