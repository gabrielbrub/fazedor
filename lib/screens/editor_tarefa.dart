import 'package:fazedor/database/tarefa_dao.dart';
import 'package:flutter/material.dart';
import '../widgets/editor.dart';
import '../model/tarefa.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

final _tituloAppBar = 'Editar Tarefa';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0000';

const _rotuloCampoNome = 'Nome da tarefa';
const _dicaCampoNome = '';

const _textoBotaoConfirmar = 'Confirmar';

class EditorTarefa extends StatefulWidget {
  Tarefa tarefa;

  EditorTarefa(this.tarefa);

  @override
  _EditorTarefaState createState() => _EditorTarefaState();
}

class _EditorTarefaState extends State<EditorTarefa> {
  final TextEditingController _controladorCampoNome = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();
  final TextEditingController _controladorCampoDescricao =
      TextEditingController();
  final TarefaDAO _dao = TarefaDAO();
  bool descartavel;



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
                tipo: TextInputType.text,
                limite: 35,
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
                    maxLines: 7,
                    maxLength: 300,
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
              ElevatedButton(
                child: Text(_textoBotaoConfirmar),
                onPressed: () => _updateTarefa(context),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    descartavel = widget.tarefa.descartavel;
    _controladorCampoNome.text = widget.tarefa.nome;
    _controladorCampoValor.text = widget.tarefa.valor.toString();
    _controladorCampoDescricao.text = widget.tarefa.descricao;
  }

  void _updateTarefa(BuildContext context) {
    final String nome = _controladorCampoNome.text;
    final double valor = double.tryParse(_controladorCampoValor.text);
    final String descricao = _controladorCampoDescricao.text;
    final int id = widget.tarefa.id;
    if (nome != null && valor != null) {
      final tarefaSalva = Tarefa(id, nome, descricao, valor.toInt(), descartavel);
      _dao.update(tarefaSalva).then((id) => Navigator.pop(context));
    }
  }
}
