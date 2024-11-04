import 'package:drift/drift.dart';
import 'package:tasks_drift/data/tables/etiquetas.dart';

/// Ao decomenar a linha abaixo, o nome padrão da classe de dados da tabela
///  "Tarefas" seria "QualquerNomeQueVoceQueira"
///  @DataClassName('QualquerNomeQueVoceQueira')
/// ===
///
/// O nome da tabela do banco de dados é "tarefas". Por padrão, o nome da classe
/// gerada é "Tarefa" (sem o "s").
class Tarefas extends Table {
  // auto incrementa automaticamente e define a coluna "id" da tabela como
  // chave primária.
  IntColumn get id => integer().autoIncrement()();
  // Se o tamanho da restrição não for atendido, o objeto Tarefa não será
  // inserido no banco de dados e um exceção será lançada.
  TextColumn get nome => text().withLength(min: 1, max: 50)();
  // DateTime não é nativamente aceito pelo SQLite, o Drift convert ele
  // de/para segundos UNIX.
  DateTimeColumn get dataLimite => dateTime().nullable()();
  // Booleanos também não são saceitos, Drift converte eles para inteiros.
  // Os valores padrão são especificados como constantes
  BoolColumn get terminada => boolean().withDefault(Constant(false))();
  // Este campo servirá como chave estrangeira para a tabela de Etiquetas
  TextColumn get nomeEtiqueta =>
      text().nullable().references(Etiquetas, #nome)();
}
