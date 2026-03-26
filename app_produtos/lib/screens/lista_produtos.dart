import 'package:flutter/material.dart';
import '../models/produto.dart';
import 'cadastro_produto.dart';
import 'detalhe_produto.dart';

class ListaProdutosScreen extends StatefulWidget {
  const ListaProdutosScreen({super.key});

  @override
  State<ListaProdutosScreen> createState() => _ListaProdutosScreenState();
}

class _ListaProdutosScreenState extends State<ListaProdutosScreen> {
  final List<Produto> produtos = [
    Produto(
      nome: 'Notebook',
      preco: 3500.00,
      descricao: 'Notebook ideal para estudos e trabalho.',
    ),
    Produto(
      nome: 'Mouse Gamer',
      preco: 120.00,
      descricao: 'Mouse com alta precisão e design ergonômico.',
    ),
    Produto(
      nome: 'Teclado Mecânico',
      preco: 250.00,
      descricao: 'Teclado confortável para digitação e jogos.',
    ),
  ];

  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> _abrirCadastro() async {
    final Produto? novoProduto = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroProdutoScreen(),
      ),
    );

    if (novoProduto != null) {
      setState(() {
        produtos.add(novoProduto);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${novoProduto.nome} cadastrado com sucesso!')),
        );
      }
    }
  }

  Future<void> _abrirDetalhes(Produto produto) async {
    final int indice = produtos.indexOf(produto);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalheProdutoScreen(
          produto: produto,
          onEditar: (produtoEditado) async {
            setState(() {
              produtos[indice] = produtoEditado;
            });
          },
          onExcluir: () {
            setState(() {
              produtos.removeAt(indice);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produto excluído com sucesso!')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade700],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meus Produtos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Total cadastrados: ${produtos.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: produtos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum produto cadastrado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final produto = produtos[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.indigo.shade100,
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.indigo,
                            ),
                          ),
                          title: Text(
                            produto.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_formatarPreco(produto.preco)),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'detalhes') {
                                await _abrirDetalhes(produto);
                              } else if (value == 'editar') {
                                final Produto? produtoEditado = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CadastroProdutoScreen(produto: produto),
                                  ),
                                );

                                if (produtoEditado != null) {
                                  setState(() {
                                    produtos[index] = produtoEditado;
                                  });

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Produto atualizado com sucesso!'),
                                      ),
                                    );
                                  }
                                }
                              } else if (value == 'excluir') {
                                final bool? confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Excluir produto'),
                                    content: Text(
                                      'Deseja realmente excluir "${produto.nome}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmar == true) {
                                  setState(() {
                                    produtos.removeAt(index);
                                  });

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Produto excluído com sucesso!'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'detalhes',
                                child: Text('Ver detalhes'),
                              ),
                              PopupMenuItem(
                                value: 'editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'excluir',
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                          onTap: () => _abrirDetalhes(produto),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
