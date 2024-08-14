import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product;

  ProductFormScreen({this.product});

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

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
      _nameController.text = _name;
      _quantityController.text = _quantity.toString();
      _valueController.text = _value.toString().replaceAll('.', ',');
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

  Future<void> _showSuccessDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // O usuário precisa clicar em OK para fechar
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _nameController.clear();
    _quantityController.clear();
    _valueController.clear();
    setState(() {
      _name = '';
      _quantity = 0;
      _value = 0.0;
      _stockValue = 0.0;
      _id = '';
      _date = DateTime.now();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _valueController.dispose();
    super.dispose();
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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
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
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  _quantity = int.tryParse(value) ?? 0;
                  _updateStockValue();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(labelText: 'Valor Unitário'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+[,\.]?\d{0,2}')),
                ],
                onChanged: (value) {
                  _value = double.tryParse(_convertToDecimal(value)) ?? 0.0;
                  _updateStockValue();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor unitário';
                  }
                  if (double.tryParse(_convertToDecimal(value)) == null) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Valor do Estoque: R\$${_stockValue.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'ID: $_id',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Data: ${_formatDate(_date)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.product == null) {
                      _id = DateTime.now().millisecondsSinceEpoch.toString();
                      _date = DateTime.now();
                      _showSuccessDialog('Produto criado com sucesso!')
                          .then((_) {
                        Navigator.pop(context, {
                          'id': _id,
                          'name': _name,
                          'quantity': _quantity,
                          'value': _value,
                          'stockValue': _stockValue,
                          'date': _date,
                        });
                        _resetForm(); // Reseta o formulário após salvar
                      });
                    } else {
                      _date = DateTime.now();
                      _showSuccessDialog('Produto editado com sucesso!')
                          .then((_) {
                        Navigator.pop(context, {
                          'id': _id,
                          'name': _name,
                          'quantity': _quantity,
                          'value': _value,
                          'stockValue': _stockValue,
                          'date': _date,
                        });
                      });
                    }
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
