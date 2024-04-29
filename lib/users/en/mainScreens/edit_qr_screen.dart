import 'package:flutter/material.dart';

class EditQRScreen extends StatefulWidget {
  final String initialQRData;

  EditQRScreen({required this.initialQRData});

  @override
  _EditQRScreenState createState() => _EditQRScreenState();
}

class _EditQRScreenState extends State<EditQRScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialQRData);
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
        title: Text('Editar Código QR'),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Editar palabra',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final editedQRData = _textController.text;
                Navigator.pop(context, editedQRData); // Devuelve los datos editados a la pantalla anterior
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
              ),
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}