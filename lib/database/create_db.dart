import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Nombre de la base de datos
  static const String _dbName = 'turnos_clientes.db';

  // Constructor privado
  DatabaseHelper._internal();

  // Singleton
  factory DatabaseHelper() {
    return _instance;
  }

  // Obtener la base de datos, inicializándola si es necesario
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Inicializar la base de datos
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Crear las tablas en la base de datos
  Future<void> _onCreate(Database db, int version) async {
    // Crear la tabla clientes
    await db.execute('''
      CREATE TABLE clientes (
        cliente_id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL,
        telefono TEXT,
        correo TEXT
      )
    ''');

    // Crear la tabla turnos con clave foránea cliente_id
    await db.execute('''
      CREATE TABLE turnos (
        turno_id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER,
        hora_reserva TEXT NOT NULL,
        hora_inicio TEXT,
        hora_fin TEXT,
        fecha_reserva TEXT NOT NULL,
        estado INTEGER CHECK (estado IN (0, 1)) NOT NULL,
        FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id)
      )
    ''');
  }

  // Método para cerrar la base de datos (opcional)
  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
  }
}
