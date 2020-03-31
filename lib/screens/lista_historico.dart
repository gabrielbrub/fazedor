import 'package:fazedor/database/historico_dao.dart';
import 'package:fazedor/model/historico.dart';
import 'package:fazedor/my_flutter_app_icons.dart';
import 'package:fazedor/widgets/progress.dart';
import 'package:flutter/material.dart';

import '../database/config_dao.dart';

List<Historico> historicos;

class TelaHistorico extends StatefulWidget {
  HistoricoDAO _dao = HistoricoDAO();

  @override
  _TelaHistoricoState createState() => _TelaHistoricoState();
}

class _TelaHistoricoState extends State<TelaHistorico> {
  int numItems = 0;

  @override
  Widget build(BuildContext context) {
    widget._dao.limpa();
    return FutureBuilder<List<Historico>>(
      initialData: List(),
      future: Future.delayed(Duration(milliseconds: 300)).then((value) => widget._dao.findAll()), //widget._dao.findAll(),
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
            historicos = snapshot.data;
            if (historicos == null) {
              numItems = 0;
              debugPrint(numItems.toString() + 'NUMITEMS 0');
            } else {
              numItems = historicos.length;
              historicos = historicos.reversed.toList();
            }
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Saldo: ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
                        SizedBox(width: 5,),
                        ExibeSaldo(),
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
                      final Historico historico = historicos[index];
                      return Card(
                          child: ListTile(
                            leading: _itemIcon(historico.isTarefa),
                            title: _itemTitle(historico.valor, historico.isTarefa),
                            subtitle: Text(historico.nome),
                            trailing: Text(historico.data),
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

class _itemIcon extends StatelessWidget {
  int isTarefa;

  _itemIcon(this.isTarefa);

  @override
  Widget build(BuildContext context) {
    if (isTarefa == 1) {
      return Icon(Icons.playlist_add_check);
    }
    return Icon(MyFlutterApp.award);
  }
}




class ExibeSaldo extends StatelessWidget {
  ConfigDAO _dao = ConfigDAO();
  String saldo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _dao.findSaldo(), // a previously-obtained Future<String> or null
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Text('');
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            saldo = snapshot.data;
            return Text(saldo, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),);
            break;
        }
        return Text('Unknown error');
      },
    );
  }
}

