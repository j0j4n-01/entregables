import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:examenfluuter/Vistas/Peajes.dart';
import 'package:examenfluuter/Vistas/Geolocalizacion.dart';

void main() {
  runApp(VehicleMenuApp());
}

class VehicleMenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Opciones',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[200],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menú',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(28, 158, 158, 158),
              ),
            ),
            ListTile(
              leading: Icon(Icons.car_crash),
              title: Text('peajes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Peajes()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('ubicacion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Option2Screen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('camara'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              },
            ),
            // Agrega más ListTile según sea necesario para más opciones
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'HOLAAAAAA',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class Option1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocalizador'),
      ),
      body: Center(
        child: Text(
          'Estas compratiendo tu ubicacion',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Geolocalizacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocalizacion'),
      ),
      body: Center(
        child: Text(
          'Estas compartiendo tu ubicacion',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cámara'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No se ha seleccionado ninguna imagen')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Tomar Foto'),
            ),
          ],
        ),
      ),
    );
  }
}
