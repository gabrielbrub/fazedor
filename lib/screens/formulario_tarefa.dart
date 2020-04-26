

import '../database/tarefa_dao.dart';
import '../widgets/editor.dart';
import '../model/tarefa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

final _tituloAppBar = 'Criar Tarefa';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '00000';

const _rotuloCampoNome = 'Nome da tarefa';
const _dicaCampoNome = '';

const _textoBotaoConfirmar = 'Confirmar';

class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }

  FormularioTransferencia();
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNome =
  TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();
  final TextEditingController _controladorCampoDescricao = TextEditingController();
  final TarefaDAO _dao = TarefaDAO();
  bool descartavel = true;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_tituloAppBar),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Editor(
                controlador: _controladorCampoNome,
                dica: _dicaCampoNome,
                rotulo: _rotuloCampoNome,
                limite: 40,
              ),
              Editor(
                dica: _dicaCampoValor,
                controlador: _controladorCampoValor,
                rotulo: _rotuloCampoValor,
                icone: Icons.monetization_on,
                tipo: TextInputType.number,
                limite: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: TextField(
                    maxLines: 10,
                    controller: _controladorCampoDescricao,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descrição',
                      ),
                  ),
                ),
              ),
              CheckboxListTile(
                title: const Text('Descartar ao concluir'),
                value: descartavel,
                onChanged: (bool value) {
                  setState(() {
                    descartavel = value;
                    timeDilation = value ? 2.0 : 1;
                  });
                },
                secondary: const Icon(Icons.delete),
              ),
              RaisedButton(
                child: Text(_textoBotaoConfirmar),
                onPressed: () => _salvaTarefa(context),
              ),
            ],
          ),
        ));
  }

  void _salvaTarefa(BuildContext context) {
    final String nome = _controladorCampoNome.text;
    final double valor = double.tryParse(_controladorCampoValor.text);
    final String descricao = _controladorCampoDescricao.text;
    if (nome != null && valor != null) {
      final tarefaSalva = Tarefa(0, nome, descricao, valor.toInt(), descartavel);
      _dao.save(tarefaSalva).then((id) => Navigator.pop(context));
    }
  }
}
