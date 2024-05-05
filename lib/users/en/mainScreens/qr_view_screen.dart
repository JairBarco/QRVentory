import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:users_app/users/en/mainScreens/edit_qr_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

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
            icon: Icon(Icons.download), // Icono de descarga
            onPressed: () async {
              final tempDir = await getTemporaryDirectory();
              final file = await File('${tempDir.path}/qr_code.png').create();
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
              await file.writeAsBytes((await qrImage.toByteData())!.buffer.asUint8List());
              await Share.shareXFiles([XFile(file.path)], subject: 'QR Code');
              // Función para exportar el código QR como imagen
              //await Share.shareXFiles(
              //[XFile.fromData(await QrPainter().toImageData(Container(child: QrImage(data: qrData))))],
              //subject: 'QR Code',
              //);
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
              ).then((value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditQRScreen(initialQRData: qrData),
                    ),
                  ).then((editedQRData) {
                    if (editedQRData != null) {
                      Navigator.pop(context, editedQRData);
                    }
                  });
                } else if (value == 'delete') {
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
    );
  }
}