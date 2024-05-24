import 'package:drift/drift.dart';

class Etiquetas extends Table {
  TextColumn get nome => text().withLength(min: 1, max: 12)();
  IntColumn get cor => integer()();

  // Fazendo [nome] como chave primária, o que faz com que os nomes tenham que ser únicos
  @override
  Set<Column> get primaryKey => {nome};
}
