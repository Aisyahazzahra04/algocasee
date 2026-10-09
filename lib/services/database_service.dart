import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class DatabaseService {
  // ============================================================
  // SINGLETON
  // ============================================================

  static final DatabaseService instance =
      DatabaseService._internal();

  DatabaseService._internal();

  static Database? _database;

  // ============================================================
  // DATABASE
  // ============================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // ============================================================
  // INIT DATABASE
  // ============================================================

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'algocase.db');

    return await openDatabase(
      path,

      // Kita naikkan versi karena struktur database berubah.
      version: 2,

      // ========================================================
      // DATABASE BARU
      // ========================================================

      onCreate: (db, version) async {
        await _createTables(db);
      },

      // ========================================================
      // DATABASE LAMA
      // ========================================================

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Karena database kita masih tahap pengembangan,
          // tabel lama kita hapus dan dibuat ulang sesuai PRD.

          await db.execute('DROP TABLE IF EXISTS user_answer');
          await db.execute('DROP TABLE IF EXISTS user_algorithm');
          await db.execute('DROP TABLE IF EXISTS user_progress');
          await db.execute('DROP TABLE IF EXISTS users');

          await _createTables(db);
        }
      },
    );
  }

  // ============================================================
  // CREATE TABLES
  // ============================================================

  Future<void> _createTables(Database db) async {
    // ==========================================================
    // USERS
    // ==========================================================

    await db.execute('''
      CREATE TABLE users (
        id_user INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL
      )
    ''');

    // ==========================================================
    // USER PROGRESS
    // ==========================================================

    await db.execute('''
      CREATE TABLE user_progress (
        id_user INTEGER NOT NULL,
        id_case TEXT NOT NULL,
        status TEXT NOT NULL,
        current_step TEXT NOT NULL,
        tanggal_selesai TEXT,

        PRIMARY KEY (id_user, id_case),

        FOREIGN KEY (id_user)
          REFERENCES users (id_user)
          ON DELETE CASCADE
      )
    ''');

    // ==========================================================
    // USER ALGORITHM
    // ==========================================================

    await db.execute('''
      CREATE TABLE user_algorithm (
        id_user INTEGER NOT NULL,
        id_case TEXT NOT NULL,
        struktur_algoritma TEXT,
        waktu_terakhir_diubah TEXT,

        PRIMARY KEY (id_user, id_case),

        FOREIGN KEY (id_user)
          REFERENCES users (id_user)
          ON DELETE CASCADE
      )
    ''');

    // ==========================================================
    // USER ANSWER
    // ==========================================================

    await db.execute('''
      CREATE TABLE user_answer (
        id_user INTEGER NOT NULL,
        id_case TEXT NOT NULL,
        id_step TEXT NOT NULL,
        jawaban TEXT,

        PRIMARY KEY (id_user, id_case, id_step),

        FOREIGN KEY (id_user)
          REFERENCES users (id_user)
          ON DELETE CASCADE
      )
    ''');
  }

  // ============================================================
  // CREATE USER
  // ============================================================

  Future<int> insertUser(UserModel user) async {
  final db = await database;

  // Simpan user
  final userId = await db.insert(
    'users',
    {
      'nama': user.name,
    },
  );

  // Buat progress awal Case 01
  await db.insert(
    'user_progress',
    {
      'id_user': userId,
      'id_case': '01',
      'status': 'Available',
      'current_step': '1',
      'tanggal_selesai': null,
    },
  );

  return userId;
}

  // ============================================================
  // READ USER
  // ============================================================

  Future<UserModel?> getUser() async {
    final db = await database;

    final result = await db.query(
      'users',
      orderBy: 'id_user ASC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel(
      id: result.first['id_user'] as int,
      name: result.first['nama'] as String,
    );
  }

  // ============================================================
  // UPDATE USER
  // ============================================================

  Future<int> updateUser(UserModel user) async {
    final db = await database;

    return await db.update(
      'users',
      {
        'nama': user.name,
      },
      where: 'id_user = ?',
      whereArgs: [user.id],
    );
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(
      'users',
      where: 'id_user = ?',
      whereArgs: [id],
    );
  }

  // ============================================================
  // CREATE / UPDATE PROGRESS
  // ============================================================

  Future<void> saveProgress({
    required int userId,
    required String caseId,
    required String status,
    required String currentStep,
    String? tanggalSelesai,
  }) async {
    final db = await database;

    await db.insert(
      'user_progress',
      {
        'id_user': userId,
        'id_case': caseId,
        'status': status,
        'current_step': currentStep,
        'tanggal_selesai': tanggalSelesai,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ============================================================
  // READ PROGRESS
  // ============================================================

  Future<Map<String, dynamic>?> getProgress({
    required int userId,
    required String caseId,
  }) async {
    final db = await database;

    final result = await db.query(
      'user_progress',
      where: 'id_user = ? AND id_case = ?',
      whereArgs: [userId, caseId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }
  

  // ============================================================
  // GET COMPLETED CASE COUNT
  // ============================================================

  Future<int> getCompletedCaseCount(int userId) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM user_progress
      WHERE id_user = ?
      AND status = ?
      ''',
      [userId, 'Completed'],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ============================================================
  // SAVE ANSWER
  // ============================================================

  Future<void> saveAnswer({
    required int userId,
    required String caseId,
    required String stepId,
    required String answer,
  }) async {
    final db = await database;

    await db.insert(
      'user_answer',
      {
        'id_user': userId,
        'id_case': caseId,
        'id_step': stepId,
        'jawaban': answer,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  
  // ============================================================
  // GET ANSWER
  // ============================================================

  Future<String?> getAnswer({
    required int userId,
    required String caseId,
    required String stepId,
  }) async {
    final db = await database;

    final result = await db.query(
      'user_answer',
      columns: ['jawaban'],
      where: 'id_user = ? AND id_case = ? AND id_step = ?',
      whereArgs: [userId, caseId, stepId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['jawaban'] as String?;
  }

  // ============================================================
  // SAVE ALGORITHM
  // ============================================================

  Future<void> saveAlgorithm({
    required int userId,
    required String caseId,
    required String algorithm,
  }) async {
    final db = await database;

    await db.insert(
      'user_algorithm',
      {
        'id_user': userId,
        'id_case': caseId,
        'struktur_algoritma': algorithm,
        'waktu_terakhir_diubah':
            DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}