import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PeajeForm extends StatefulWidget {
  @override
  _PeajeFormState createState() => _PeajeFormState();
}

class _PeajeFormState extends State<PeajeForm> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _fechaController = TextEditingController();
  final _valorController = TextEditingController();
  final _dolarController = TextEditingController();
  final _observacionController = TextEditingController();

  String? _selectedPeaje;
  String? _selectedCategoria;

  final List<String> _categorias = ['I', 'II', 'III', 'IV', 'V'];
  List<String> _peajes = [];
  double _exchangeRate = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchPeajes();
    _fetchExchangeRate();
  }

  Future<void> _fetchPeajes() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.datos.gov.co/resource/7gj8-j6i3.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final peajesSet = data.map((peaje) => peaje['peaje'] as String).toSet();
        setState(() {
          _peajes = peajesSet.toList();
        });
      } else {
        throw Exception('Failed to load peajes');
      }
    } catch (e) {
      print('Error fetching peajes: $e');
    }
  }

  Future<void> _fetchValorPeaje(String nombrePeaje, String categoria) async {
    try {
      final response = await http
          .get(Uri.parse('https://www.datos.gov.co/resource/7gj8-j6i3.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final peaje = data.firstWhere(
          (p) =>
              p['peaje'] == nombrePeaje && p['idcategoriatarifa'] == categoria,
          orElse: () => null,
        );
        if (peaje != null && peaje['valor'] != null) {
          setState(() {
            _valorController.text = peaje['valor'];
            _updateDolarValue();
          });
        } else {
          setState(() {
            _valorController.text = '0';
            _dolarController.text = '0.0';
          });
        }
      } else {
        throw Exception('Failed to load valor peaje');
      }
    } catch (e) {
      print('Error fetching valor peaje: $e');
      setState(() {
        _valorController.text = '0';
        _dolarController.text = '0.0';
      });
    }
  }

  Future<void> _fetchExchangeRate() async {
    try {
      final response = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _exchangeRate = data['rates']['COP'];
        });
        _updateDolarValue();
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
    }
  }

  void _updateDolarValue() {
    if (_valorController.text.isNotEmpty && _exchangeRate > 0) {
      final int valorPeaje = int.parse(_valorController.text);
      final double valorEnDolares = valorPeaje / _exchangeRate;
      setState(() {
        _dolarController.text = valorEnDolares.toStringAsFixed(2);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedPeaje != null &&
        _selectedCategoria != null) {
      final String placa = _placaController.text;
      final String fecha = _fechaController.text;
      final int valor = int.tryParse(_valorController.text) ?? 0;
      final String observacion = _observacionController.text;

      // Formatear la fecha al formato deseado (yyyy-MM-dd)
      DateTime parsedDate = DateTime.parse(fecha);
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      final requestData = {
        'placa': placa,
        'nombrePeaje': _selectedPeaje!,
        'categoriaTarifaId': _selectedCategoria!,
        'fechaRegistro': formattedDate,
        'observacion': observacion,
        'valor': valor.toString(), // Convertir el valor a String
      };

      print('Sending data: $requestData');

      try {
        final response = await http.post(
          Uri.parse('http://localhost:5013/api/peaje'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(requestData),
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Registro exitoso')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Fallo al registrar')));
        }
      } catch (e) {
        print('Error en la solicitud HTTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error en la solicitud HTTP')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selecciona un peaje y una categoría')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Peaje'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (!RegExp(r'^[A-Z]{3}[0-9]{3}$').hasMatch(value)) {
                    return 'La placa debe ser de la forma ABC123';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Nombre Peaje'),
                items: _peajes.map<DropdownMenuItem<String>>((peaje) {
                  return DropdownMenuItem<String>(
                    value: peaje,
                    child: Text(peaje),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPeaje = newValue;
                    if (_selectedPeaje != null && _selectedCategoria != null) {
                      _fetchValorPeaje(_selectedPeaje!, _selectedCategoria!);
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Este campo es obligatorio' : null,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Categoría Tarifa'),
                items: _categorias.map<DropdownMenuItem<String>>((categoria) {
                  return DropdownMenuItem<String>(
                    value: categoria,
                    child: Text(categoria),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategoria = newValue;
                    if (_selectedPeaje != null && _selectedCategoria != null) {
                      _fetchValorPeaje(_selectedPeaje!, _selectedCategoria!);
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _fechaController,
                decoration:
                    const InputDecoration(labelText: 'Fecha (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    return 'La fecha debe estar en el formato yyyy-MM-dd';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'El valor debe ser mayor o igual a 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dolarController,
                decoration: const InputDecoration(labelText: 'Dólar'),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
