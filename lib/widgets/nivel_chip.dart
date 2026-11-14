import 'package:flutter/material.dart';

import '../models/nivel_risco.dart';

class NivelChip extends StatelessWidget {
  const NivelChip({super.key, required this.nivel});

  final NivelRisco nivel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: nivel.cor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(nivel.icone, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            nivel.rotulo,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
