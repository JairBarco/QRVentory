import 'package:flutter/material.dart';

class EditQRScreen extends StatefulWidget {
  final String initialQRData;
  EditQRScreen({required this.initialQRData});

  @override
  _EditQRScreenState createState() => _EditQRScreenState();
}

class _EditQRScreenState extends State<EditQRScreen> {
  late TextEditingController _articleController;
  late TextEditingController _descriptionController;
  DateTime? _expirationDate;

  @override
  void initState() {
    super.initState();
    final qrData = widget.initialQRData.split('\n\n');
    final article = qrData[0].split(':')[1].trim();
    final description = qrData[1].split(':')[1].trim();
    final expirationDate = qrData[2].split(':')[1].trim();

    _articleController = TextEditingController(text: article);
    _descriptionController = TextEditingController(text: description);
    _expirationDate = expirationDate.isNotEmpty
        ? DateTime.parse(expirationDate)
        : null;
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
        title: Text('Editar Código QR'),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _articleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Editar artículo',
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
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Editar descripción',
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
              onPressed: () async {
                final expirationDate = await showDatePicker(
                  context: context,
                  initialDate: _expirationDate ?? DateTime.now(),
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
                final editedArticle = _articleController.text;
                final editedDescription = _descriptionController.text;
                final editedExpirationDate =
                    _expirationDate?.toString().split(' ')[0] ?? '';
                final editedQRData =
                    'Artículo:\n$editedArticle\n\nDescripción:\n$editedDescription\n\nFecha de caducidad:\n$editedExpirationDate';
                Navigator.pop(context, editedQRData);
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