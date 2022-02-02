import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_drift/data/dao/tarefa_dao.dart';

import 'data/banco_de_dados.dart';
import 'ui/pagina_inicial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Este widget é a raiz da aplicação.
  @override
  Widget build(BuildContext context) {
    return Provider<TarefaDao>(
      // Esta é uma instância única do DAO de Tarefas que será compartilhada
      create: (context) => BancoDeDados().tarefaDao,
      child: MaterialApp(
        title: 'Agenda de Tarefas',
        home: PaginaInicial(),
      ),
    );
  }
}
