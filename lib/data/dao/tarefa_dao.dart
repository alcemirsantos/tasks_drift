// Indica a tabela que deve acessar e queries customizadas escritas em SQL.
import 'package:drift/drift.dart';

import '../banco_de_dados.dart';
import '../tables/etiquetas.dart';
import '../tables/tarefas.dart';

part 'tarefa_dao.g.dart';

@DriftAccessor(
  tables: [Tarefas, Etiquetas],
  queries: {
    // Uma implemntação desta query irá ser gerada dentro do mixin _$TarefaDaoMixin
    // Ambas tarefasCompletasGerado() e observaTarefasFinalizdasComSQL() serão criadas.
    'tarefasCompletasGerado':
        'SELECT * FROM tarefas WHERE terminada = 1 ORDER BY data_limite DESC, nome;'
  },
)
class TarefaDao extends DatabaseAccessor<BancoDeDados> with _$TarefaDaoMixin {
  final BancoDeDados db;

  TarefaDao(this.db) : super(db);

  /// Todas as tabelas tem getters nas classes geradas - nós podemos selecionar
  ///    a tabela Tarefas
  Future<List<Tarefa>> recuperaTodasaAsTarefas() => select(tarefas).get();

  /// Insere uma Tarefa na tabela tarefas.
  Future insereTarefa(Insertable<Tarefa> tarefa) =>
      into(tarefas).insert(tarefa);

  /// Atualiza uma Tarefa através de sua chave primária.
  Future atualizaTarefa(Insertable<Tarefa> tarefa) =>
      update(tarefas).replace(tarefa);

  /// Remove uma Tarefa através de sua chave primária.
  Future removeTarefa(Insertable<Tarefa> tarefa) =>
      delete(tarefas).delete(tarefa);

  Future<Tarefa> getTarefa(int id) {
    return (select(tarefas)
          ..where(
            (row) => row.id.equals(id),
          ))
        .getSingle();
  }

  /// Só um alias para chamar tarefas completas
  Stream<List<TarefaEtiquetada>> observaSomenteTareafasCompletas() {
    return observaAsTarefas(true);
  }

  /// Drift aceita Streams que emitem elementos quando o dado observado for alterado.
  Stream<List<TarefaEtiquetada>> observaAsTarefas(
      [bool somenteFinalizadas = false]) {
    var resultadoDoSelectOrdenado = (select(
        tarefas) // Statements como orderBy e where returnam void, por isso a necessidade de usar o operador cascata "..".
      ..orderBy(
        [
          // Ordenar primeiro pela data limite em ordem descrecente
          (t) =>
              OrderingTerm(expression: t.dataLimite, mode: OrderingMode.desc),
          // Depois ordenar em ordem alfabética
          (t) => OrderingTerm(expression: t.nome),
        ],
      )
      ..where(
        // caso o parametro [somenteFinalizadas] seja true, filtrar pelo valor
        //  da coluna 'terminada'.
        (tarefa) => somenteFinalizadas
            ? tarefa.terminada.equals(somenteFinalizadas)
            : tarefa.id.isBiggerThanValue(0),
      ));

    return resultadoDoSelectOrdenado
        .join(
          [
            leftOuterJoin(
              etiquetas,
              etiquetas.nome.equalsExp(tarefas.nomeEtiqueta),
            ),
          ],
        )
        .watch()
        .map((rows) => rows.map((row) {
              return TarefaEtiquetada(
                tarefa: row.readTable(tarefas),
                etiqueta: row.readTableOrNull(etiquetas)!,
              );
            }).toList());
  }

  // Stream<List<Tarefa>> observaTarefasFinalizdasComSQL() {
  //   // [Dica] você pode usar o 'customUpdate' para atualizar
  //   return customSelect(
  //     'SELECT * FROM tarefas WHERE terminada = 1 ORDER BY data_limite DESC, nome;',
  //     // O Stream irá emitir novos valores quando os dados dentro da tabela
  //     //  Tarefas mudar
  //     readsFrom: {tarefas},
  //   )
  //       .watch()
  //       // customSelect ou customSelectStream retornam uma lista QueryRow
  //       // O método abaixo executar cada vez que o Stream emitir um novo valor.
  //       .map(
  //     (rows) {
  //       // Transformando o dado de uma linha da tabela em um objeto Tarefa.
  //       return rows.map((row) => Tarefa.fromData(row.data)).toList();
  //     },
  //   );
  // }
}

// É preciso juntar tarefas e tags manualmente.
// Esta classe será usada para fazer o join das tabelas.
class TarefaEtiquetada {
  final Tarefa tarefa;
  final Etiqueta etiqueta;

  TarefaEtiquetada({
    required this.tarefa,
    required this.etiqueta,
  });
}
