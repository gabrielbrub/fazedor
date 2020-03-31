import 'package:fazedor/database/recompensa_dao.dart';
import 'package:flutter/foundation.dart';

import 'package:fazedor/widgets/editor.dart';
import 'package:fazedor/model/recompensa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final _tituloAppBar = 'Criar Recompensa';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '00000';

const _rotuloCampoNome = 'Nome da recompensa';
const _dicaCampoNome = '';

const _textoBotaoConfirmar = 'Confirmar';

class FormularioRecompensa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioRecompensaState();
  }

  FormularioRecompensa();
}

class FormularioRecompensaState extends State<FormularioRecompensa> {
  final TextEditingController _controladorCampoNome =
  TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();
  final TextEditingController _controladorCampoDescricao = TextEditingController();
  final RecompensaDAO _dao = RecompensaDAO();
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
                onPressed: () => _salvaRecompensa(context),
              ),
            ],
          ),
        ));
  }

  void _salvaRecompensa(BuildContext context) {
    final String nome = _controladorCampoNome.text;
    final double valor = double.tryParse(_controladorCampoValor.text);
    final String descricao = _controladorCampoDescricao.text;
    if (nome != null && valor != null) {
      final recompensaSalva = Recompensa(0, nome, descricao, valor.toInt(), descartavel);
      _dao.save(recompensaSalva).then((id) => Navigator.pop(context));
    }
  }
}
