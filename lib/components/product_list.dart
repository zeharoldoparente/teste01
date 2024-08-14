import 'package:flutter/material.dart';
import 'product_form.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  String searchOption = 'ID'; // Padrão de busca por ID
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  void _filterProducts() {
    setState(() {
      if (searchQuery.isEmpty) {
        _filteredProducts = List.from(_products);
      } else if (searchOption == 'ID') {
        _filteredProducts = _products
            .where((product) => product['id'].contains(searchQuery))
            .toList();
      } else if (searchOption == 'Nome') {
        _filteredProducts = _products
            .where((product) => product['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _resetSearch() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
      _filteredProducts = List.from(_products);
    });
  }

  void _addOrEditProduct({Map<String, dynamic>? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );

    if (result != null) {
      setState(() {
        if (product == null) {
          _products.add(result);
        } else {
          int index = _products.indexWhere((p) => p['id'] == result['id']);
          if (index != -1) {
            _products[index] = result;
          }
        }
        _filteredProducts = List.from(_products);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_products); // Inicializar a lista filtrada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Produtos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: searchOption,
                  onChanged: (String? newValue) {
                    setState(() {
                      searchOption = newValue!;
                    });
                  },
                  items: <String>['ID', 'Nome']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      searchQuery = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar por $searchOption',
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          _filterProducts();
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _resetSearch,
                  tooltip: 'Resetar busca',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text(
                      'ID: ${product['id']} | Quantidade: ${product['quantity']} | Valor: R\$${product['value']} | Estoque: R\$${product['stockValue']}'),
                  onTap: () => _addOrEditProduct(product: product),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditProduct(),
        child: Icon(Icons.add),
      ),
    );
  }
}
