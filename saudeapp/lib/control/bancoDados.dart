import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'saude_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT NOT NULL,
        dataNascimento TEXT NOT NULL,
        sexo TEXT NOT NULL,
        email TEXT NOT NULL,
        senha TEXT NOT NULL,
        profileImagePath TEXT
      )
    ''');

    // Tabela de IMC
    await db.execute('''
      CREATE TABLE imc (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    // Tabela de Água
    await db.execute('''
      CREATE TABLE agua (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        quantidade REAL NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    // Tabela de Medidas Corporais
    await db.execute('''
      CREATE TABLE medidas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cintura REAL NOT NULL,
        quadril REAL NOT NULL,
        data TEXT NOT NULL,
        imagem TEXT
      )
    ''');
  }

  // Métodos para IMC
  Future<int> addIMC(double valor, DateTime data) async {
    final db = await database;
    return await db.insert('imc', {
      'valor': valor,
      'data': data.toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getIMC() async {
    final db = await database;
    return await db.query('imc');
  }

  // Métodos para Água
  Future<int> addWater(double quantidade, DateTime data) async {
    final db = await database;
    return await db.insert('agua', {
      'quantidade': quantidade,
      'data': data.toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getWater() async {
    final db = await database;
    return await db.query('agua');
  }

  // Métodos para Medidas Corporais
  Future<int> addMeasurement(
      double cintura, double quadril, DateTime data, String imagem) async {
    final db = await database;
    return await db.insert('medidas', {
      'cintura': cintura,
      'quadril': quadril,
      'data': data.toIso8601String(),
      'imagem': imagem,
    });
  }

  Future<List<Map<String, dynamic>>> getMeasurements() async {
    final db = await database;
    return await db.query('medidas');
  }
}
