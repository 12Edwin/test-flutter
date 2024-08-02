// lib/models/auto.dart
class Auto {
  final int id;
  final String marca;
  final String modelo;
  final String autonomiaElectrica;
  final String consumoCombustible;

  Auto({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.autonomiaElectrica,
    required this.consumoCombustible,
  });

  factory Auto.fromJson(Map<String, dynamic> json) {
    return Auto(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      autonomiaElectrica: json['autonomiaElectrica'],
      consumoCombustible: json['consumoCombustible'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'autonomiaElectrica': autonomiaElectrica,
      'consumoCombustible': consumoCombustible,
    };
  }
}