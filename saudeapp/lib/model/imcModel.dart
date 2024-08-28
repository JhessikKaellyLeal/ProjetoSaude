class IMCModel {
  final int? id;
  final double imc;
  final DateTime data;

  IMCModel({this.id, required this.imc, required this.data});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imc': imc,
      'data': data.toIso8601String(),
    };
  }
}
