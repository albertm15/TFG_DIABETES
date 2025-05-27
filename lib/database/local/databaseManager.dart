import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _db;

  final String _glucoseLogTable = '''
      CREATE TABLE GlucoseLogs(
        id TEXT PRIMARY KEY,
        userId TEXT,
        glucoseValue INTEGER,
        date TEXT,
        time TEXT,
        category TEXT,
        hyperglucemia INTEGER,
        hypoglucemia INTEGER,
        sensations TEXT
      );

    ''';
  final String _dietLogTable = '''
      CREATE TABLE DietLogs(
        id TEXT PRIMARY KEY,
        userId TEXT,
        totalInsulinUnits REAL,
        totalCarbs TEXT,
        time TEXT,
        date TEXT
      );
    ''';

  final String _dietTable = '''
      CREATE TABLE Diets(
        id TEXT PRIMARY KEY,
        userId TEXT,
        breakfastSchedule TEXT,
        snackSchedule TEXT,
        lunchSchedule TEXT,
        afternoonSnackSchedule TEXT,
        dinnerSchedule TEXT
      );
    ''';

  final String _exerciceLogTable = '''
      CREATE TABLE ExerciceLogs(
        id TEXT PRIMARY KEY,
        userId TEXT,
        category INTEGER,
        duration TEXT,
        beforeSensations TEXT,
        afterSensations TEXT,
        date TEXT,
        time TEXT
      );
    ''';

  final String _foodTable = '''
      CREATE TABLE Foods(
        id TEXT PRIMARY KEY,
        userId TEXT,
        carbsPer100 REAL,
        name TEXT
      );
    ''';

  final String _insulinLogTable = '''
      CREATE TABLE InsulinLogs(
        id TEXT PRIMARY KEY,
        userId TEXT,
        fastActingInsulinConsumed REAL,
        date TEXT,
        time TEXT,
        location String
      );
    ''';

  final String _insulinTable = '''
      CREATE TABLE Insulins(
        id TEXT PRIMARY KEY,
        userId TEXT,
        firstInjectionSchedule TEXT,
        secondInjectionSchedule TEXT,
        totalSlowActingInsulin REAL,
        totalFastActingInsulin REAL
      );
    ''';

  final String _reminderTable = '''
      CREATE TABLE Reminders(
        id TEXT PRIMARY KEY,
        userId TEXT,
        title TEXT,
        time TEXT,
        date TEXT,
        repeat INTEGER,
        repeatConfig TEXT
      );
    ''';

  final String _userTable = '''
      CREATE TABLE Users(
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        height INTEGER,
        weight REAL,
        typeOfDiabetes INTEGER,
        fullName TEXT,
        sex TEXT,
        country TEXT
      );
    ''';

  final String _dietLogFoodRelationTable = '''
      CREATE TABLE DietFoodRelation(
        id TEXT PRIMARY KEY,
        userId TEXT,
        dietLogId TEXT,
        foodId TEXT,
        grams REAL
      );
    ''';

  DatabaseManager._init() {}

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB("diabetes_tfg_app.db");
    return _db!;
  }

  Future<Database> _initDB(String dbFilePath) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, dbFilePath);
    //print(path);
    //await deleteDatabase(path);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future<void> deleteDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "diabetes_tfg_app.db");
    await deleteDatabase(path);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute(_glucoseLogTable);
    await db.execute(_dietLogTable);
    await db.execute(_dietTable);
    await db.execute(_exerciceLogTable);
    await db.execute(_foodTable);
    await db.execute(_insulinLogTable);
    await db.execute(_insulinTable);
    await db.execute(_reminderTable);
    await db.execute(_userTable);
    await db.execute(_dietLogFoodRelationTable);
  }
}
