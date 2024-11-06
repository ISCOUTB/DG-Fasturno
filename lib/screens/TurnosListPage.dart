import 'package:flutter/material.dart';
import '../models/turno.dart';
import 'package:fasturno/repositories/turno_repository.dart';

class TurnosListPage extends StatefulWidget {
  const TurnosListPage({super.key});

  @override
  _TurnosListPageState createState() => _TurnosListPageState();
}

class _TurnosListPageState extends State<TurnosListPage> {
  late TurnoRepository _turnoRepository;
  List<Turno> _turnos = [];

  @override
  void initState() {
    super.initState();
    _turnoRepository = TurnoRepository();
    _loadTurnos();
  }

  _loadTurnos() async {
    List<Turno> turnos = await _turnoRepository.obtenerTodosTurnos();
    setState(() {
      _turnos = turnos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Turnos'),
      ),
      body: ListView.builder(
        itemCount: _turnos.length,
        itemBuilder: (context, index) {
          final turno = _turnos[index];
          return ListTile(
            title: Text(turno.nombre),
            subtitle: Text('Fecha: ${turno.fecha.toLocal()}'),
          );
        },
      ),
    );
  }
}
