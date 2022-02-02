import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tarefas.dart';

part 'banco_de_dados.g.dart';

// Esta anotação diz ao gerador de código quais tabelas este banco de dados trabalha
@DriftDatabase(tables: [Tarefas])
// _$BancoDeDados é o nome da classe gerada
class BancoDeDados extends _$BancoDeDados {
  BancoDeDados()
      // Especifica a localização do arquivo de banco de dados
      : super(_openConnection());

  // Esta versão é versão do banco. Será utilizado pra a criação de Migrations.
  @override
  int get schemaVersion => 1;

  // Todas as tabelas tem getters nas classes geradas - nós podemos selecionar
  //    a tabela Tarefas
  Future<List<Tarefa>> recuperaTodasaAsTarefas() => select(tarefas).get();

  // Drift aceita Streams que emitem elementos quando o dado observado for alterado.
  Stream<List<Tarefa>> observaAsTarefas() => select(tarefas).watch();

  // Insere uma Tarefa na tabela tarefas.
  Future insereTarefa(Tarefa Tarefa) => into(tarefas).insert(Tarefa);

  // Atualiza uma Tarefa através de sua chave primária.
  Future atualizaTarefa(Tarefa Tarefa) => update(tarefas).replace(Tarefa);

  // Remove uma Tarefa através de sua chave primária.
  Future removeTarefa(Tarefa Tarefa) => delete(tarefas).delete(Tarefa);
}

/// Especifica a localização do arquivo de banco de dados
LazyDatabase _openConnection() {
  // este objeto nos permite setar a localização do arquivo de forma assíncrona.
  return LazyDatabase(() async {
    // colocar o arquivo de banco de dados, chamado db.sqlite aqui, dentro da
    //    pasta 'documentos' do nosso app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
