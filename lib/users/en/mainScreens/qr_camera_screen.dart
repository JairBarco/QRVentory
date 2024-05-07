import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:users_app/users/en/mainScreens/qr_view_screen.dart';

class QRCameraScreen extends StatefulWidget {
  @override
  _QRCameraScreenState createState() => _QRCameraScreenState();
}

class _QRCameraScreenState extends State<QRCameraScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrCodeResult = "Not Yet Scanned";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Escanear Código QR'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData.code!;
      });
      if (qrCodeResult != null) {
        controller.pauseCamera();
        DatabaseReference productsRef =
            FirebaseDatabase.instance.ref().child('products');
        productsRef.once().then((DatabaseEvent event) {
          if (event.snapshot.value is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> products =
                event.snapshot.value as Map<dynamic, dynamic>;
            String? productId;
            for (var id in products.keys) {
              if (products[id]['qrData'] == qrCodeResult) {
                productId = id;
                break;
              }
            }
            if (productId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QRViewScreen(qrData: qrCodeResult, productId: productId!),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Producto no encontrado')));
              controller.resumeCamera();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al obtener los productos')));
            controller.resumeCamera();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
