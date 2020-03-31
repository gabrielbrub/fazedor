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
    Map<String, dynamic> recompensaMap = _toMap(recompensa);
    return db.insert(_tableName, recompensaMap);
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
    List<Recompensa> recompensas = _toList(result);
    return recompensas;
  }

  Map<String, dynamic> _toMap(Recompensa recompensa) {
    final Map<String, dynamic> recompensaMap = Map();
    recompensaMap[_name] = recompensa.nome;
    recompensaMap[_description] = recompensa.descricao;
    recompensaMap[_value] = recompensa.valor;
    recompensaMap[_disposable] = recompensa.descartavel == true ? 1 : 0;
    return recompensaMap;
  }

  List<Recompensa> _toList(List<Map<String, dynamic>> result) {
    final List<Recompensa> recompensas = List();
    for (Map<String, dynamic> row in result) {
      final Recompensa recompensa = Recompensa(
        row[_id],
        row[_name],
        row[_description],
        row[_value],
        row[_disposable] == 1 ? true : false,
      );
      recompensas.add(recompensa);
    }
    return recompensas;
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