import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Importar para trabajar con File

class Option2Screen extends StatefulWidget {
  @override
  _Option2ScreenState createState() => _Option2ScreenState();
}

class _Option2ScreenState extends State<Option2Screen> {
  String _locationMessage = '';
  File? _image;  // Variable para almacenar la imagen tomada

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Comprobar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // El servicio de ubicación no está habilitado, no podemos proceder.
      setState(() {
        _locationMessage = 'El servicio de ubicación está deshabilitado.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = 'Los permisos de ubicación fueron denegados';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = 'Los permisos de ubicación están permanentemente denegados.';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = 'Latitud: ${position.latitude}, Longitud: ${position.longitude}';
    });
  }

  Future<void> _takePicture() async {
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
        title: Text('Geolocalización'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Tomar Foto'),
            ),
            SizedBox(height: 20),
            Text(
              'Mensaje de ubicación:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _locationMessage,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            _image == null
                ? Text('No se ha tomado ninguna foto.')
                : Image.file(_image!),
          ],
        ),
      ),
    );
  }
}
