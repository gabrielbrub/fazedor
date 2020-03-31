import 'package:fazedor/model/saldo.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../model/recompensa.dart';
import 'app_database.dart';

class RecompensaDAO {

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_description TEXT,'
      '$_value INTEGER,'
      '$_disposable INTEGER)';
  static const String _tableName = 'recompensas';
  static const String _id = 'id';
  static const String _name = 'nome';
  static const String _description = 'descricao';
  static const String _value = 'valor';
  static const String _disposable = 'descartavel';

  Future<int> save(Recompensa recompensa) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(recompensa);
    debugPrint('save chamado - recompensa');
    return db.insert(_tableName, contactMap);
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Recompensa>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Recompensa> contacts = _toList(result);
    debugPrint('findall chamado- recompensa');
    return contacts;
  }

  Map<String, dynamic> _toMap(Recompensa tarefa) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = tarefa.nome;
    contactMap[_description] = tarefa.descricao;
    contactMap[_value] = tarefa.valor;
    contactMap[_disposable] = tarefa.descartavel == true ? 1 : 0;
    return contactMap;
  }

  List<Recompensa> _toList(List<Map<String, dynamic>> result) {
    final List<Recompensa> contacts = List();
    for (Map<String, dynamic> row in result) {
      final Recompensa contact = Recompensa(
        row[_id],
        row[_name],
        row[_description],
        row[_value],
        row[_disposable] == 1 ? true : false,
      );
      contacts.add(contact);
    }
    return contacts;
  }

  Future<int> update(Recompensa recompensa) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> contactMap = _toMap(recompensa);
    return db.update(
      _tableName,
      contactMap,
      where: 'id = ?',
      whereArgs: [recompensa.id],
    );
  }


}