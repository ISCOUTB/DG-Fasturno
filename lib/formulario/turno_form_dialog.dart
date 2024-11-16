import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/turno.dart';

class TurnoFormDialog extends StatefulWidget {
  final Function() onTurnoGuardado; // Función callback para recargar la lista

  const TurnoFormDialog({super.key, required this.onTurnoGuardado});

  @override
  _TurnoFormDialogState createState() => _TurnoFormDialogState();
}

class _TurnoFormDialogState extends State<TurnoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Para guardar turno
  Future<void> _guardarTurno() async {
  if (_formKey.currentState!.validate()) {
    Turno nuevoTurno = Turno(
      nombre: _nombreController.text,
      apellido: _apellidoController.text,
      telefono: _telefonoController.text,
      email: _emailController.text,
      fecha: DateTime.now(),
    );
    // inserta el turno y envia mensaje
    try {
      await _dbHelper.insertarTurno(nuevoTurno);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Turno creado exitosamente')),
      );

      // Llama a la función onTurnoGuardado para actualizar la lista
      widget.onTurnoGuardado();

      // Cierra el dialogo
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear el turno')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Crea un turno nuevo',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 74, 173)),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del cliente',
                  hintText: 'Ingrese el nombre del cliente',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido del cliente',
                  hintText: 'Ingrese el apellido del cliente',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Debe contener 10 números',
                ),
                validator: (value) {
                  if (value == null || value.length != 10) {
                    return 'El teléfono debe tener 10 dígitos';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  hintText: 'email@email.com',
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Ingrese un correo válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _guardarTurno,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 74, 173),
            foregroundColor: Colors.white,
          ),
          child: const Text('CREAR TURNO'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCELAR'),
        ),
      ],
    );
  }
  //PRUEBA DE QUE SIRVE TODO Y SE GUARDO COMO ERA
}
