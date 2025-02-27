import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class dbhelper {
  dbhelper._();
  static final dbhelper getinstance = dbhelper._();

  Database? mydb;

  Future<Database> getdb() async {
    mydb ??= await opendb();
    return mydb!;
  }

  Future<Database> opendb() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    String dbpath = join(appdir.path, "firstdb.db");

    return await openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE notes (s_no INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT)");
      },
    );
  }

  Future<bool> addnotes({required String mtitle, required String mdesc}) async {
    var db = await getdb();
    int rowaffected =
        await db.insert("notes", {"title": mtitle, "description": mdesc});
    return rowaffected > 0;
  }

  Future<List<Map<String, dynamic>>> getallnotes() async {
    var db = await getdb();
    return await db.query("notes");
  }

  Future<bool> updatenote(
      {required String mtitle, required String mdesc, required int sid}) async {
    var db = await getdb();
    int rowaffected = await db.update(
        "notes",
        {
          "title": mtitle,
          "description": mdesc,
        },
        where: "s_no = ?",
        whereArgs: [sid]);

    return rowaffected > 0;
  }

  Future<bool> delete({required int sno}) async {
    var db = await getdb();
    int rowaffected =
        await db.delete("notes", where: "s_no=?", whereArgs: [sno]);
    return rowaffected > 0;
  }
}
