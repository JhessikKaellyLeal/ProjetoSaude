import 'dart:convert'; // Adicione isto para base64
import 'dart:typed_data';

class MedidaCorporal {
  final int? id;
  final int idusuario; // ID do usuário
  final double cintura;
  final double quadril;
  final DateTime data;
  final Uint8List imagePath; // Imagem em bytes

  MedidaCorporal({
    this.id,
    required this.idusuario,
    required this.cintura,
    required this.quadril,
    required this.data,
    required this.imagePath,
  });

  // Método para converter MedidaCorporal para um Map (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idusuario': idusuario,
      'cintura': cintura,
      'quadril': quadril,
      'data': data.toIso8601String(),
      'imagePath': base64Encode(imagePath), // Convertendo Uint8List para base64 String
    };
  }

  // Método para criar um objeto MedidaCorporal a partir de um Map (para ler do banco)
  factory MedidaCorporal.fromMap(Map<String, dynamic> map) {
    return MedidaCorporal(
      id: map['id'],
      idusuario: map['idusuario'],
      cintura: map['cintura'],
      quadril: map['quadril'],
      data: DateTime.parse(map['data']),
      imagePath: base64Decode(map['imagePath']), // Convertendo base64 String de volta para Uint8List
    );
  }
}
