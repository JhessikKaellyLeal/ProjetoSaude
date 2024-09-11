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
      profileImage TEXT
    )
  ''');

    // Tabela de IMC
    await db.execute('''
      CREATE TABLE imc (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL NOT NULL,
        data TEXT NOT NULL,
        idusuario INTEGER NOT NULL,
        FOREIGN KEY (idusuario) REFERENCES users(id)
      )
    ''');

    // Tabela de Medidas Corporais
    await db.execute('''
     CREATE TABLE medidas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cintura REAL NOT NULL,
      quadril REAL NOT NULL,
      data TEXT NOT NULL,
      imagemUrl TEXT, -- Alterado para URL
      idusuario INTEGER NOT NULL,
      FOREIGN KEY (idusuario) REFERENCES users(id)
    )
    ''');
  }
}
