import 'package:fasturno/formulario/turno_form_dialog.dart';
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
      home: const HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue, // Color principal
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          isMenuOpen = true; // Abre el menú
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16), 
                child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Turnos agendados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 74, 173)), textAlign: TextAlign.left),
              ),
              ),
              // Grid responsivo
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    //int columns = constraints.maxWidth > 600 ? 3 : 1;
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: 80
                      ),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400.0, // Tamaño máximo en el eje transversal
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.7, // Relación de aspecto predeterminada
                      ),
                      itemCount: 8, // Número de elementos en el grid
                      itemBuilder: (context, index) {
                        return TurnoCard(index: index+1);
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
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const TurnoFormDialog(),
                );
              },
              backgroundColor: const Color.fromARGB(255, 0, 75, 173),
              child: const Icon(Icons.add, color: Colors.white,),
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
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn, // Animación para suavizar la apertura/cierre
                  width: 330,
                  color: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ajustes',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
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
                        title: const Text('Pausar recordatorios',style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: const Text("Activa o desactiva temporalmente los correos automáticos que recuerdan a los clientes cuando son sus turnos."),
                        trailing: Switch(
                          value: _switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              _switchValue = value;
                            });
                          }),
                        contentPadding: const EdgeInsets.all(0),
                        onTap: () {}
                        ),
                      ListTile(
                        title: const Text('Ver resumen de turnos', style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: const Text("Visualiza cuantos clientes has atendido hoy y el tiempo promedio que demoras en atenderlos."),
                        contentPadding: const EdgeInsets.all(0),
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

class TurnoCard extends StatelessWidget {
  final int index;

  const TurnoCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3EFFF),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Texto de turno y reservación
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Turno No. $index',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Hora de reservación:',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                  const Text(
                    '00:00',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Ícono de ticket con el texto debajo
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.local_activity, size: 40), // Ícono del ticket
                  SizedBox(height: 30.0), // Espacio entre ícono y texto
                  Text(
                    'Hace n horas, minutos',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 8.0),

          // Texto "Agendado a:"
          const Text(
            'Agendado a:',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.0,
            ),
          ),

          // Nombre y apellido del cliente con el menú
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nombre y Apellido del cliente',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: "Más opciones",
                onSelected: (value) {
                  // Lógica para manejar las acciones de los botones
                },
                itemBuilder: (BuildContext context) {
                  return {'Más información', 'Atender', 'Liberar'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ],
      ),

    );
  }
}