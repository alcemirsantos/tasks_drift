import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasks_drift/data/dao/etiqueta_dao.dart';

import '../../data/banco_de_dados.dart';

class CampoNovaEtiqueta extends StatefulWidget {
  const CampoNovaEtiqueta({Key? key}) : super(key: key);

  @override
  _CampoNovaEtiquetaState createState() => _CampoNovaEtiquetaState();
}

class _CampoNovaEtiquetaState extends State<CampoNovaEtiqueta> {
  static const Color corPadrao = Colors.red;

  Color pickedTagColor = corPadrao;
  late TextEditingController controladorDeCampoDeTexto;

  @override
  void initState() {
    super.initState();
    controladorDeCampoDeTexto = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          _getCampoDeTexto(context),
          _getBotaoDeSelecaoDeCor(context),
        ],
      ),
    );
  }

  Flexible _getCampoDeTexto(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextField(
        controller: controladorDeCampoDeTexto,
        decoration: InputDecoration(hintText: 'Tag Name'),
        onSubmitted: (inputName) {
          final dao = Provider.of<EtiquetaDao>(context, listen: false);
          final task = EtiquetasCompanion(
            nome: Value(inputName),
            cor: Value(pickedTagColor.value),
          );
          dao.insertTag(task);
          resetValuesAfterSubmit();
        },
      ),
    );
  }

  Widget _getBotaoDeSelecaoDeCor(BuildContext context) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pickedTagColor,
          ),
        ),
        onTap: () {
          _showColorPickerDialog(context);
        },
      ),
    );
  }

  Future _showColorPickerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: MaterialColorPicker(
            allowShades: false,
            selectedColor: corPadrao,
            onMainColorChange: (colorSwatch) {
              setState(() {
                pickedTagColor = colorSwatch!;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void resetValuesAfterSubmit() {
    setState(() {
      pickedTagColor = corPadrao;
      controladorDeCampoDeTexto.clear();
    });
  }
}
