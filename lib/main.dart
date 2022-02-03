import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_drift/data/dao/etiqueta_dao.dart';
import 'package:tasks_drift/data/dao/tarefa_dao.dart';

import 'data/banco_de_dados.dart';
import 'ui/pagina_inicial.dart';

void main() {
  runApp(
    Provider<BancoDeDados>(
      create: (context) => BancoDeDados(),
      dispose: (context, value) => value.close(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Este widget é a raiz da aplicação.
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<BancoDeDados>(context);

    return MultiProvider(
      providers: [
        Provider<TarefaDao>(create: (_) => db.tarefaDao),
        Provider<EtiquetaDao>(create: (_) => db.etiquetaDao),
      ],
      child: MaterialApp(
        title: 'Agenda de Tarefas',
        home: PaginaInicial(),
      ),
    );
  }
}
