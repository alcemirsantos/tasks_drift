import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controladorDeTexto,
        decoration: InputDecoration(hintText: 'Descrição da Tarefa'),
        onSubmitted: (inputName) {
          final database = Provider.of<BancoDeDados>(context, listen: false);
          final tarefa = Tarefa(
            nome: inputName,
            dataLimite: dataLimite,
            terminada: false,
          );
          database.insereTarefa(tarefa);
          limpaValoesAposInsercao();
        },
      ),
    );
  }

  IconButton _buildDateButton(BuildContext context) {
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
