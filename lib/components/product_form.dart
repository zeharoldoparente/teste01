import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  const ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _quantity = 0;
  double _value = 0.0;
  double _stockValue = 0.0;
  String _id = '';
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name = widget.product!['name'];
      _quantity = widget.product!['quantity'];
      _value = widget.product!['value'];
      _stockValue = widget.product!['stockValue'];
      _id = widget.product!['id'];
      _date = widget.product!['date'];
    }
  }

  void _updateStockValue() {
    setState(() {
      _stockValue = _quantity * _value;
    });
  }

  String _convertToDecimal(String value) {
    return value.replaceAll(',', '.');
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.product == null ? 'Cadastrar Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nome do Produto'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do produto';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _quantity = int.tryParse(value) ?? 0;
                  _updateStockValue();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _value.toString().replaceAll('.', ','),
                decoration: const InputDecoration(labelText: 'Valor Unitário'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  _value = double.tryParse(_convertToDecimal(value)) ?? 0.0;
                  _updateStockValue();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor unitário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Valor do Estoque: R\$${_stockValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'ID: $_id',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Data: ${_formatDate(_date)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.product == null) {
                      _id = DateTime.now().millisecondsSinceEpoch.toString();
                      _date = DateTime.now();
                    } else {
                      _date = DateTime.now();
                    }
                    Navigator.pop(context, {
                      'id': _id,
                      'name': _name,
                      'quantity': _quantity,
                      'value': _value,
                      'stockValue': _stockValue,
                      'date': _date,
                    });
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
