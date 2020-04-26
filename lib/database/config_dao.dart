
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class ConfigDAO {
  static const String _value = 'valor';

  static const String tableSaldo = 'CREATE TABLE SALDO('
      '$_value INTEGER DEFAULT 0)';

  void atualizaSaldo(int valor) async {
    final Database db = await getDatabase();
    db.execute("UPDATE SALDO SET valor = valor + $valor");
  }


  Future<String> findSaldo() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('SALDO');
    return _toIntSaldo(result).toString();
  }

  int _toIntSaldo(List<Map<String, dynamic>> result) {
    final int saldo = result[0]['valor'];
    return saldo;
  }


  void apaga() async {
    final Database db = await getDatabase();
    db.execute("UPDATE SALDO SET VALOR = 0");
    db.execute("DELETE FROM TAREFAS");
    db.execute("DELETE FROM RECOMPENSAS");
    db.execute("DELETE FROM HISTORICO");
  }

}