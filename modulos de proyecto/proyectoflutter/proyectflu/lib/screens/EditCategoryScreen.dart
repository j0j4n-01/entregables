import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyectflu/screens/Categorias.dart';

class EditCategoryScreen extends StatefulWidget {
  final dynamic category;

  const EditCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  bool _estado = true; // Estado por defecto
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.category['nombre']);
    _descripcionController = TextEditingController(text: widget.category['descripcion']);
    _estado = widget.category['estado'];
  }

  Future<void> updateCategory() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    final url = Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/categories/${widget.category['id']}');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'id': widget.category['id'], // Incluir el ID en el cuerpo de la solicitud
        'nombre': _nombreController.text,
        'descripcion': _descripcionController.text,
        'estado': _estado,
      }),
    );

    setState(() {
      _isLoading = false; // Ocultar indicador de carga
    });

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Indicar que se actualizó correctamente
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text('Se actualizo')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo de error
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Categorias()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Center(child: Text('OK')),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoría'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Estado:'),
                      Switch(
                        value: _estado,
                        onChanged: (value) {
                          setState(() {
                            _estado = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: updateCategory,
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
    home: Categorias(),
  ));
}
