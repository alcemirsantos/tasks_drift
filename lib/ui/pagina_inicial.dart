import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tasks_drift/data/banco_de_dados.dart';
import 'package:tasks_drift/data/dao/tarefa_dao.dart';
import 'package:tasks_drift/ui/widgets/campo_nova_etiqueta.dart';

import 'widgets/campo_nova_tarefa.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas Agendadas')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _getListaDeTarefas(context),
          ),
          CampoNovaTarefa(),
          CampoNovaEtiqueta(),
        ],
      ),
    );
  }

  /// Constrói um widget para mostrar todas as [Tarefa] do banco com suas
  /// respectivas [Etiqueta].
  StreamBuilder<List<TarefaEtiquetada>> _getListaDeTarefas(
      BuildContext context) {
    final TarefaDao dao = Provider.of<TarefaDao>(context);

    return StreamBuilder(
      stream: dao.observaAsTarefas(),
      // [FAÇA O TESTE] stream: dao.observaSomenteTarefasConcluidas(),
      builder: (context, AsyncSnapshot<List<TarefaEtiquetada>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              final tarefa = data[index];
              return _getTarefa(tarefa, dao);
            },
          );
        }
        if (snapshot.hasError) return Text('error: ${snapshot.error}');
        return CircularProgressIndicator(
          color: Colors.red,
        );
      },
    );
  }

  /// Constrói o widget para mostrar cada uma [Etiqueta].
  Widget _getTarefa(TarefaEtiquetada tarefaEtiquetada, TarefaDao dao) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Remover',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => dao.removeTarefa(tarefaEtiquetada.tarefa),
        )
      ],
      child: CheckboxListTile(
        title: Text(tarefaEtiquetada.tarefa.nome),
        secondary: _getEtiqueta(tarefaEtiquetada.etiqueta),
        subtitle:
            Text(tarefaEtiquetada.tarefa.dataLimite?.toString() ?? 'Sem data'),
        value: tarefaEtiquetada.tarefa.terminada,
        onChanged: (newValue) {
          dao.atualizaTarefa(
              tarefaEtiquetada.tarefa.copyWith(terminada: newValue));
        },
      ),
    );
  }

  /// Constrói o widget para mostrar a [Etiqueta] de uma [Tarefa].
  Widget _getEtiqueta(Etiqueta etiqueta) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (etiqueta != null) ...[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(etiqueta.cor),
              ),
            ),
            Text(
              etiqueta.nome,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ],
      );
}
