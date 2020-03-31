import 'package:fazedor/database/config_dao.dart';
import 'package:fazedor/database/historico_dao.dart';
import 'package:fazedor/model/historico.dart';
import 'package:fazedor/screens/editor_tarefa.dart';
import 'package:fazedor/widgets/centered_message.dart';
import 'package:fazedor/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/tarefa.dart';
import '../database/tarefa_dao.dart';
import 'package:fazedor/infinity_icon.dart';

List<Tarefa> tarefas;

class TelaProjeto extends StatefulWidget {
  Function callback;
  TarefaDAO _dao = TarefaDAO();
  ConfigDAO _daoConfig = ConfigDAO();

  TelaProjeto(this.callback);

  @override
  TelaProjetoState createState() => TelaProjetoState();
}

class TelaProjetoState extends State<TelaProjeto> {
  int numItems = 0;
  final HistoricoDAO _daoHistorico = HistoricoDAO();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tarefa>>(
      initialData: List(),
      future: Future.delayed(Duration(milliseconds: 300)).then((value) => widget._dao.findAll()), //widget._dao.findAll(), //
      builder: (context, snapshot) {
            if(snapshot.hasData) {
              tarefas = snapshot.data;
              if (tarefas.isNotEmpty) {
                numItems = tarefas.length;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Tarefa tarefa = tarefas[index];
                    return GestureDetector(
                      //antes só instanciava itemprojeto
                      child: Card(
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditorTarefa(tarefa)),
                              );
                            },
                            child: ListTile(
                              leading: _itemIcon(tarefa.descartavel),
                              title: Text(tarefa.nome.toString()),
                              subtitle: Text(tarefa.valor.toString()),
                              trailing: menu(tarefa, index),
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

  void _showDialog(Tarefa tarefa, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          content: Text(
              "Tem certeza que deseja remover ${tarefa
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
                  tarefas.removeAt(index);
                });
                widget._dao.delete(tarefa.id);
                widget.callback();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget menu(Tarefa tarefa,int index){
    return PopupMenuButton<int>(
      onSelected: (int result){
        switch(result){
          case 1:
            var now = new DateTime.now();
            final Historico historico =
            Historico(tarefa.nome, 1, now, null, tarefa.valor);
            _daoHistorico.save(historico);
            widget._daoConfig.atualizaSaldo(tarefa.valor);
            debugPrint(tarefa.valor.toString());
            if (tarefa.descartavel == true) {
              widget._dao.delete(tarefa.id);
            }
            Fluttertoast.showToast(
                msg: "Tarefa Concluída: + " +
                    tarefa.valor.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green[500],
                textColor: Colors.white,
                fontSize: 16.0
            );
            setState(() {

            });
            break;
          case 2:
            _showDialog(tarefa, index);
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
}



class infinito extends StatelessWidget {
  final bool descartavel;
  infinito(this.descartavel);
  @override
  Widget build(BuildContext context) {
    if(descartavel==false){
      return Icon(Infinity.infinity); //Icons.all_inclusive
    }
    return Text('');
  }
}


class menu extends StatelessWidget {
  final Tarefa tarefa;
  final HistoricoDAO _daoHistorico;
  final ConfigDAO _daoConfig;
  final TarefaDAO _daoTarefa;
  menu(this.tarefa, this._daoConfig, this._daoHistorico, this._daoTarefa);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (int result){
        switch(result){
          case 1:
            var now = new DateTime.now();
            final Historico historico =
            Historico(
                tarefa.nome, 1, now, null, tarefa.valor);
            _daoHistorico.save(historico);
            _daoConfig.atualizaSaldo(tarefa.valor);
            debugPrint(tarefa.valor.toString());
            if (tarefa.descartavel == true) {
             _daoTarefa.delete(tarefa.id);
            }
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("First"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Second"),
        ),
      ],
    );
  }
}

Widget _itemIcon (bool isDescartavel){
  if (isDescartavel == true) {
    return Icon(Icons.check);
  }
  return Icon(Infinity.infinity);
}



