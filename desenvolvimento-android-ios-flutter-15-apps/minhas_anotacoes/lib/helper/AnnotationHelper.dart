import 'package:minhas_anotacoes/model/Annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnnotationHelper {

  static final String tableName = "annotation";
  static final AnnotationHelper _annotationHelper = AnnotationHelper._internal();
  Database _db;

  factory AnnotationHelper() {
    return _annotationHelper;
  }

  AnnotationHelper._internal();

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initializeDB();
      return _db;
    }
  }

  _initializeDB() async {
    final databasePath = await getDatabasesPath();
    final databaseLocal = join(databasePath, "minhas_anotacoes_database.db");

    var db = await openDatabase(databaseLocal, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $tableName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "title VARCHAR,"
      "description TEXT,"
      "date DATETIME"
    ")";
    await db.execute(sql);
  }

  Future<int> saveAnnotation(Annotation annotation) async {
    var database = await db;

    return await database.insert(tableName, annotation.toMap());
  }

  Future<int> updateAnnotation(Annotation annotation) async {
    var database = await db;

    return await database.update(
      tableName,
      annotation.toMap(),
      where: "id = ?",
      whereArgs: [annotation.id]
    );
  }

  listAnnotations() async {
    var database = await db;

    String sql = "SELECT * FROM $tableName ORDER BY date DESC";
    List annotations = await database.rawQuery(sql);
    return annotations;
  }

  Future<int> removeAnnotation(int id) async {
    var database = await db;

    return await database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}