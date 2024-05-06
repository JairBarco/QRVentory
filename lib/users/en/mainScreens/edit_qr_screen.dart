import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditQRScreen extends StatefulWidget {
  final String initialQRData;
  final String productId;
  EditQRScreen({required this.initialQRData, required this.productId});

  @override
  _EditQRScreenState createState() => _EditQRScreenState();
}

class _EditQRScreenState extends State<EditQRScreen> {
  final TextEditingController _articleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _expirationDate;
  final DatabaseReference productRef = FirebaseDatabase.instance.ref().child("products");

  @override
  void initState() {
    super.initState();
    _initializeProductData();
  }

  void _initializeProductData() {
    productRef.child(widget.productId).onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        var data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _articleController.text = data['article'];
          _descriptionController.text = data['description'];
          _expirationDate = DateTime.parse(data['expirationDate']);
        });
      }
    });
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

                final productMap = {
                  "article": editedArticle,
                  "description": editedDescription,
                  "expirationDate": editedExpirationDate,
                  "qrData": editedQRData,
                };

                productRef.child(widget.productId).update(productMap);

                Navigator.pop(context, editedQRData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}