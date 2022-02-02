import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          Expanded(child: _buildTaskList(context)),
          CampoNovaTarefa(),
        ],
      ),
    );
  }

  StreamBuilder<List<Tarefa>> _buildTaskList(BuildContext context) {
    final BancoDeDados bd = Provider.of<BancoDeDados>(context);

    return StreamBuilder(
      stream: bd.observaAsTarefas(),
      builder: (context, AsyncSnapshot<List<Tarefa>> snapshot) {
        final tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, bd);
          },
        );
      },
    );
  }

  Widget _buildListItem(Tarefa itemTask, BancoDeDados bd) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => bd.removeTarefa(itemTask),
        )
      ],
      child: CheckboxListTile(
        title: Text(itemTask.nome),
        subtitle: Text(itemTask.dataLimite?.toString() ?? 'Sem data'),
        value: itemTask.terminada,
        onChanged: (newValue) {
          bd.atualizaTarefa(itemTask.copyWith(terminada: newValue));
        },
      ),
    );
  }
}
