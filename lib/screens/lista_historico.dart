import 'package:fazedor/database/historico_dao.dart';
import 'package:fazedor/model/historico.dart';
import 'package:fazedor/my_flutter_app_icons.dart';
import 'package:fazedor/widgets/progress.dart';
import 'package:flutter/material.dart';

import '../database/config_dao.dart';



class TelaHistorico extends StatefulWidget {
  HistoricoDAO _dao = HistoricoDAO();

  @override
  _TelaHistoricoState createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  int numItems = 0;
  String saldo = '';
  List<Historico> registros;

  @override
  Widget build(BuildContext context) {
    widget._dao.limpa();
    return FutureBuilder<List<Historico>>(
      initialData: List(),
      future: Future.delayed(Duration(milliseconds: 300)).then((value) => widget._dao.findAll()),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Progress();
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            registros = snapshot.data;
            if (registros == null) {
              numItems = 0;
            } else {
              numItems = registros.length;
              registros = registros.reversed.toList();
            }
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Saldo: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                        SizedBox(width: 5,),
                        Text(saldo),
                        SizedBox(width: 5,),
                        Icon(Icons.monetization_on, color: Colors.white, size: 18,),
                      ]
                  ),
                  color: Colors.green,
                  height: 40,
                  width: double.infinity,
                ),
                Expanded(
                  child: ListView.builder(
                    //reverse: true,
                    itemBuilder: (context, index) {
                      final Historico registro = registros[index];
                      return Card(
                          child: ListTile(
                            leading: registro.isTarefa==1 ? Icon(Icons.playlist_add_check) : Icon(MyFlutterApp.award),
                            title: _itemTitle(registro.valor, registro.isTarefa),
                            subtitle: Text(registro.nome),
                            trailing: Text(registro.data),
                      ));
                    },
                    itemCount: numItems,
                  ),
                ),
              ],
            );

            break;
        }
        return Text('Unknown error');
      },
    );
  }

  @override
  void initState() {
    getSaldo();
    super.initState();
  }

  void getSaldo() async{
    ConfigDAO _daoConfig = ConfigDAO();
    saldo = await _daoConfig.findSaldo();
  }

}

class _itemTitle extends StatelessWidget {
  int valor;
  int isTarefa;

  _itemTitle(this.valor, this.isTarefa);

  @override
  Widget build(BuildContext context) {
    if (isTarefa == 1) {
      return Text(
        valor.toString(),
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18.0),
      );
    }
    return Text(
      valor.toString(),
      style: TextStyle(
          color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18.0),
    );
  }
}



