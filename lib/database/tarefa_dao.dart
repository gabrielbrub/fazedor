import 'package:fazedor/model/saldo.dart';
import 'package:fazedor/model/tarefa.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class TarefaDAO {

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_name TEXT, '
      '$_description TEXT,'
      '$_value INTEGER,'
      '$_disposable INTEGER)';
  static const String _tableName = 'tarefas';
  static const String _id = 'id';
  static const String _name = 'nome';
  static const String _description = 'descricao';
  static const String _value = 'valor';
  static const String _disposable = 'descartavel';

  Future<int> save(Tarefa tarefa) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(tarefa);
    debugPrint('save chamado - ' + tarefa.valor.toString());
    return db.insert(_tableName, contactMap);
  }

//  Future<int> update(Tarefa tarefa) async {
//    final Database db = await getDatabase();
//    Map<String, dynamic> tarefaMap = _toMap(tarefa);
//    debugPrint('update chamado');
//    return db.update(_tableName, tarefaMap);
//  }

  Future<List<Tarefa>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Tarefa> contacts = _toList(result);
    debugPrint('findall chamado');
    return contacts;
  }

  Future<int> update(Tarefa contact) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> contactMap = _toMap(contact);
    return db.update(
      _tableName,
      contactMap,
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    debugPrint('delete chamado');
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(Tarefa tarefa) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = tarefa.nome;
    contactMap[_description] = tarefa.descricao;
    contactMap[_value] = tarefa.valor;
    contactMap[_disposable] = tarefa.descartavel == true ? 1 : 0;
    return contactMap;
  }

  List<Tarefa> _toList(List<Map<String, dynamic>> result) {
    final List<Tarefa> tarefas = List();
    for (Map<String, dynamic> row in result) {
      final Tarefa contact = Tarefa(
        row[_id],
        row[_name],
        row[_description],
        row[_value],
        row[_disposable] == 1 ? true : false,
      );
      tarefas.add(contact);
    }
    return tarefas;
  }



}