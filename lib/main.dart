import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fasturno/database/create_db.dart';
import '../formulario/turno_form_dialog.dart';
import "../models/turno.dart";

String obtenerHora(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return "Formato de fecha no válido";
  }
}

void main() {
  // Inicializa la base de datos aquí
  initializeDatabase();
  runApp(const MyApp());
}

void initializeDatabase() {
  // Establece la fábrica de base de datos para usar con ffi
  //databaseFactory = databaseFactoryFfi;
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Usa sqflite_common_ffi para entornos de escritorio
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else {
    // Usa la implementación estándar para Android/iOS
    databaseFactory =
        databaseFactory; // Esto usa la implementación nativa de sqflite
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fasturno',
      home: const HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
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
  List<Turno> turnos = [];
  bool isMenuOpen = false;
  bool _switchValue = false;
  late Future<void>
      _dbFuture; // Futuro para la inicialización de la base de datos

  @override
  void initState() {
    super.initState();
    // Inicializa la base de datos cuando inicia el widget
    _dbFuture = _initializeDatabase();
    _loadTurnos();
  }

  Future<void> _loadTurnos() async {
    final dbHelper = DatabaseHelper.instance;
    turnos = await dbHelper.obtenerTurnos();
    setState(() {}); // Actualiza la interfaz
  }

  Future<void> _initializeDatabase() async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.database;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _dbFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar la base de datos: ${snapshot.error}',
                  style: TextStyle(fontSize: 14)));
        }
        return _buildMainScreen();
      },
    );
  }

  Widget _buildMainScreen() {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Encabezado
              _buildHeader(),
              // Título
              const Padding(
                padding: EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Turnos agendados",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 74, 173),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              // Grid responsivo
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                        top: 16, // Mantén el padding superior
                        left: 16, // Mantén el padding izquierdo
                        right: 16, // Mantén el padding derecho
                        bottom: 100, // Aumenta el padding inferior
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.6,
                      ),
                      itemCount:
                          turnos.length, // Número de elementos en el grid
                      itemBuilder: (context, index) {
                        return TurnoCard(turno: turnos[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Botón fijo para agregar turno
          _buildFloatingButton(context),
          // Menú lateral deslizante
          if (isMenuOpen) _buildSideMenu(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      // Esto asegura que el encabezado no se superponga a la barra de estado
      child: Container(
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
    );
  }

  Widget _buildFloatingButton(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 10,
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TurnoFormDialog(
                onTurnoGuardado: () {
                  setState(() {
                    _loadTurnos(); // Recargar la lista de turnos
                  });
                },
              );
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 0, 75, 173),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSideMenu() {
    return Stack(
      children: [
        // Fondo oscuro para cerrar el menú al hacer clic
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
        // Contenido del menú envuelto en un SafeArea
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceIn,
            width: 330,
            color: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: SafeArea(
              // Esto asegura que el contenido del menú no se sobreponga a las áreas no seguras
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuHeader(),
                  _buildMenuOptions(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Ajustes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              isMenuOpen = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Pausar recordatorios',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text(
              "Activa o desactiva temporalmente los correos automáticos."),
          trailing: Switch(
            value: _switchValue,
            onChanged: (bool value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
        ListTile(
          title: const Text('Ver resumen de turnos',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Visualiza cuántos clientes has atendido hoy."),
          contentPadding: const EdgeInsets.all(0),
          onTap: () {
            // Agregar lógica para ver el resumen de turnos
          },
        ),
      ],
    );
  }
}

class TurnoCard extends StatelessWidget {
  final Turno turno;

  const TurnoCard({super.key, required this.turno});

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
          _buildTurnoHeader(),
          const SizedBox(height: 8.0),
          _buildClientInfo(),
        ],
      ),
    );
  }

Widget _buildTurnoHeader() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Alinea todos los elementos a la izquierda
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Separa el texto y el icono
        children: [
          // Coloca el título y la hora en la parte izquierda
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Turno No. ${turno.id}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Hora de reservación:',
                style: TextStyle(color: Colors.black54, fontSize: 14.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                obtenerHora(turno.fecha),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2.0),
            ],
          ),
          const Icon(Icons.local_activity, size: 32),
        ],
      ),
      // Alinea el texto "Recién" a la derecha de la pantalla
      Align(
        alignment: Alignment.topRight,
        child: Text(
            'Recién', // Texto descriptivo de tiempo
            style: TextStyle(color: Colors.black54, fontSize: 14.0),
        ),
      ),
    ],
  );
}


  Widget _buildClientInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agendado a:',
              style: TextStyle(color: Colors.black54, fontSize: 14.0),
            ),
            Text(
              '${turno.nombre} ${turno.apellido}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: "Más opciones",
          onSelected: (value) {
            // Lógica para manejar acciones del menú
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
                value: 'info', child: Text('Más información')),
            const PopupMenuItem<String>(
                value: 'attend', child: Text('Atender')),
            const PopupMenuItem<String>(
                value: 'release', child: Text('Liberar')),
          ],
        ),
      ],
    );
  }
}
