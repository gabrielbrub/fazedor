import 'package:fazedor/model/historico.dart';
import 'package:sqflite/sqflite.dart';
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

  Future<int> save(Historico registro) async {
    final Database db = await getDatabase();
    Map<String, dynamic> historicoMap = _toMap(registro);
    return db.insert(_tableName, historicoMap);
  }

  Future<List<Historico>> findAll() async {
    //limpa();
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Historico> registros = _toList(result);
    return registros;
  }

  Map<String, dynamic> _toMap(Historico registro) {
    final Map<String, dynamic> historicoMap = Map();
    historicoMap[_name] = registro.nome;
    historicoMap[_date] = registro.data;
    historicoMap[_id] = registro.id;
    historicoMap[_isTarefa] = registro.isTarefa;
    historicoMap[_value] = registro.valor;
    return historicoMap;
  }

  List<Historico> _toList(List<Map<String, dynamic>> result) {
    final List<Historico> registros = List();
    for (Map<String, dynamic> row in result) {
      final Historico registro = Historico(
        row[_name],
        row[_isTarefa],
        row[_date],
        row[_id],
        row[_value],
      );
      registros.add(registro);
    }
    return registros;
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
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