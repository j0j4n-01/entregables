import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:proyectflu/screens/EditCategoryScreen.dart';

class Categorias extends StatefulWidget {
  const Categorias({Key? key}) : super(key: key);

  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/categories'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void navigateToCategoryDetails(dynamic category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetails(category: category),
      ),
    ).then((value) {
      if (value != null && value) {
        fetchCategories(); // Actualizar la lista después de editar la categoría
      }
    });
  }

  void navigateToAddCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(),
      ),
    ).then((value) {
      if (value != null && value) {
        fetchCategories(); // Actualizar la lista después de agregar una categoría
      }
    });
  }

  Future<void> deleteCategory(int categoryId) async {
  final url = Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/categories/$categoryId');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    setState(() {
      categories.removeWhere((category) => category['id'] == categoryId);
    });
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text('Se elimino')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              fetchCategories(); // Recargar categorías al hacer clic en OK
            },
            child: Center(child: Text('OK')),
          ),
        ],
      ),
    );
  }
}


  Future<void> confirmAndDeleteCategory(int categoryId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar esta categoría?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteCategory(categoryId);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddCategory,
          ),
        ],
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () => navigateToCategoryDetails(categories[index]),
                    title: Text(categories[index]['nombre']),
                    subtitle: Text(categories[index]['descripcion']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => confirmAndDeleteCategory(categories[index]['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  bool _estado = true; // Estado por defecto

  Future<void> addCategory() async {
    final url = Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/categories');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'nombre': _nombreController.text,
        'descripcion': _descripcionController.text,
        'estado': _estado,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true); // Indicar que se agregó correctamente
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('No se pudo agregar la categoría. Inténtalo de nuevo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
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
        title: Text('Agregar Categoría'),
      ),
      body: Padding(
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
              onPressed: addCategory,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryDetails extends StatelessWidget {
  final dynamic category;

  const CategoryDetails({Key? key, required this.category}) : super(key: key);

  void navigateToEditCategory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(category: category),
      ),
    ).then((value) {
      if (value != null && value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Categoría actualizada correctamente'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category['nombre']),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => navigateToEditCategory(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descripción:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              category['descripcion'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Estado:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              category['estado'] ? 'Activo' : 'Inactivo',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Categorias(),
  ));
}
