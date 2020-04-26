import 'package:flutter/cupertino.dart';
import 'config_dao.dart';
import 'historico_dao.dart';
import 'tarefa_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'recompensa_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'fazedor.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ConfigDAO.tableSaldo);
      db.execute(HistoricoDAO.tableSql);
      db.execute("INSERT INTO SALDO VALUES (0)");
      db.execute(TarefaDAO.tableSql);
      db.execute(RecompensaDAO.tableSql);
      debugPrint(db.getVersion().toString());
    },
    version: 1,
    //onDowngrade: onDatabaseDowngradeDelete,
    onUpgrade: (db, oldVersion, newVersion){
    },
    onOpen: (db) async {
      int ver = await db.getVersion();
       debugPrint(ver.toString());
    }
  );

}
