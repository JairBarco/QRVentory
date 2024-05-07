import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:users_app/users/en/mainScreens/edit_qr_screen.dart';
import 'package:users_app/users/en/mainScreens/main_screen.dart';

class QRViewScreen extends StatelessWidget {
  final String qrData;
  final String productId;
  QRViewScreen({required this.qrData, required this.productId});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainScreen()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('QR Code'),
          actions: [
            IconButton(
              icon: Icon(Icons.download), // Icono de descarga
              onPressed: () async {
                final qrImage = await QrPainter(
                  data: qrData,
                  version: QrVersions.auto,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.white,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.white,
                  ),
                ).toImage(300);
                final qrImageData =
                    await qrImage.toByteData(format: ImageByteFormat.png);
                if (qrImageData != null) {
                  final result = await ImageGallerySaver.saveImage(
                      qrImageData.buffer.asUint8List());
                  if (result['isSuccess']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('QR Code saved to gallery')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save QR Code')));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to generate QR Code image data')));
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    MediaQuery.of(context).size.width - 64,
                    48,
                    16,
                    0,
                  ),
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
                ).then((value) async {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditQRScreen(
                          initialQRData: qrData,
                          productId: productId,
                        ),
                      ),
                    ).then((editedQRData) {
                      if (editedQRData != null) {
                        Navigator.pop(context, editedQRData);
                      }
                    });
                  } else if (value == 'delete') {
                    await FirebaseDatabase.instance
                        .ref()
                        .child("products")
                        .child(productId)
                        .remove();
                    Navigator.pop(context, 'delete');
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
      ),
    );
  }
}
