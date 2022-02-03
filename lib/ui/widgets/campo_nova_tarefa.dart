import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks_drift/data/dao/etiqueta_dao.dart';
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
  Etiqueta etiquetaSelecionada;
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
          _getBotaoSelecaoDeEtiqueta(context),
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
            nomeEtiqueta: Value(etiquetaSelecionada.nome),
          );
          dao.insereTarefa(tarefa);
          limpaValoesAposInsercao();
        },
      ),
    );
  }

  StreamBuilder<List<Etiqueta>> _getBotaoSelecaoDeEtiqueta(
      BuildContext context) {
    return StreamBuilder<List<Etiqueta>>(
      stream: Provider.of<EtiquetaDao>(context).watchTags(),
      builder: (context, snapshot) {
        final etiquetas = snapshot.data ?? [];

        DropdownMenuItem<Etiqueta> dropdownFromTag(Etiqueta etiqueta) {
          return DropdownMenuItem(
            value: etiqueta,
            child: Row(
              children: <Widget>[
                Text(etiqueta.nome),
                SizedBox(width: 5),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(etiqueta.cor),
                  ),
                ),
              ],
            ),
          );
        }

        final dropdownMenuItems =
            etiquetas.map((etiqueta) => dropdownFromTag(etiqueta)).toList()
              // Adiciona "Sem Etiqueta" como o primeiro elemento da lista
              ..insert(
                0,
                DropdownMenuItem(
                  value: null,
                  child: Text('Sem Etiqueta'),
                ),
              );

        return Expanded(
          child: DropdownButton(
            onChanged: (Etiqueta etiqueta) {
              setState(() {
                etiquetaSelecionada = etiqueta;
              });
            },
            isExpanded: true,
            value: etiquetaSelecionada,
            items: dropdownMenuItems,
          ),
        );
      },
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
      etiquetaSelecionada = null;
      controladorDeTexto.clear();
    });
  }
}
