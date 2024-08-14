import 'package:flutter/material.dart';
import 'package:flutter_front_teste01/components/product_form.dart';
import 'package:intl/intl.dart';

class ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onEdit;

  const ProductTile({super.key, required this.product, required this.onEdit});

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product['name']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${product['id']}'),
          Text('Data: ${_formatDate(product['date'])}'),
          Text(
              'Quantidade: ${product['quantity']} - Valor do Estoque: R\$${product['stockValue'].toStringAsFixed(2)}'),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () async {
          final updatedProduct = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductFormScreen(
                product: product,
              ),
            ),
          );
          if (updatedProduct != null) {
            onEdit(updatedProduct);
          }
        },
      ),
    );
  }
}
