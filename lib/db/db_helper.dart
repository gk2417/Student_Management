import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import '../models/student.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  // Initialize DB
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4, // ✅ bumped version for profileImage column
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // Create table (fresh install)
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        roll TEXT,
        mobile TEXT,
        email TEXT,
        profileImage TEXT   -- ✅ new column
      )
    ''');
  }

  // Migration for older DB versions
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE students ADD COLUMN roll TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE students ADD COLUMN mobile TEXT');
      await db.execute('ALTER TABLE students ADD COLUMN email TEXT');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE students ADD COLUMN profileImage TEXT'); // ✅ migration
    }
  }

  // Insert student
  Future<int> insert(Student student) async {
    final db = await instance.database;
    return await db.insert('students', student.toMap());
  }

  // Get all students
  Future<List<Student>> getAll() async {
    final db = await instance.database;
    final result = await db.query('students');
    return result.map((json) => Student.fromMap(json)).toList();
  }

  // Update student
  Future<int> update(Student student) async {
    final db = await instance.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // Delete student
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
