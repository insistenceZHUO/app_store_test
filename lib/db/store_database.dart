import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TableName {
  static const String appId = "appId";
  static const String name = "name";
  static const String icon = "icon";
  static const String category = "category";
  static const String summary = "summary";

  TableName._();
}

class StoreDatabase {
  factory StoreDatabase() => _getInstance();

  static StoreDatabase get instance => _getInstance();
  static StoreDatabase? _instance;

  StoreDatabase._internal();

  static StoreDatabase _getInstance() => _instance ?? StoreDatabase._internal();

  /// 数据库版本
  final int dbVersion = 2;

  /// 数据库名称
  static const String _storeDBName = "store_test.db";

  static const String _appListTableName = "homeListTableName";

  static const String appId = TableName.appId;
  static const String name = TableName.name;
  static const String icon = TableName.icon;
  static const String category = TableName.category;
  static const String summary = TableName.summary;

  static const String _tableWalletV1 = '''
  CREATE TABLE IF NOT EXISTS $_appListTableName (
        $appId TEXT NOT NULL PRIMARY KEY,
        $name TEXT,
        $icon TEXT,
        $category TEXT,
        $summary TEXT
      );''';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _storeDBName);
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(_tableWalletV1);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}

  Future<void> insert(List<Map<String, dynamic>> list) async {
    Database db = await database;
    final batch = db.batch();
    for (var row in list) {
      batch.insert(_appListTableName, row);
    }
    await batch.commit();
  }

  Future<List<Map<String, Object?>>> queryApp({
    int limit = 10,
    int offset = 0,
  }) async {
    Database db = await database;
    var result = db.query(
      _appListTableName,
      limit: limit,
      offset: offset,
    );
    return result;
  }

  Future<List<Map<String, Object?>>> queryKeyword(String text) async {
    Database db = await database;
    var result = await db.rawQuery(
        "SELECT * FROM $_appListTableName WHERE $name LIKE '%$text%' OR $summary LIKE '%$text%'");
    return result;
  }
}
