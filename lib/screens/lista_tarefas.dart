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

class TelaProjeto extends StatefulWidget {
  Function refresh;

  TelaProjeto(this.refresh);

  @override
  TelaProjetoState createState() => TelaProjetoState();
}

class TelaProjetoState extends State<TelaProjeto> {
  List<Tarefa> tarefas;
  TarefaDAO _dao = TarefaDAO();
  ConfigDAO _daoConfig = ConfigDAO();
  int numItems = 0;
  final HistoricoDAO _daoHistorico = HistoricoDAO();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Tarefa>>(
      initialData: List(),
      future: Future.delayed(Duration(milliseconds: 300))
          .then((value) => _dao.findAll()), //widget._dao.findAll(), //
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          tarefas = snapshot.data;
          if (tarefas.isNotEmpty) {
            numItems = tarefas.length;
            return ListView.builder(
              itemBuilder: (context, index) {
                final Tarefa tarefa = tarefas[index];
                return GestureDetector(
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditorTarefa(tarefa)),
                        );
                      },
                      child: ListTile(
                        leading: (tarefa.descartavel)
                            ? Icon(Icons.check)
                            : Icon(Infinity.infinity),
                        title: Text(tarefa.nome.toString()),
                        subtitle: Text(tarefa.valor.toString()),
                        trailing: menu(tarefa, index),
                      ),
                    ),
                  ),
                );
              },
              itemCount: numItems,
            );
          }
          if (snapshot.connectionState == ConnectionState.done)
            return CenteredMessage('Vazio');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Progress(
              message: 'loading',
            );
        }
        return Text('Unknown error');
      },
    );
  }

  Widget removeDialog(Tarefa tarefa, int index) {
    return AlertDialog(
      content: Text("Tem certeza que deseja remover ${tarefa.nome}?"),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.black),
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
              tarefas.removeAt(index);
            });
            _dao.delete(tarefa.id);
            widget.refresh();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget menu(Tarefa tarefa, int index) {
    return PopupMenuButton<int>(
      onSelected: (int result) {
        switch (result) {
          case 1:
            var now = new DateTime.now();
            final Historico registro =
                Historico(tarefa.nome, 1, now, null, tarefa.valor);
            _daoHistorico.save(registro);
            _daoConfig.atualizaSaldo(tarefa.valor);
            debugPrint(tarefa.valor.toString());
            if (tarefa.descartavel == true) {
              _dao.delete(tarefa.id);
            }
            Fluttertoast.showToast(
                msg: "Tarefa Concluída: + " + tarefa.valor.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.green[500],
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {});
            break;
          case 2:
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return removeDialog(tarefa, index);
              },
            );
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
