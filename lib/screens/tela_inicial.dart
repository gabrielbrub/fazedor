import 'package:adaptive_theme/adaptive_theme.dart';
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
  final ConfigDAO _daoConfig = ConfigDAO();
  bool visivel = true;
  Future<String> saldo;
  bool isDark;

  TelaProjeto telaProjeto;
  TelaRecompensas telaRecompensas;
  TelaHistorico telaHistorico;

  Text _nomeTela = Text('Tarefas');

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            visivel = true;
            selecao = telaProjeto; //TelaProjeto(this.refresh);
            _nomeTela = Text('Tarefas');
          }
          break;
        case 1:
          {
            visivel = true;
            selecao = telaRecompensas; //TelaRecompensas(this.refresh);
            _nomeTela = Text('Recompensas');
          }
          break;
        case 2:
          {
            visivel = false;
            selecao = telaHistorico; //TelaHistorico();
            _nomeTela = Text('Histórico');
          }
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    isDark = widget.isDark;
    saldo = getSaldo();
    setState(() {
      _selectedIndex = 0;
      telaHistorico = TelaHistorico();
      telaProjeto = TelaProjeto();
      telaRecompensas = TelaRecompensas();
      selecao = telaProjeto;
    });
  }

  Future<String> getSaldo() async {
    saldo = _daoConfig.findSaldo();
    return saldo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                setState(() {
                  saldo = getSaldo();
                });
                Scaffold.of(context).openEndDrawer();
              },
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
//                    Text(saldo),
                    FutureBuilder<String>(
                      future: saldo,
                      builder: (context, snapshot) {
                        print('GET SALDO');
                        if (snapshot.hasData) {
                          return Text(snapshot.data);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
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
                        ElevatedButton(
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
              value: isDark,
              onChanged: (bool value) {
                setState(() {
                  isDark = value;
                  if (value) {
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    AdaptiveTheme.of(context).setLight();
                  }
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
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.award),
            label: 'Recompensas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
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
