import '../database/db_helper.dart';  // Asegúrate de que el camino sea correcto
import '../models/turno.dart';

class TurnoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;  // Instancia única de DatabaseHelper

  // Método para obtener todos los turnos desde la base de datos
  Future<List<Turno>> obtenerTodosTurnos() async {
    // Usamos el método de DBHelper para obtener los turnos
    final List<Turno> turnos = await _dbHelper.obtenerTurnos();
    return turnos;
  }

  // Método para insertar un nuevo turno en la base de datos
  Future<int> insertarTurno(Turno turno) async {
    // Usamos el método de DBHelper para insertar un nuevo turno
    return await _dbHelper.insertarTurno(turno);
  }
}
