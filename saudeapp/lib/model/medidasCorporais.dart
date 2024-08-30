class MedidaCorporal {
  final int? id; // ID para o banco de dados
  final double cintura;
  final double quadril;
  final DateTime data;
  final String imagePath;

  MedidaCorporal({
    this.id,
    required this.cintura,
    required this.quadril,
    required this.data,
    required this.imagePath,
  });

  // Método para converter MedidaCorporal para um Map (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cintura': cintura,
      'quadril': quadril,
      'data': data.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  // Método para criar um objeto MedidaCorporal a partir de um Map (para ler do banco)
  factory MedidaCorporal.fromMap(Map<String, dynamic> map) {
    return MedidaCorporal(
      id: map['id'],
      cintura: map['cintura'],
      quadril: map['quadril'],
      data: DateTime.parse(map['data']),
      imagePath: map['imagePath'],
    );
  }
}
