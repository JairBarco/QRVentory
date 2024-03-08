import 'package:flutter/material.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  final String? name;
  final String? email;

  MyDrawer({this.name, this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        width: 265,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black,
            iconTheme:
                IconThemeData(color: Colors.white), // Color de los iconos
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white), // Color del texto
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name != null ? name! : '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      email != null ? email! : '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.white54,
                ),
                title: Text('Perfil'),
                onTap: () {
                  // Acción para ir a la pantalla de perfil
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white54,
                ),
                title: Text('Cerrar Sesión'),
                onTap: () async {
                  try {
                    await fAuthUser.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const MySplashScreen()),
                    );
                  } catch (error) {
                    print("Error al cerrar sesión: $error");
                    // Manejar errores aquí si es necesario
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
