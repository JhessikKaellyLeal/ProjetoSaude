import 'dart:async';
import 'dart:convert'; // Adicionado para manipulação de base64
import 'package:saudeapp/control/bancoDados.dart';
import 'package:saudeapp/model/medidasCorporais.dart';

class MedidaCorporalController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Método para salvar uma nova medida corporal
  Future<int> saveMedidaCorporal(MedidaCorporal medida) async {
    final db = await _databaseHelper.database;

    // Convertendo imagePath de Uint8List para base64 String para armazenamento
    final medidaToMap = medida.toMap();
    medidaToMap['imagePath'] = base64Encode(medida.imagePath);

    return await db.insert('medidas', medidaToMap);
  }

  // Método para buscar todas as medidas corporais de um usuário específico
  Future<List<MedidaCorporal>> getMedidasByUserId(int userId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medidas',
      where: 'idusuario = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      // Convertendo imagePath de base64 String para Uint8List
      final medida = MedidaCorporal.fromMap(maps[i]);
      final imageBytes = base64Decode(maps[i]['imagePath']);
      return MedidaCorporal(
        id: medida.id,
        idusuario: medida.idusuario,
        cintura: medida.cintura,
        quadril: medida.quadril,
        data: medida.data,
        imagePath: imageBytes,
      );
    });
  }

  // Método para buscar uma medida corporal específica por ID
  Future<MedidaCorporal?> getMedidaById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medidas',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final medida = MedidaCorporal.fromMap(maps.first);
      final imageBytes = base64Decode(maps.first['imagePath']);
      return MedidaCorporal(
        id: medida.id,
        idusuario: medida.idusuario,
        cintura: medida.cintura,
        quadril: medida.quadril,
        data: medida.data,
        imagePath: imageBytes,
      );
    } else {
      return null;
    }
  }

  // Método para atualizar uma medida corporal existente
  Future<int> updateMedidaCorporal(MedidaCorporal medida) async {
    final db = await _databaseHelper.database;

    // Convertendo imagePath de Uint8List para base64 String para armazenamento
    final medidaToMap = medida.toMap();
    medidaToMap['imagePath'] = base64Encode(medida.imagePath);

    return await db.update(
      'medidas',
      medidaToMap,
      where: 'id = ?',
      whereArgs: [medida.id],
    );
  }

  // Método para deletar uma medida corporal
  Future<int> deleteMedidaCorporal(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'medidas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
