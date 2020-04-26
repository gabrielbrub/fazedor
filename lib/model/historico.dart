import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Historico{
  String nome;
  int isTarefa;
  String data;
  int id;
  int valor;


  String convert(var data){
    if(data is DateTime){
      var formatter = new DateFormat('dd-MM-yyyy');
      String formatted = formatter.format(data);
      debugPrint('formatted: ' + formatted);
      return formatted;
    }
      return data;
  }

  Historico(String nome, int isTarefa, var data, int id, int valor){
    this.nome = nome;
    this.isTarefa = isTarefa;
    this.data = convert(data);
    this.id = id;
    this.valor = valor;

  }

}

