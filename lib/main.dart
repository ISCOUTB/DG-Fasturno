import 'package:flutter/material.dart';
import 'package:fasturno/database/create_db.dart';
import 'package:fasturno/formulario/turno_form_dialog.dart';

void main() {
  runApp(const MyApp());
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
  bool isMenuOpen = false;
  bool _switchValue = false;
  late Future<void> _dbFuture; // Futuro para la inicialización de la base de datos

  @override
  void initState() {
    super.initState();
    // Inicializa la base de datos cuando inicia el widget
    _dbFuture = _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    final dbHelper = DatabaseHelper();
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
          return Center(child: Text('Error al cargar la base de datos: ${snapshot.error}'));
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.7,
                      ),
                      itemCount: 8, // Número de elementos en el grid
                      itemBuilder: (context, index) {
                        return TurnoCard(index: index + 1);
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
    return Container(
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
            builder: (BuildContext context) => const TurnoFormDialog(),
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
        // Contenido del menú
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuHeader(),
                _buildMenuOptions(),
              ],
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
          title: const Text('Pausar recordatorios', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Activa o desactiva temporalmente los correos automáticos."),
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
          title: const Text('Ver resumen de turnos', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildTurnoHeader(),
          const SizedBox(height: 8.0),
          _buildClientInfo(),
        ],
      ),
    );
  }

  Widget _buildTurnoHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
              style: TextStyle(color: Colors.black54, fontSize: 14.0),
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
        const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.local_activity, size: 40),
            SizedBox(height: 30.0),
            Text(
              'Hace n horas, minutos',
              style: TextStyle(color: Colors.black54, fontSize: 14.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClientInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Nombre y Apellido del cliente',
          style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w900),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: "Más opciones",
          onSelected: (value) {
            // Lógica para manejar acciones del menú
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(value: 'info', child: Text('Más información')),
            const PopupMenuItem<String>(value: 'attend', child: Text('Atender')),
            const PopupMenuItem<String>(value: 'release', child: Text('Liberar')),
          ],
        ),
      ],
    );
  }
}
