import 'package:flutter/material.dart';

import 'abrigos_screen.dart';
import 'alertas_screen.dart';
import 'inicio_screen.dart';
import 'perfil_screen.dart';

/// Estrutura principal com BottomNavigationBar (Início, Alertas, Abrigos, Perfil).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.usuarioNome});

  /// null = visitante (entrou sem conta).
  final String? usuarioNome;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  void _irPara(int indice) => setState(() => _indice = indice);

  @override
  Widget build(BuildContext context) {
    final telas = <Widget>[
      InicioScreen(logado: widget.usuarioNome != null, onIrPara: _irPara),
      const AlertasScreen(),
      const AbrigosScreen(),
      PerfilScreen(usuarioNome: widget.usuarioNome),
    ];

    return Scaffold(
      body: telas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: _irPara,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.water), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Abrigos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
