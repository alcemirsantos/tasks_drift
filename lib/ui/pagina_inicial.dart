import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tasks_drift/data/dao/tarefa_dao.dart';

import '../data/banco_de_dados.dart';
import 'widgets/campo_nova_tarefa.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefas Agendadas'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _getListaDeTarefas(context)),
          CampoNovaTarefa(),
        ],
      ),
    );
  }

  StreamBuilder<List<Tarefa>> _getListaDeTarefas(BuildContext context) {
    final TarefaDao dao = Provider.of<TarefaDao>(context);

    return StreamBuilder(
      stream: dao.observaAsTarefas(),
      // [DICA] stream: dao.observaSomenteTarefasConcluidas(),
      builder: (context, AsyncSnapshot<List<Tarefa>> snapshot) {
        final tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _getListaDeItens(itemTask, dao);
          },
        );
      },
    );
  }

  Widget _getListaDeItens(Tarefa itemTask, TarefaDao dao) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Remover',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => dao.removeTarefa(itemTask),
        )
      ],
      child: CheckboxListTile(
        title: Text(itemTask.nome),
        subtitle: Text(itemTask.dataLimite?.toString() ?? 'Sem data'),
        value: itemTask.terminada,
        onChanged: (newValue) {
          dao.atualizaTarefa(itemTask.copyWith(terminada: newValue));
        },
      ),
    );
  }
}
