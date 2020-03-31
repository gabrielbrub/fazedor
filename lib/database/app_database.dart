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
//      db.execute("CREATE TABLE SALDO (valor INTEGER)");
    //INSERT INTO NAMES2 (id, Name) SELECT id, Name FROM NAMES1; <- update like this
      db.execute(ConfigDAO.tableSaldo);
      db.execute(HistoricoDAO.tableSql);
      db.execute("INSERT INTO SALDO VALUES (0)");
      db.execute(TarefaDAO.tableSql);
      db.execute(RecompensaDAO.tableSql);
      debugPrint(db.getVersion().toString());
    },
    version: 5,
    //onDowngrade: onDatabaseDowngradeDelete,
    onUpgrade: (db, oldVersion, newVersion){
//        db.execute("ALTER TABLE TAREFAS ADD COLUMN descartavel INTEGER");
//        db.execute("ALTER TABLE RECOMPENSAS ADD COLUMN descartavel INTEGER");
//      db.execute("ALTER TABLE SALDO RENAME TO SALDO_OLD");
//      db.execute("CREATE TABLE SALDO (valor integer)");
//      db.execute("INSERT INTO SALDO SELECT * FROM SALDO_OLD");
//      db.execute("DROP TABLE SALDO_OLD");
//      db.execute(ConfigDAO.tableSql);
//      db.execute(HistoricoDAO.tableSql);
    },
    onOpen: (db) async {
      int ver = await db.getVersion();
       debugPrint(ver.toString());
    }
  );

}
