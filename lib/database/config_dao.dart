import 'package:fazedor/model/saldo.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class ConfigDAO {
//  static const String _tableName = 'configuracoes';
//  static const String _name = 'nome';
//  static const String _id = 'id';
  static const String _value = 'valor';
//  static const String tableSql = 'CREATE TABLE $_tableName('
//      '$_id INTEGER PRIMARY KEY, '
//      '$_value STRING)';
  static const String tableSaldo = 'CREATE TABLE SALDO('
      '$_value INTEGER DEFAULT 0)';

  void atualizaSaldo(int valor) async {
    final Database db = await getDatabase();
    db.execute("UPDATE SALDO SET valor = valor + $valor");
  }

//  Future<List<Saldo>> findAllSaldo() async {
//    final Database db = await getDatabase();
//    final List<Map<String, dynamic>> result = await db.query('SALDO');
//    List<Saldo> saldo = _toListSaldo(result);
//    debugPrint('findall chamado - saldo ');
//    return saldo;
//  }

  Future<String> findSaldo() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('SALDO');
    List<Saldo> saldos = _toListSaldo(result);
    return saldos.elementAt(0).toString();
  }


  List<Saldo> _toListSaldo(List<Map<String, dynamic>> result) {
    final List<Saldo> tarefas = List();
    for (Map<String, dynamic> row in result) {
      final Saldo saldo = Saldo(
        row['valor'],
      );
      tarefas.add(saldo);
    }
    return tarefas;
  }

  void apaga() async {
    final Database db = await getDatabase();
    db.execute("UPDATE SALDO SET VALOR = 0");
    db.execute("DELETE FROM TAREFAS");
    db.execute("DELETE FROM RECOMPENSAS");
    db.execute("DELETE FROM HISTORICO");
  }

}