import 'package:flutter/material.dart';
import 'package:users_app/users/en/mainScreens/qr_screen.dart';
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

class MainScreen extends StatelessWidget {
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => QRScreen()));
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        name: userModelCurrentInfo != null
            ? userModelCurrentInfo!.name
            : "Nombre",
        email: userModelCurrentInfo != null
            ? userModelCurrentInfo!.email
            : "Correo electrónico",
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
                //Todo lo que está aqui es temporal, solo para demo.
                child: ListView.builder(
                  itemCount: 10, // Número de elementos de la lista
                  itemBuilder: (context, index) {
                    // Construir elementos de la lista
                    return Container(
                      child: ListTile(
                        title: Text(
                          "Item $index",
                          style: TextStyle(
                            color: Colors
                                .white, // Texto blanco para contrastar con el fondo negro
                          ),
                        ),
                        //Detalles de los artículos
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
