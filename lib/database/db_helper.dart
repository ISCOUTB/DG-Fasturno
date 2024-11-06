import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/turno.dart';

// Inicializa el databaseFactory y la configuración de FFI
void initializeDatabase() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi; // Asigna el databaseFactory FFI
}

// Llama a la función de inicialización al comenzar


class DatabaseHelper {
  static Database? _database;
  static const _databaseName = 'turnos.db';
  static const _databaseVersion = 1;
  static const table = 'turnos';
  static const columnId = 'id';
  static const columnNombre = 'nombre';
  static const columnApellido = 'apellido';
  static const columnTelefono = 'telefono';
  static const columnEmail = 'email';
  static const columnFecha = 'fecha';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNombre TEXT NOT NULL,
        $columnApellido TEXT NOT NULL,
        $columnTelefono TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnFecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertarTurno(Turno turno) async {
  try {
    Database db = await instance.database;
    return await db.insert(
      table,
      turno.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print("Error al insertar el turno: $e");
    rethrow; // Vuelve a lanzar la excepción para que pueda ser manejada en otro lugar si es necesario
  }
}

Future<List<Turno>> obtenerTurnos() async {
  try {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.isNotEmpty
        ? result.map((e) => Turno.fromMap(e)).toList()
        : [];
  } catch (e) {
    print("Error al obtener los turnos: $e");
    return []; // Retorna una lista vacía en caso de error
  }
}

Future<Turno?> obtenerTurnoPorId(int id) async {
  try {
    Database db = await instance.database;
    var result = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Turno.fromMap(result.first) : null;
  } catch (e) {
    print("Error al obtener el turno con id $id: $e");
    return null; // Retorna null si ocurre un error
  }
}

Future<int> actualizarTurno(Turno turno) async {
  try {
    Database db = await instance.database;
    return await db.update(
      table,
      turno.toMap(),
      where: '$columnId = ?',
      whereArgs: [turno.id],
    );
  } catch (e) {
    print("Error al actualizar el turno: $e");
    return 0; // Retorna 0 si ocurre un error
  }
}

Future<int> eliminarTurno(int id) async {
  try {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print("Error al eliminar el turno con id $id: $e");
    return 0; // Retorna 0 si ocurre un error
  }
}
}