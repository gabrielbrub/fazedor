import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:fazedor/database/config_dao.dart';
import 'package:fazedor/screens/lista_historico.dart';
import 'package:fazedor/screens/lista_recompensas.dart';
import 'package:fazedor/screens/formulario_tarefa.dart';
import 'package:fazedor/screens/formulario_recompensa.dart';
import 'package:flutter/material.dart';
import 'lista_tarefas.dart';
import '../database/tarefa_dao.dart';

import 'package:fazedor/my_flutter_app_icons.dart';

class InitialScreen extends StatefulWidget {
  bool isDark;

  InitialScreen(this.isDark);

  @override
  _initial_screenState createState() => _initial_screenState();
}

class _initial_screenState extends State<InitialScreen> {
  int _selectedIndex = 0;
  Widget selecao;
  final TarefaDAO _dao = TarefaDAO();
  final ConfigDAO _daoConfig = ConfigDAO();
  bool visivel = true;
  String saldo = '';

  TelaProjeto telaProjeto;
  TelaRecompensas telaRecompensas;
  TelaHistorico telaHistorico;


  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Text _nomeTela = Text('Tarefas');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            visivel = true;
            selecao = TelaProjeto(this.refresh);
            _nomeTela = Text('Tarefas');
          }
          break;
        case 1:
          {
            visivel = true;
            selecao = TelaRecompensas(this.refresh);
            _nomeTela = Text('Recompensas');
          }
          break;
        case 2:
          {
            visivel = false;
            selecao = TelaHistorico();
            _nomeTela = Text('Histórico');
          }
          break;
      }
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSaldo();
    setState(() {
      _selectedIndex = 0;
      telaHistorico = TelaHistorico();
      telaProjeto = TelaProjeto(this.refresh);
      telaRecompensas = TelaRecompensas(this.refresh);
      selecao = telaProjeto;
    });
  }

  void getSaldo() async {
    saldo = await _daoConfig.findSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        centerTitle: true,
        title: _nomeTela,
      ),
      endDrawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Configurações',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Text(saldo),
                  ]),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Apagar tudo'),
              leading: Icon(Icons.delete),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Deseja apagar tudo?"),
                      content: Text('Essa operação não tem volta.'),
                      actions: [
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            _daoConfig.apaga();
                            Navigator.pop(context);
                            setState(() {
                              _onItemTapped(_selectedIndex);
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Modo Escuro'),
              value: widget.isDark,
              onChanged: (bool value) {
                setState(() {
                  DynamicTheme.of(context).setBrightness(
                      value ? Brightness.dark : Brightness.light);
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
          ),
        ],
      ) // Populate the Drawer in the next step.
          ),
      body: selecao,
      //_widgetOptionsBody.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check),
            title: Text('Tarefas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.award),
            title: Text('Recompensas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Histórico'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: Visibility(
        visible: visivel,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            switch (_selectedIndex) {
              case 0:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormularioTransferencia()),
                  );
                }
                break;
              case 1:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormularioRecompensa()),
                  );
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
