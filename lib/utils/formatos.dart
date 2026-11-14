String _doisDigitos(int n) => n.toString().padLeft(2, '0');

String formatarDataHora(DateTime d) =>
    '${_doisDigitos(d.day)}/${_doisDigitos(d.month)} às ${_doisDigitos(d.hour)}:${_doisDigitos(d.minute)}';
