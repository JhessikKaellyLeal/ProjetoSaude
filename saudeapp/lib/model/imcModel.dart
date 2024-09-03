class IMCModel {
  final int? id;
  final int idusuario;
  final double imc;
  final DateTime data;

  IMCModel({this.id,required this.idusuario, required this.imc, required this.data});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idusuario':idusuario,
      'imc': imc,
      'data': data.toIso8601String(),
    };
  }
}
