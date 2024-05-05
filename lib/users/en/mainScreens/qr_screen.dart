import 'package:flutter/material.dart';

class QRScreen extends StatefulWidget {
  final String? qrData;
  QRScreen({this.qrData});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final TextEditingController _articleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _expirationDate;
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _qrData = widget.qrData ?? '';
  }

  @override
  void dispose() {
    _articleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Agrega artículo'),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _articleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ingresa el artículo',
                  hintText: 'Ej. Leche deslactosada',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ingresa la descripción',
                  hintText: 'Ej. Leche baja en lactosa',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final expirationDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (expirationDate != null) {
                    setState(() {
                      _expirationDate = expirationDate;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Text(
                  _expirationDate != null
                      ? 'Fecha de caducidad: ${_expirationDate.toString().split(' ')[0]}'
                      : 'Seleccionar fecha de caducidad',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final article = _articleController.text;
                  final description = _descriptionController.text;
                  final expirationDate =
                      _expirationDate?.toString().split(' ')[0] ?? '';
                  final qrData =
                      'Artículo:\n$article\n\nDescripción:\n$description\n\nFecha de caducidad:\n$expirationDate';
                  setState(() {
                    _qrData = qrData;
                  });
                  Navigator.pop(context, _qrData);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo,
                ),
                child: Text('Generar Código QR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}