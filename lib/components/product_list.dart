import 'package:flutter/material.dart';
import 'product_form.dart';
import 'product_tile.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];

  void _addOrUpdateProduct(Map<String, dynamic> product, {int? index}) {
    setState(() {
      if (index != null) {
        products[index] = product;
      } else {
        products.add(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductTile(
            product: product,
            onEdit: (updatedProduct) {
              _addOrUpdateProduct(updatedProduct, index: index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormScreen()),
          );
          if (newProduct != null) {
            _addOrUpdateProduct(newProduct);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
