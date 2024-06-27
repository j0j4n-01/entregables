// ignore: file_names
import 'package:flutter/material.dart';
import 'package:proyectflu/screens/categorias.dart';
import 'package:proyectflu/screens/geolocalizacion.dart';
import 'package:proyectflu/screens/productos.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Modulos', style: TextStyle(color: Colors.black)),
          backgroundColor: const Color.fromRGBO(171, 71, 188, 1)),
      drawer: Drawer(
        width: 200,
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(171, 71, 188, 1)),
              child: const Text('Options',
                  style: TextStyle(color: Colors.black, fontSize: 23.5)),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Categorias'),
              hoverColor: Colors.purple[100],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Categorias(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_rounded),
              title: const Text('Productos'),
              hoverColor: Colors.purple[100],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Productos(),
                    ));
              },
            ),ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Geolocalizacion'),
              hoverColor: Colors.purple[100],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Option2Screen(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('mis modulos')),
    );
  }
}
