import 'package:flutter/material.dart';
import '../models/produto.dart';
import 'cadastro_produto.dart';

class DetalheProdutoScreen extends StatelessWidget {
  final Produto produto;
  final Future<void> Function(Produto produtoEditado)? onEditar;
  final VoidCallback? onExcluir;

  const DetalheProdutoScreen({
    super.key,
    required this.produto,
    this.onEditar,
    this.onExcluir,
  });

  String _formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> _editarProduto(BuildContext context) async {
    final Produto? produtoEditado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroProdutoScreen(produto: produto),
      ),
    );

    if (produtoEditado != null && onEditar != null) {
      await onEditar!(produtoEditado);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
      }
    }
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Deseja realmente excluir "${produto.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onExcluir != null) {
                onExcluir!();
                Navigator.pop(context);
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        actions: [
          IconButton(
            onPressed: () => _editarProduto(context),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
          ),
          IconButton(
            onPressed: () => _confirmarExclusao(context),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    size: 84,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  produto.nome,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatarPreco(produto.preco),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Descrição',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  produto.descricao.isEmpty
                      ? 'Produto sem descrição informada.'
                      : produto.descricao,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _editarProduto(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar Produto'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
