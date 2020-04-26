
import 'package:fazedor/database/recompensa_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widgets/editor.dart';
import '../model/recompensa.dart';


final _tituloAppBar = 'Editar Recompensa';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '00000';

const _rotuloCampoNome = 'Nome da recompensa';
const _dicaCampoNome = '';

const _textoBotaoConfirmar = 'Confirmar';




class EditorRecompensa extends StatefulWidget {
  Recompensa recompensa;

  EditorRecompensa(this.recompensa);

  @override
  _EditorRecompensaState createState() => _EditorRecompensaState();
}

class _EditorRecompensaState extends State<EditorRecompensa> {
  final TextEditingController _controladorCampoNome =
  TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();
  final TextEditingController _controladorCampoDescricao = TextEditingController();
  final RecompensaDAO _dao = RecompensaDAO();
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: SizedBox(
                  height: 200,
                  child: TextField(
                    maxLines: 7,
                    maxLength: 300,
                    maxLengthEnforced: true,
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
                onPressed: () => _updateTarefa(context),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    descartavel = widget.recompensa.descartavel;
    _controladorCampoNome.text = widget.recompensa.nome;
    _controladorCampoValor.text = widget.recompensa.valor.toString();
    _controladorCampoDescricao.text = widget.recompensa.descricao;
  }


  void _updateTarefa(BuildContext context) {
    final String nome = _controladorCampoNome.text;
    final double valor = double.tryParse(_controladorCampoValor.text);
    final String descricao = _controladorCampoDescricao.text;
    final int id = widget.recompensa.id;
    if (nome != null && valor != null) {
      final recompensaSalva = Recompensa(id, nome, descricao, valor.toInt(), descartavel);
      _dao.update(recompensaSalva).then((id) => Navigator.pop(context));
    }
  }
}
