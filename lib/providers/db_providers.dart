import 'dart:io';

import 'package:flutter/services.dart';
import 'package:padron_2022/models/persona.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  //INICIALIZAR DB
  initDB() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "app.db");

    await deleteDatabase(dbPath);
    ByteData data = await rootBundle.load("assets/aparana.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);
    return await openDatabase(dbPath);
  }

  Future<List<PersonaModel>?> getPerPorCed(int cedula) async {
    final db = await database;
    final sql =
        """
          select a.nombre as nombre, a.apellido as apellido, a.cedula as cedula, a.mesa as mesa, a.orden as orden, 
          dep.descrip as depart, dis.descrip as distrito, zon.descrip as zona, loc.descrip as local from registro a      
          LEFT join  dep on dep.depart = a.depart      
          LEFT join dis on dis.distrito = a.distrito and dis.depart = dep.depart      
          LEFT JOIN zon on zon.zona = a.zona and zon.depart = dis.depart and zon.distrito = dis.distrito      
          LEFT join loc on loc.local = a.local and loc.depart=zon.depart and loc.distrito = zon.distrito and loc.zona = zon.zona      
          where cedula = '$cedula'
        """;
    final res = await db?.rawQuery(sql);
    List<PersonaModel>? list =
        res != null? res?.map((f) => PersonaModel.fromJson(f)).toList() : [];
    return list;
  }
}
