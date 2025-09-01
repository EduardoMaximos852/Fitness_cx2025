import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('academia.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE clientes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      peso REAL NOT NULL,
      altura REAL NOT NULL,
      idade INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE rotinas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      objetivo TEXT NOT NULL,
      frequencia TEXT,
      duracao INTEGER
    )
  ''');

    await db.execute('''
    CREATE TABLE exercicios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      rotina_id INTEGER NOT NULL,
      nome TEXT NOT NULL,
      series TEXT,
      observacao TEXT,
      FOREIGN KEY (rotina_id) REFERENCES rotinas (id)
    )
  ''');
  }

// Inserir rotina
Future<int> insertRotina(Map<String, dynamic> rotina) async {
  final db = await instance.database;
  return await db.insert('rotinas', rotina);
}

// Inserir exercício
Future<int> insertExercicio(Map<String, dynamic> exercicio) async {
  final db = await instance.database;
  return await db.insert('exercicios', exercicio);
}



  /// 🚀 Inserir cliente no banco
  Future<int> addCliente(Map<String, dynamic> cliente) async {
    final db = await instance.database;
    return await db.insert('clientes', cliente);
  }

  /// 📥 Buscar todos os clientes
  Future<List<Map<String, dynamic>>> getClientes() async {
    final db = await instance.database;
    return await db.query('clientes');
  }

  /// ✏️ Atualizar cliente
  Future<int> updateCliente(Map<String, dynamic> cliente) async {
    final db = await instance.database;
    return await db.update(
      'clientes',
      cliente,
      where: 'id = ?',
      whereArgs: [cliente['id']],
    );
  }

  /// ❌ Deletar cliente
  Future<int> deleteCliente(int id) async {
    final db = await instance.database;
    return await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }
}
