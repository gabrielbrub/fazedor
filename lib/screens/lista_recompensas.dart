import 'package:fazedor/database/config_dao.dart';
import 'package:fazedor/database/historico_dao.dart';
import 'package:fazedor/infinity_icon.dart';
import 'package:fazedor/model/historico.dart';
import 'package:fazedor/model/recompensa.dart';
import 'package:fazedor/screens/editor_recompensa.dart';
import 'package:fazedor/widgets/centered_message.dart';
import 'package:fazedor/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/recompensa_dao.dart';



class TelaRecompensas extends StatefulWidget {
  @override
  _TelaRecompensasState createState() => _TelaRecompensasState();
}

class _TelaRecompensasState extends State<TelaRecompensas> {
  List<Recompensa> recompensas;
  final RecompensaDAO _dao = RecompensaDAO();
  final ConfigDAO _daoConfig = ConfigDAO();
  final HistoricoDAO _daoHistorico = HistoricoDAO();
  @override
  Widget build(BuildContext context) {
    int numItems;
    return FutureBuilder<List<Recompensa>>(
      initialData: List(),
      future: Future.delayed(Duration(milliseconds: 300)).then((value) => _dao.findAll()),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
            recompensas = snapshot.data;
            if(recompensas.isNotEmpty) {
              numItems = recompensas.length;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Recompensa recompensa = recompensas[index];
                  return GestureDetector(
                    child: Card(
                        child: Dismissible(
                          key: Key(recompensa.id.toString()),
                          background: slideRightBackground(),
                          secondaryBackground: slideLeftBackground(),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final bool res = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RemoveDialog(recompensa, index);
                                  });
                              return res;
                            } else {
                              String saldo = await _daoConfig.findSaldo();
                              if(recompensa.valor > int.parse(saldo)) {
                                _saldoInsuficienteToast();
                                return false;
                              }
                              if (recompensa.descartavel == true) {
                                _dao.delete(recompensa.id);
                              }else{
                                Fluttertoast.showToast(
                                  msg: '${recompensa.nome} não é descartável.',
                                  backgroundColor: Colors.red[400],
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIos: 1,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                );
                                return false;
                              }
                              var now = new DateTime.now();
                              final Historico registro = Historico(
                                  recompensa.nome, 0, now, null,
                                  recompensa.valor);
                              _daoHistorico.save(registro);
                              _daoConfig.atualizaSaldo(
                                  -recompensa.valor);
                              _recompensaResgatadaToast(recompensa);
                              setState(() {
                                recompensas.removeAt(index);
                              });
                              return true;
                            }
                          },
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    EditorRecompensa(recompensa)),
                              );
                            },
                            child: ListTile(
                              leading: recompensa.descartavel ? Icon(Icons.check) : Icon(Infinity.infinity),
                              title: Text(recompensa.nome.toString(),
                                style: TextStyle(fontSize: 18.0),),
                              subtitle: Text(recompensa.valor.toString()),
                              trailing: menu(recompensa, index),
                            ),
                          ),
                        )),
                  );
                },
                itemCount: numItems,
              );
            }
            if(snapshot.connectionState == ConnectionState.done)
              return CenteredMessage('Vazio');
            if(snapshot.connectionState == ConnectionState.waiting)
              return Progress(message: 'loading',);
        }
        return Text('Unknown error');
      },
    );
  }

  void _showDialog(Recompensa recompensa, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "Tem certeza que deseja remover ${recompensa
                  .nome}?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancelar",
                style: TextStyle(
                    color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "Deletar",
                style: TextStyle(
                    color: Colors.red),
              ),
              onPressed: () {
                setState(() {
                  recompensas.removeAt(index);
                });
                _dao.delete(recompensa.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget menu(Recompensa recompensa,int index){
    return PopupMenuButton<int>(
      onSelected: (int result) async{
        switch(result){
          case 1:
            String saldo = await _daoConfig.findSaldo();
            if(int.parse(saldo) < recompensa.valor){
              _saldoInsuficienteToast();
              break;
            }
            var now = new DateTime.now();
            final Historico registro =
            Historico(recompensa.nome, 0, now, null, recompensa.valor);
            _daoHistorico.save(registro);
            _daoConfig.atualizaSaldo(-recompensa.valor);
            debugPrint(recompensa.valor.toString());
            if (recompensa.descartavel) {
              _dao.delete(recompensa.id);
              _recompensaResgatadaToast(recompensa);
              setState(() {
              });
            }
            break;
          case 2:
            _showDialog(recompensa, index);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Concluir"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Deletar"),
        ),
      ],
    );
  }

  void _saldoInsuficienteToast() {
    Fluttertoast.showToast(
      msg: 'Saldo insuficiente.',
      backgroundColor: Colors.red[400],
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIos: 1,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
    );
  }

  void _recompensaResgatadaToast(Recompensa recompensa) {
    Fluttertoast.showToast(
        msg: "Recompensa Resgatada: - " +
            recompensa.valor.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.orange[500],
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.orange[500],
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            Text(
              "Resgatar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Deletar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget RemoveDialog(Recompensa recompensa, int index){
    return AlertDialog(
      content: Text(
          "Tem certeza que deseja remover ${recompensa
              .nome}?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Cancelar",
            style: TextStyle(
                color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(
            "Deletar",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            setState(() {
              recompensas.removeAt(index);
            });
            _dao.delete(recompensa.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

}













