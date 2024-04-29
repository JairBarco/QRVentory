import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:users_app/users/en/mainScreens/edit_qr_screen.dart';

class QRViewScreen extends StatelessWidget {
  final String qrData;

  QRViewScreen({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('QR Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 64, 48, 16, 0), // Posición del menú contextual en el lado derecho
                items: [
                  PopupMenuItem(
                    child: Text('Editar'),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: Text('Eliminar'),
                    value: 'delete',
                  ),
                ],
              ).then((value) {
                // Maneja las acciones de editar o eliminar
                if (value == 'edit') {
                  // Navega a la pantalla de edición del QR
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditQRScreen(initialQRData: qrData),
                    ),
                  ).then((editedQRData) {
                    if (editedQRData != null) {
                      // Actualiza el QR en la lista de artículos en MainScreen
                      Navigator.pop(context, editedQRData); // Devuelve los datos editados a MainScreen
                    }
                  });
                } else if (value == 'delete') {
                  // Elimina el QR de la lista de artículos
                  // Eliminar el artículo y volver a MainScreen
                  Navigator.pop(context, 'delete'); // Devuelve 'delete' como resultado
                  //Navigator.pop(context); // Cierra la pantalla QRViewScreen
                }
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              qrData,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 300.0,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}