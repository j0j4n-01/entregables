class Peaje {
  final int id;
  final String placa;
  final String nombrePeaje;
  final String categoriaTarifaId;
  final DateTime fechaRegistro;
  final int valor;
  final String observacion;

  Peaje({
    required this.id,
    required this.placa,
    required this.nombrePeaje,
    required this.categoriaTarifaId,
    required this.fechaRegistro,
    required this.valor,
    required this.observacion,
  });

  factory Peaje.fromJson(Map<String, dynamic> json) {
    return Peaje(
      id: json['id'],
      placa: json['placa'],
      nombrePeaje: json['nombrePeaje'],
      categoriaTarifaId: json['categoriaTarifaId'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
      valor: json['valor'],
      observacion: json['observacion'],
    );
  }
}
