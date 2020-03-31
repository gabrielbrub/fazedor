import 'package:fazedor/model/historico.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'app_database.dart';

class HistoricoDAO {
  static const String _tableName = 'historico';
  static const String _id = 'id';
  static const String _name = 'nome';
  static const String _date = 'data';
  static const String _value = 'valor';
  static const String _isTarefa = 'tarefa';

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$_name TEXT, '
      '$_date TEXT,'
      '$_value INTEGER,'
      '$_isTarefa INTEGER)';

  Future<int> save(Historico historico) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(historico);
    return db.insert(_tableName, contactMap);
  }

  Future<List<Historico>> findAll() async {
    //limpa();
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Historico> historicos = _toList(result);
    return historicos;
  }

  Map<String, dynamic> _toMap(Historico historico) {
    final Map<String, dynamic> historicoMap = Map();
    historicoMap[_name] = historico.nome;
    historicoMap[_date] = historico.data;
    historicoMap[_id] = historico.id;
    historicoMap[_isTarefa] = historico.isTarefa;
    historicoMap[_value] = historico.valor;
    return historicoMap;
  }

  List<Historico> _toList(List<Map<String, dynamic>> result) {
    final List<Historico> historicos = List();
    for (Map<String, dynamic> row in result) {
      final Historico historico = Historico(
        row[_name],
        row[_isTarefa],
        row[_date],
        row[_id],
        row[_value],
      );
      historicos.add(historico);
    }
    return historicos;
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

  void limpa() async{
    final Database db = await getDatabase();
    db.execute('DELETE FROM $_tableName WHERE id NOT IN (SELECT id FROM $_tableName ORDER BY id DESC LIMIT 10)');
  }

}