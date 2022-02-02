import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_drift/data/dao/tarefa_dao.dart';

import '../../data/banco_de_dados.dart';

class CampoNovaTarefa extends StatefulWidget {
  const CampoNovaTarefa({
    Key key,
  }) : super(key: key);

  @override
  _CampoNovaTarefaState createState() => _CampoNovaTarefaState();
}

class _CampoNovaTarefaState extends State<CampoNovaTarefa> {
  DateTime dataLimite;
  TextEditingController controladorDeTexto;

  @override
  void initState() {
    super.initState();
    controladorDeTexto = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _getCampoDeTexto(context),
          _getBotaoDeData(context),
        ],
      ),
    );
  }

  Expanded _getCampoDeTexto(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controladorDeTexto,
        decoration: InputDecoration(hintText: 'Descrição da Tarefa'),
        onSubmitted: (inputName) {
          final dao = Provider.of<TarefaDao>(context, listen: false);
          final tarefa = TarefasCompanion(
            nome: Value(inputName),
            dataLimite: Value(dataLimite),
            terminada: Value(false),
          );
          dao.insereTarefa(tarefa);
          limpaValoesAposInsercao();
        },
      ),
    );
  }

  IconButton _getBotaoDeData(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        dataLimite = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );
      },
    );
  }

  void limpaValoesAposInsercao() {
    setState(() {
      dataLimite = null;
      controladorDeTexto.clear();
    });
  }
}
