class Turno {
  int? id;
  String nombre;
  String apellido;
  String telefono;
  String email;
  DateTime fecha;

  Turno({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.fecha,
  });

  // Convertir el turno en un mapa para insertarlo en la base de datos
  Map<String, dynamic> toMap() {
  return {
    'id': id,  
    'nombre': nombre,
    'apellido': apellido,
    'telefono': telefono,
    'email': email,
    'fecha': fecha.toIso8601String(),
  };
}


  // Convertir un mapa de la base de datos en un objeto Turno
  factory Turno.fromMap(Map<String, dynamic> map) {
    return Turno(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      telefono: map['telefono'],
      email: map['email'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}
