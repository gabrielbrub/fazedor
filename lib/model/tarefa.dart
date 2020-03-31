class Tarefa {
  int id;
  String descricao;
  String nome;
  int valor;
  bool descartavel = true;


  Tarefa(this.id, this.nome, this.descricao, this.valor, this.descartavel);

  @override
  String toString() {
    return 'Tarefa{valor: $valor, nome: $nome}';
  }
}
