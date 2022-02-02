import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/banco_de_dados.dart';
import 'ui/pagina_inicial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Este widget é a raiz da aplicação.
  @override
  Widget build(BuildContext context) {
    final db = BancoDeDados();
    return Provider<BancoDeDados>(
      // Esta é uma instância única do banco de dados que será compartilhada
      create: (context) => db,
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        title: 'Agenda de Tarefas',
        home: PaginaInicial(),
      ),
    );
  }
}
