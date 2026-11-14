import 'package:flutter/material.dart';

import 'screens/boas_vindas_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GuardaRioApp());
}

class GuardaRioApp extends StatelessWidget {
  const GuardaRioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuardaRio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.tema,
      home: const BoasVindasScreen(),
    );
  }
}
