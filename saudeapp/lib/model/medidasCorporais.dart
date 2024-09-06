import 'dart:convert';
import 'dart:typed_data';

class MedidaCorporal {
  final int? id;
  final int idusuario;
  final double cintura;
  final double quadril;
  final DateTime data;
  final Uint8List imagePath;

  MedidaCorporal({
    this.id,
    required this.idusuario,
    required this.cintura,
    required this.quadril,
    required this.data,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idusuario': idusuario,
      'cintura': cintura,
      'quadril': quadril,
      'data': data.toIso8601String(),
      'imagePath': base64Encode(imagePath),
    };
  }

  factory MedidaCorporal.fromMap(Map<String, dynamic> map) {
    return MedidaCorporal(
      id: map['id'],
      idusuario: map['idusuario'],
      cintura: map['cintura'],
      quadril: map['quadril'],
      data: DateTime.parse(map['data']),
      imagePath: base64Decode(map['imagePath']),
    );
  }
}
