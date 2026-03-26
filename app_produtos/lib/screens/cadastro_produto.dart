import 'package:flutter/material.dart';
import '../models/produto.dart';

class CadastroProdutoScreen extends StatefulWidget {
  final Produto? produto;

  const CadastroProdutoScreen({super.key, this.produto});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  bool get editando => widget.produto != null;

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      nomeController.text = widget.produto!.nome;
      precoController.text = widget.produto!.preco.toStringAsFixed(2).replaceAll('.', ',');
      descricaoController.text = widget.produto!.descricao;
    }
  }

  void _salvarProduto() {
    if (!_formKey.currentState!.validate()) return;

    final String nome = nomeController.text.trim();
    final double preco = double.parse(precoController.text.trim().replaceAll(',', '.'));
    final String descricao = descricaoController.text.trim();

    final produto = Produto(
      nome: nome,
      preco: preco,
      descricao: descricao,
    );

    Navigator.pop(context, produto);
  }

  @override
  void dispose() {
    nomeController.dispose();
    precoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Produto' : 'Cadastrar Produto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Produto',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o nome do produto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: precoController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Preço do Produto',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o preço do produto';
                      }

                      final preco = double.tryParse(value.trim().replaceAll(',', '.'));
                      if (preco == null) {
                        return 'Digite um preço válido';
                      }
                      if (preco < 0) {
                        return 'O preço não pode ser negativo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descricaoController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _salvarProduto,
                      icon: const Icon(Icons.save),
                      label: Text(editando ? 'Salvar Alterações' : 'Salvar Produto'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
