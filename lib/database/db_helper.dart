// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/level_model.dart';
// import 'dart:async';
// import 'package:flutter/foundation.dart' show kIsWeb; // Needed to check for Web
//
// class DBHelper {
//   static Database? _database;
//
//   // Completer ensures that if multiple calls happen at once,
//   // they all wait for the same initialization process.
//   static Completer<Database>? _initCompleter;
//
//   // ===============================
//   // GET DB INSTANCE (Thread Safe)
//   // ===============================
//   static Future<Database> get database async {
//     // 1. Check if running on Web (sqflite will fail here)
//     if (kIsWeb) {
//       throw Exception("sqflite is not supported on Web. Please use an Android/iOS emulator.");
//     }
//
//     // 2. If DB is already open and valid, return it
//     if (_database != null && _database!.isOpen) {
//       return _database!;
//     }
//
//     // 3. If initialization is already in progress, wait for that specific future
//     if (_initCompleter != null && !_initCompleter!.isCompleted) {
//       return _initCompleter!.future;
//     }
//
//     // 4. Start initialization
//     _initCompleter = Completer<Database>();
//     try {
//       final db = await _initDB();
//       _database = db;
//       _initCompleter!.complete(db);
//       return db;
//     } catch (e) {
//       // If it fails, allow the next call to try again by resetting the completer
//       _initCompleter!.completeError(e);
//       _initCompleter = null;
//       rethrow;
//     }
//   }
//
//   // ===============================
//   // INITIALIZE DB
//   // ===============================
//   static Future<Database> _initDB() async {
//     // getDatabasesPath() is a native-only call
//     String path = join(await getDatabasesPath(), 'flowdots.db');
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDB,
//     );
//   }
//
//   // ===============================
//   // CREATE TABLES & SEED DATA
//   // ===============================
//   static Future<void> _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE levels(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         level INTEGER,
//         difficulty TEXT,
//         completed INTEGER,
//         moves INTEGER
//       )
//     ''');
//
//     // Use a Batch for faster initial insertion (efficiency)
//     Batch batch = db.batch();
//     for (int i = 1; i <= 15; i++) {
//       batch.insert(
//         'levels',
//         {
//           'level': i,
//           'difficulty': i <= 5 ? 'Easy' : (i <= 10 ? 'Medium' : 'Hard'),
//           'completed': 0,
//           'moves': 0,
//         },
//       );
//     }
//     await batch.commit(noResult: true);
//   }
//
//   // ===============================
//   // GET ALL LEVELS
//   // ===============================
//   static Future<List<LevelModel>> getLevels() async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> result = await db.query('levels', orderBy: 'level ASC');
//       return result.map((e) => LevelModel.fromMap(e)).toList();
//     } catch (e) {
//       print("Error fetching levels: $e");
//       return [];
//     }
//   }
//
//   // ===============================
//   // COMPLETE LEVEL
//   // ===============================
//   static Future<void> completeLevel(int level, int moves) async {
//     final db = await database;
//     await db.update(
//       'levels',
//       {
//         'completed': 1,
//         'moves': moves,
//       },
//       where: 'level = ?',
//       whereArgs: [level],
//     );
//   }
//
//   // ===============================
//   // RESET PROGRESS
//   // ===============================
//   static Future<void> resetProgress() async {
//     final db = await database;
//     await db.update(
//       'levels',
//       {
//         'completed': 0,
//         'moves': 0,
//       },
//     );
//   }
//
//   // ===============================
//   // HARD DELETE DATABASE
//   // ===============================
//   static Future<void> deleteDB() async {
//     if (kIsWeb) return;
//     String path = join(await getDatabasesPath(), 'flowdots.db');
//     _database = null;
//     _initCompleter = null;
//     await deleteDatabase(path);
//   }
// }