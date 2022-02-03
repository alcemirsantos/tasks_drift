// Indica a tabela que deve acessar e queries customizadas escritas em SQL.
import 'package:drift/drift.dart';
import 'package:tasks_drift/data/tables/etiquetas.dart';

import '../banco_de_dados.dart';

part 'etiqueta_dao.g.dart';

@DriftAccessor(tables: [Etiquetas])
class EtiquetaDao extends DatabaseAccessor<BancoDeDados>
    with _$EtiquetaDaoMixin {
  final BancoDeDados db;

  EtiquetaDao(this.db) : super(db);

  Stream<List<Etiqueta>> watchTags() => select(etiquetas).watch();
  Future insertTag(Insertable<Etiqueta> etiqueta) =>
      into(etiquetas).insert(etiqueta);
}
