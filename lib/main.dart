import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue, // Color principal
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMenuOpen = false; // Controla si el menú está abierto o cerrado.
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Encabezado
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/fasturno.PNG', // Reemplazar con la ruta correcta
                      height: 25,
                    ),
                    // Botón de menú
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          isMenuOpen = true; // Abre el menú
                        });
                      },
                    ),
                  ],
                ),
              ),
              Text("Turnos agendados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 74, 173))),
              // Grid responsivo
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    //int columns = constraints.maxWidth > 600 ? 3 : 1;
                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400.0, // Tamaño máximo en el eje transversal
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.5, // Relación de aspecto predetermina
                      ),
                      itemCount: 12, // Número de elementos en el grid
                      itemBuilder: (context, index) {
                        return Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3EFFF),
                            borderRadius: BorderRadius.circular(10.0), // Border radius
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                              'Turno No. $index',
                              style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Botón fijo en la esquina inferior derecha
          Positioned(
            bottom: 20,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color.fromARGB(255, 0, 75, 173),
              child: Icon(Icons.add, color: Colors.white,),
            ),
          ),
          // Menú lateral deslizante
          if (isMenuOpen)
            ...[
              // Fondo oscuro al hacer clic para cerrar el menú
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isMenuOpen = false;
                    });
                  },
                  child: Container(
                    color: Colors.black54,
                  ),
                ),
              ),
              // Contenido del menú
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.bounceIn, // Animación para suavizar la apertura/cierre
                  width: 330,
                  color: Colors.white,
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ajustes',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                isMenuOpen = false; // Cierra el menú
                              });
                            },
                          ),
                        ],
                      ),
                      // Aquí va el contenido del menú
                      ListTile(
                        title: Text('Pausar recordatorios',style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text("Activa o desactiva temporalmente los correos automáticos que recuerdan a los clientes cuando son sus turnos."),
                        trailing: Switch(
                          value: _switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              _switchValue = value;
                            });
                          }),
                        contentPadding: EdgeInsets.all(0),
                        onTap: () {}
                        ),
                      ListTile(
                        title: Text('Ver resumen de turnos', style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text("Visualiza cuantos clientes has atendido hoy y el tiempo promedio que demoras en atenderlos."),
                        contentPadding: EdgeInsets.all(0),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ]
        ],
      ),
    );
  }
}
