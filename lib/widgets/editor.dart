import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;
  final TextInputType tipo;
  final int limite;

  Editor({
    this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.tipo,
    this.limite,
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        maxLength: limite,
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: tipo,
      ),
    );
  }
}
