import 'package:baby_tracker/data/milk_fields.dart';
import 'package:baby_tracker/data/milk_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MilkDatabase {
  static final MilkDatabase instance = MilkDatabase._internal();

  static Database? _database;

  MilkDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'milks.db');
    return await openDatabase(
        path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
      CREATE TABLE ${MilkFields.tableName} (
        ${MilkFields.id} ${MilkFields.idType},
        ${MilkFields.quantity} ${MilkFields.intType},
        ${MilkFields.type} ${MilkFields.textType},
        ${MilkFields.takenDate} ${MilkFields.textType},
        ${MilkFields.createdTime} ${MilkFields.textType}
      )
    ''');
  }

  Future<MilkModel> create(MilkModel milk) async {
    final db = await instance.database;
    final id = await db.insert(MilkFields.tableName, milk.toJson());
    return milk.copy(id: id);
  }

  Future<MilkModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      MilkFields.tableName,
      columns: MilkFields.values,
      where: '${MilkFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MilkModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<MilkModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${MilkFields.createdTime} DESC';
    final result = await db.query(MilkFields.tableName, orderBy: orderBy);
    return result.map((json) => MilkModel.fromJson(json)).toList();
  }

  Future<int> update(MilkModel milk) async {
    final db = await instance.database;
    return db.update(
      MilkFields.tableName,
      milk.toJson(),
      where: '${MilkFields.id} = ?',
      whereArgs: [milk.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      MilkFields.tableName,
      where: '${MilkFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}