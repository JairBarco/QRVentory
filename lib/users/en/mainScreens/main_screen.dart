import 'package:flutter/material.dart';
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
                    return GestureDetector(
                      onTap: () {
                        // En el lugar donde se llama a QRViewScreen desde MainScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRViewScreen(qrData: itemList[index]),
                          ),
                        ).then((value) {
                          if (value == 'delete') {
                            setState(() {
                              itemList.removeAt(index); // Elimina el artículo de la lista
                            });
                          }else if (value != null) {
                            setState(() {
                              itemList[index] = value; // Actualiza el artículo editado
                            });
                          }
                        });
                      },
                      child: Container(
                        child: ListTile(
                          title: Text(
                            itemList[index],
                            style: TextStyle(
                              color: Colors.white,
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

