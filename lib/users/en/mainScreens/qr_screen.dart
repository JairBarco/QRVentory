import 'package:flutter/material.dart';

class QRScreen extends StatefulWidget {
  final String? qrData;

  QRScreen({this.qrData});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final TextEditingController _textController = TextEditingController();
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _qrData = widget.qrData ?? '';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('QR Code Screen'),
      ),
      body: Container(
        color: Colors.black, // Fondo negro
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ingresa una palabra',
                  hintText: 'Ingresa una palabra',
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
                onPressed: () {
                  setState(() {
                    _qrData = _textController.text;
                  });
                  Navigator.pop(context, _qrData);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo, // Color indigo para el ElevatedButton
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