class Produto {
  String nome;
  double preco;
  String descricao;

  Produto({
    required this.nome,
    required this.preco,
    this.descricao = '',
  });
}
