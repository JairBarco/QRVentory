import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:users_app/users/en/mainScreens/qr_camera_screen.dart'; // Importa la nueva pantalla QRCameraScreen
import 'package:users_app/users/en/mainScreens/qr_screen.dart';
import 'package:users_app/users/en/mainScreens/qr_view_screen.dart';
import '../global/global.dart';
import '../widgets/my_drawer.dart';

void printUserInfo() {
  print('Información del usuario actual:');
  if (userModelCurrentInfo != null) {
    print('Nombre: ${userModelCurrentInfo!.name}');
    print('Correo electrónico: ${userModelCurrentInfo!.email}');
  } else {
    print('El usuario actual no está disponible.');
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> itemList = [];
  List<String> productIdList = [];
  final DatabaseReference productsRef = FirebaseDatabase.instance.ref().child("products");

  @override
  void initState() {
    super.initState();
    productsRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        var data = snapshot.value as Map<dynamic, dynamic>;
        var items = data.values.toList();
        var keys = data.keys.toList(); // Obtiene las keys de los productos
        setState(() {
          itemList = items.map((item) => item['qrData'] as String).toList();
          productIdList = keys.map((key) => key as String).toList(); // Almacena las keys en productIdList
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    printUserInfo();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Main Screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () async {
              final qrData = await Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => QRCameraScreen()),
              );
              if (qrData != null) {
                final index = itemList.indexWhere((item) => item.contains(qrData));
                if (index != -1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRViewScreen(qrData: itemList[index], productId: productIdList[index],),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Artículo no encontrado'),
                      content: Text('El artículo escaneado no se encuentra en la lista.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newArticle = await Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => QRScreen()),
              );
              if (newArticle != null) {
                setState(() {
                  itemList.add(newArticle);
                });
              }
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        name: userModelCurrentInfo != null ? userModelCurrentInfo!.name : "Nombre",
        email: userModelCurrentInfo != null ? userModelCurrentInfo!.email : "Correo electrónico",
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lista de Artículos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: itemList.isEmpty
                    ? Center(
                  child: Text(
                    'No hay artículos',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    final article = itemList[index].split('\n\n')[0].split(':')[1].trim();
                    final expirationDateStr = itemList[index].split('\n\n')[2].split(':')[1].trim();
                    final expirationDate = DateTime.parse(expirationDateStr);
                    final daysUntilExpiration = expirationDate.difference(DateTime.now()).inDays;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRViewScreen(qrData: itemList[index], productId: productIdList[index]),
                          ),
                        ).then((value) {
                          if (value == 'delete') {
                            setState(() {
                              itemList.removeAt(index);
                            });
                          } else if (value != null) {
                            setState(() {
                              itemList[index] = value;
                            });
                          }
                        });
                      },
                      child: Container(
                        child: ListTile(
                          title: Text(
                            article,
                            style: TextStyle(
                              color: daysUntilExpiration <= 3 ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}