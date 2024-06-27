import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Productos(),
    );
  }
}

class Productos extends StatefulWidget {
  const Productos({Key? key}) : super(key: key);

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  late Future<List<dynamic>> _futureProductos;
  late Future<List<dynamic>> _futureCategorias;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _existenciasController = TextEditingController();
  TextEditingController _maxExistenciasController = TextEditingController();
  TextEditingController _minExistenciasController = TextEditingController();
  int? _selectedCategoriaId;
  int? _editingProductId;

  @override
  void initState() {
    super.initState();
    _futureProductos = _fetchProductos();
    _futureCategorias = _fetchCategorias();
  }

  Future<List<dynamic>> _fetchProductos() async {
    final response = await http.get(
        Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/products'));

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, analiza el JSON
      List<dynamic> productos = jsonDecode(response.body);
      return productos;
    } else {
      // Si la solicitud falla, muestra un mensaje de error
      throw Exception('Failed to load productos');
    }
  }

  Future<List<dynamic>> _fetchCategorias() async {
    final response = await http.get(
      Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/categories'),
    );

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, analiza el JSON
      List<dynamic> categorias = jsonDecode(response.body);
      return categorias;
    } else {
      // Si la solicitud falla, muestra un mensaje de error
      throw Exception('Failed to load categorias');
    }
  }

  Future<void> _agregarProducto(String nombre, int existencias,
      int maxExistencias, int minExistencias) async {
    final response = await http.post(
      Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'img': '',
        'categoryProductId':
            _selectedCategoriaId, // Usamos la categoría seleccionada
        'existencias': existencias,
        'maxExistencia': maxExistencias,
        'minExistencias': minExistencias,
        'estado': false,
        'categoryProduct': null,
      }),
    );

    if (response.statusCode == 201) {
      // Si el producto se creó exitosamente, actualiza la lista de productos
      setState(() {
        _futureProductos = _fetchProductos();
      });
    } else {
      // Si la creación falla, muestra un mensaje de error
      throw Exception('Failed to create product');
    }
  }

  Future<void> _editarProducto(int id, String nombre, int existencias,
      int maxExistencias, int minExistencias) async {
    final response = await http.put(
      Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/products/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'nombre': nombre,
        'img':
            '', // Aquí podrías agregar la lógica para la imagen si es necesario
        'categoryProductId': _selectedCategoriaId,
        'existencias': existencias,
        'maxExistencia': maxExistencias,
        'minExistencias': minExistencias,
        'estado': false,
        'categoryProduct': null,
      }),
    );

    if (response.statusCode == 200) {
      // Si la actualización fue exitosa, actualiza la lista de productos
      setState(() {
        _futureProductos = _fetchProductos();
      });
    } else {
      // Si la actualización falla, muestra un mensaje de error
      throw Exception('Failed to update product');
    }
  }

  void _verDetalleProducto(dynamic producto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleProducto(producto: producto),
      ),
    );
  }

  Future<void> _eliminarProducto(int id) async {
    final response = await http.delete(
      Uri.parse('http://jhojansanchez-001-site1.etempurl.com/api/products/$id'),
    );

    if (response.statusCode == 200) {
      // Si la eliminación fue exitosa, actualiza la lista de productos
      setState(() {
        _futureProductos = _fetchProductos();
      });
    } else {
      // Si la eliminación falla, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('Se elimino')),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(child: Text('OK')),
              ),
            ],
          );
        },
      ).then((_) {
        // Después de cerrar la alerta, actualiza la lista de productos
        setState(() {
          _futureProductos = _fetchProductos();
        });
      });
    }
  }

  void _editarProductoDialog(dynamic producto) {
    // Llenar los controladores con los datos actuales del producto
    _nombreController.text = producto['nombre'];
    _existenciasController.text = producto['existencias'].toString();
    _maxExistenciasController.text = producto['maxExistencia'].toString();
    _minExistenciasController.text = producto['minExistencias'].toString();
    _selectedCategoriaId = producto['categoryProductId'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: FutureBuilder<List<dynamic>>(
            future: _futureCategorias,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> categorias = snapshot.data!;
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _nombreController,
                        decoration: InputDecoration(labelText: 'Nombre'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el nombre del producto';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _existenciasController,
                        decoration: InputDecoration(labelText: 'Existencias'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa las existencias';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _maxExistenciasController,
                        decoration:
                            InputDecoration(labelText: 'Máximo Existencias'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el máximo de existencias';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _minExistenciasController,
                        decoration:
                            InputDecoration(labelText: 'Mínimo Existencias'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el mínimo de existencias';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<int>(
                        value: _selectedCategoriaId,
                        hint: Text('Selecciona una categoría'),
                        onChanged: (int? value) {
                          setState(() {
                            _selectedCategoriaId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Por favor selecciona una categoría';
                          }
                          return null;
                        },
                        items: categorias
                            .map<DropdownMenuItem<int>>((dynamic categoria) {
                          return DropdownMenuItem<int>(
                            value: categoria['id'],
                            child: Text(categoria['nombre']),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar las categorías');
              }
              // Por defecto, muestra un indicador de carga
              return CircularProgressIndicator();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String nombre = _nombreController.text.trim();
                  int existencias =
                      int.parse(_existenciasController.text.trim());
                  int maxExistencias =
                      int.parse(_maxExistenciasController.text.trim());
                  int minExistencias =
                      int.parse(_minExistenciasController.text.trim());

                  _editarProducto(producto['id'], nombre, existencias,
                          maxExistencias, minExistencias)
                      .then((_) {
                    Navigator.of(context)
                        .pop(); // Cierra el diálogo de editar producto

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Producto actualizado correctamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }).catchError((error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text('Se edito')),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo de error
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Productos(), // Navega a la pantalla de productos
                                  ),
                                );
                              },
                              child: Center(child: Text('OK')),
                            ),
                          ],
                        );
                      },
                    );
                  });
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
          future: _futureProductos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> productos = snapshot.data!;
              return ListView(
                children: productos.map((producto) {
                  return ListTile(
                    title: Text(producto['nombre']),
                    subtitle: Text('Existencias: ${producto['existencias']}'),
                    onTap: () {
                      _verDetalleProducto(producto);
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editarProductoDialog(producto);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirmar eliminación'),
                                  content: Text(
                                      '¿Estás seguro de eliminar este producto?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _eliminarProducto(producto['id']);
                                      },
                                      child: Text('Eliminar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('Error al cargar los productos');
            }
            // Por defecto, muestra un indicador de carga
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Agregar Producto'),
                content: FutureBuilder<List<dynamic>>(
                  future: _futureCategorias,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> categorias = snapshot.data!;
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _nombreController,
                              decoration: InputDecoration(labelText: 'Nombre'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el nombre del producto';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _existenciasController,
                              decoration:
                                  InputDecoration(labelText: 'Existencias'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa las existencias';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _maxExistenciasController,
                              decoration: InputDecoration(
                                  labelText: 'Máximo Existencias'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el máximo de existencias';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _minExistenciasController,
                              decoration: InputDecoration(
                                  labelText: 'Mínimo Existencias'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el mínimo de existencias';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField<int>(
                              value: _selectedCategoriaId,
                              hint: Text('Selecciona una categoría'),
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedCategoriaId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor selecciona una categoría';
                                }
                                return null;
                              },
                              items: categorias.map<DropdownMenuItem<int>>(
                                  (dynamic categoria) {
                                return DropdownMenuItem<int>(
                                  value: categoria['id'],
                                  child: Text(categoria['nombre']),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error al cargar las categorías');
                    }
                    // Por defecto, muestra un indicador de carga
                    return CircularProgressIndicator();
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String nombre = _nombreController.text.trim();
                        int existencias =
                            int.parse(_existenciasController.text.trim());
                        int maxExistencias =
                            int.parse(_maxExistenciasController.text.trim());
                        int minExistencias =
                            int.parse(_minExistenciasController.text.trim());

                        _agregarProducto(nombre, existencias, maxExistencias,
                                minExistencias)
                            .then((_) {
                          Navigator.of(context)
                              .pop(); // Cierra el diálogo de agregar producto
                          _nombreController.clear();
                          _existenciasController.clear();
                          _maxExistenciasController.clear();
                          _minExistenciasController.clear();
                          _selectedCategoriaId = null;

                          // Mostrar mensaje de éxito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Producto agregado correctamente'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }).catchError((error) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('No se pudo agregar el producto.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      }
                    },
                    child: Text('Agregar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DetalleProducto extends StatelessWidget {
  final dynamic producto;

  const DetalleProducto({Key? key, required this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto['nombre']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Existencias: ${producto['existencias']}'),
            SizedBox(height: 8),
            Text('Máximo Existencias: ${producto['maxExistencia']}'),
            SizedBox(height: 8),
            Text('Mínimo Existencias: ${producto['minExistencias']}'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
