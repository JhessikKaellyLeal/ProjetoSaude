import 'dart:convert';

class MedidaCorporal {
  final int? id;
  final int idusuario;
  final double cintura;
  final double quadril;
  final DateTime data;
  final String imagemUrl; // Alterado para URL

  MedidaCorporal({
    this.id,
    required this.idusuario,
    required this.cintura,
    required this.quadril,
    required this.data,
    required this.imagemUrl, // Alterado para URL
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idusuario': idusuario,
      'cintura': cintura,
      'quadril': quadril,
      'data': data.toIso8601String(),
      'imagemUrl': imagemUrl, // Alterado para URL
    };
  }

  factory MedidaCorporal.fromMap(Map<String, dynamic> map) {
    return MedidaCorporal(
      id: map['id'],
      idusuario: map['idusuario'],
      cintura: map['cintura'],
      quadril: map['quadril'],
      data: DateTime.parse(map['data']),
      imagemUrl: map['imagemUrl'], // Alterado para URL
    );
  }
}
