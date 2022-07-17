import 'package:myrecipes/Model/Receita.dart';
import 'package:myrecipes/View/Components/Lista.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {

  static final DB instance = DB._init();

  static Database? _database;

  DB._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB("receitas.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receitas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          titulo TEXT NOT NULL,
          ingredientes TEXT NOT NULL,
          preparo TEXT NOT NULL,
          imagem TEXT NOT NULL
      )
    ''');

    // await db.insert("receitas", {"titulo": "Primeira receita", "ingredientes": "ingrediente....", "preparo": "preparo...", "imagem": "https://image.shutterstock.com/image-photo/red-apple-isolated-on-white-260nw-1727544364.jpg"});

  }

  Future insertReceita(Receita receita) async {
    final db = await instance.database;
    final id = await db.insert("receitas", receita.toJson());
    return receita.copy(id: id);
  }

  Future removeReceita(int id) async {
    final db = await instance.database;

    await db.rawQuery("DELETE FROM receitas WHERE id = ?", [id]);
  }

  Future<Receita?> readReceita(int id) async {
    final db = await instance.database;

    final maps = await db.query(
        "receitas",
        columns: ["titulo", "ingredientes", "preparo", "imagem"],
        where: "id = ?",
        whereArgs: [id]
    );

    if(maps.isNotEmpty) {
      return Receita.fromJson(maps.first);
    }

    return null;

  }

  Future<List<Receita>> readAllReceita() async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM receitas ORDER BY id ASC");

    return result.map((json) => Receita.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

}