// Indica a tabela que deve acessar e queries customizadas escritas em SQL.
import 'package:drift/drift.dart';
import 'package:tasks_drift/data/tables/tarefas.dart';

import '../banco_de_dados.dart';

part 'tarefa_dao.g.dart';

@DriftAccessor(
  tables: [Tarefas],
  queries: {
    // Uma implemntação desta query irá ser gerada dentro do mixin _$TarefaDaoMixin
    // Ambas tarefasCompletasGerado() e observaSomenteTarefasConcluidas() serão criadas.
    'tarefasCompletasGerado':
        'SELECT * FROM tarefas WHERE terminado = 1 ORDER BY data_limite DESC, nome;'
  },
)
class TarefaDao extends DatabaseAccessor<BancoDeDados> with _$TarefaDaoMixin {
  final BancoDeDados db;

  TarefaDao(this.db) : super(db);

// Todas as tabelas tem getters nas classes geradas - nós podemos selecionar
  //    a tabela Tarefas
  Future<List<Tarefa>> recuperaTodasaAsTarefas() => select(tarefas).get();

  // Insere uma Tarefa na tabela tarefas.
  Future insereTarefa(Insertable<Tarefa> tarefa) =>
      into(tarefas).insert(tarefa);

  // Atualiza uma Tarefa através de sua chave primária.
  Future atualizaTarefa(Insertable<Tarefa> tarefa) =>
      update(tarefas).replace(tarefa);

  // Remove uma Tarefa através de sua chave primária.
  Future removeTarefa(Insertable<Tarefa> tarefa) =>
      delete(tarefas).delete(tarefa);

  // Drift aceita Streams que emitem elementos quando o dado observado for alterado.
  Stream<List<Tarefa>> observaAsTarefas() {
    // Envolver todo o statement de select em parenteses.
    return (select(
            tarefas) // Statements como orderBy e where returnam void, por isso a necessidade de usar o operador cascata "..".
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) => OrderingTerm(
                  expression: t.dataLimite, mode: OrderingMode.desc),
              // Secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.nome),
            ]),
          ))
        .watch();
  }

  Stream<List<Tarefa>> observaSomenteTarefasConcluidas() {
    // where returns void, need to use the cascading operator
    return (select(tarefas)
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) => OrderingTerm(
                  expression: t.dataLimite, mode: OrderingMode.desc),
              // Secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.nome),
            ]),
          )
          ..where((t) => t.terminada.equals(true)))
        .watch();
  }

  Stream<List<Tarefa>> watchCompletedTarefasCustom() {
    // [HINT] you can use 'customUpdate' to update
    return customSelect(
      'SELECT * FROM tarefas WHERE completed = 1 ORDER BY due_date DESC, name;',
      // The Stream will emit new values when the data inside the Tarefas table changes
      readsFrom: {tarefas},
    ).watch()
        // customSelect or customSelectStream gives us QueryRow list
        // This runs each time the Stream emits a new value.
        .map(
      (rows) {
        // Turning the data of a row into a Tarefa object
        return rows.map((row) => Tarefa.fromData(row.data)).toList();
      },
    );
  }
}
