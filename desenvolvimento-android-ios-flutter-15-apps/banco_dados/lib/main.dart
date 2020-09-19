import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _getDatabase() async {
    final databasePath = await getDatabasesPath();
    final databaseLocal = join(databasePath, "database.db");

    var database = openDatabase(
      databaseLocal,
      version: 1,
      onCreate: (db, dbRecentVersion) {
        String sql = "CREATE TABLE users ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "name VARCHAR,"
          "age INTEGER"
        ")";
        db.execute(sql);
      },
    );

    return database;
  }

  _save() async {
    Database database = await _getDatabase();

    Map<String, dynamic> userData = {
      "name": "Vitor Hugo",
      "age": 17
    };
    int id = await database.insert("users", userData);
    print(id.toString());
  }

  _list() async {
    Database database = await _getDatabase();

    String sql = "SELECT * FROM users";
    var list = await database.rawQuery(sql);
    print(list.toString());
    for(var item in list) {
      print("Id: " + item['id'].toString());
      print("Nome: " + item['name']);
      print("Idade: " + item['age'].toString());
      print("==============");
    }
  }

  _get(int id) async {
    Database database = await _getDatabase();

    return await database.query(
      "users",
      columns: ["id", "name", "age"],
      where: "id = ?",
      whereArgs: [id],
    );
  }

  _destroy(int id) async {
    Database database = await _getDatabase();

    return await database.delete(
      "users",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  _update(int id) async {
    Database database = await _getDatabase();

    Map<String, dynamic> data = {
      "name": "Vitor H",
      "age": 18,
    };

    return await database.update(
      "users",
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  @override
  Widget build(BuildContext context) {

    this._list();
    // this._save();
    // this._get(1);
    // this._update(3);
    // this._destroy(3);

    return Scaffold(
      body: Center(
        child: Text(
          "Hello",
          style: TextStyle(
            fontSize: 50,
            letterSpacing: 5,
          )
        ),
      ),
    );
  }
}

