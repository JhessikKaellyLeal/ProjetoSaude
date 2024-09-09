class IMCModel {
  final int? id;
  final int idusuario;
  final double imc;
  final DateTime data;

  IMCModel({
    this.id,
    required this.idusuario,
    required this.imc,
    required this.data,
  });

  // Converte o modelo para um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': imc, // Corrigido para corresponder ao nome do campo no banco de dados
      'data': data.toIso8601String(),
      'idusuario': idusuario,
    };
  }

  // Construtor para criar uma instância a partir de um mapa
  factory IMCModel.fromMap(Map<String, dynamic> map) {
    return IMCModel(
      id: map['id'],
      idusuario: map['idusuario'],
      imc: map['valor'], // Corrigido para corresponder ao nome do campo no banco de dados
      data: DateTime.parse(map['data']),
    );
  }
}
