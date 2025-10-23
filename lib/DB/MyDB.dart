import 'dart:io';

import 'package:lonchi_ing_gd/MyClasses/MyItems.dart';
import 'package:lonchi_ing_gd/MyClasses/MyPhotos.dart';
import 'package:lonchi_ing_gd/MyClasses/MyReport.dart';
import 'package:lonchi_ing_gd/MyClasses/Utility.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// import 'models/task.dart';
// import 'models/to do.dart';

class DatabaseHelper {

  Future<Database> database() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    // print (dataDirectory.path);
    return openDatabase(
      join(await getDatabasesPath(), 'report.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE proyectos(id INTEGER PRIMARY KEY, title TEXT, count INTEGER, photo TEXT)");
        await db.execute("CREATE TABLE reports(id INTEGER PRIMARY KEY, proyectoId INTEGER, proyecttitle TEXT, title TEXT, date TEXT, count INTEGER, datetime INTEGER)");
        await db.execute("CREATE TABLE items(id INTEGER PRIMARY KEY, proyectoId INTEGER, reportId INTEGER, description TEXT, photo TEXT, count INTEGER)");
        await db.execute("CREATE TABLE photos(id INTEGER PRIMARY KEY, itemId INTEGER, proyectoId INTEGER, reportId INTEGER, photo TEXT)");
        await db.execute("CREATE TABLE logo(id INTEGER PRIMARY KEY, proyectoId INTEGER, photo TEXT)");
        // return db;
      },
      version: 1,
    );
  }

  // Future<Database> logodb() async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), 'report.db'),
  //     onCreate: (db, version) async {
  //       await db.execute("CREATE TABLE logo(id INTEGER PRIMARY KEY, photo TEXT)");
  //       return db;
  //     },
  //     version: 1,
  //   );
  // }

  Future<int> insertProyecto(Proyecto proyecto) async {
    int proyectoId = 0;
    Database _db = await database();
    await _db.insert('proyectos', proyecto.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      proyectoId = value;
    });
    await _db.rawUpdate("UPDATE proyectos SET count = ? WHERE id = '$proyectoId'",[0]);
    return proyectoId;
  }

  Future<int> insertReport(Report report) async {
    int reportId = 0;
    Database _db = await database();
    await _db.insert('reports', report.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      reportId = value;
    });
    await _db.rawUpdate("UPDATE reports SET count = ? WHERE id = '$reportId'", [0]);
    return reportId;
  }

  Future<int> insertItem(Items items) async {
    int itemId = 0;
    Database _db = await database();
    await _db.insert('items', items.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      itemId = value;
    });
    await _db.rawUpdate("UPDATE items SET count = ? WHERE id = '$itemId'",[0]);
    return itemId;
  }

  Future<int> insertPhoto(Photos photo) async {
    int photoId = 0;
    Database _db = await database();
    await _db.insert('photos', photo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      photoId = value;
    });
    return photoId;
  }

  Future<int> insertLogo(Logo logo) async {
    int id = 0;
    Database _db = await database();
    await _db.insert('logo', logo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      id = value;
    });
    return id;
  }

  Future<void> updateProyectoLogo(int id, String logo) async {
    Database _db = await database();
    await _db.rawQuery("UPDATE proyectos SET photo = '$logo' WHERE id = '$id'");
    // await _db.rawQuery("UPDATE logo SET photo = $logo WHERE proyectoId = '$id'");
    throw 'Error al salvar logo';
  }


  Future<void> updateProyectoTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE proyectos SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateProyectoCount(int id) async {
    Database _db = await database();
    await _db.rawQuery("UPDATE proyectos SET count = (count + 1) WHERE id = '$id'");
  }

  Future<void> updateReportTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE reports SET title = '$title' WHERE id = '$id'");
  }

  Future<void> initialReportDate(int id, String date, int datetime) async{
    Database _db = await database();
    await _db.rawUpdate("UPDATE reports SET date = '$date' WHERE id = '$id'");
    await _db.rawUpdate("UPDATE reports SET datetime = '$datetime' WHERE id = '$id'");
  }

  Future<void> updateReportDate(int id, String date) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE reports SET date = '$date' WHERE id = '$id'");
  }

  Future<void> updateReportDateTime(int id, int datetime) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE reports SET datetime = '$datetime' WHERE id = '$id'");
  }

  Future<void> updateReportCount(int id) async {
    Database _db = await database();
    await _db.rawQuery("UPDATE reports SET count = (count + 1) WHERE id = '$id'");
  }

  Future<void> updateItemDesc(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE items SET description = '$description' WHERE id = '$id'");
  }

  Future<void> updatePhoto(int id, String photo) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE photos SET photo = '$photo' WHERE id = '$id'");
  }

  Future<List<Proyecto>> getProyectos() async {
    Database _db = await database();
    List<Map<String, dynamic>> proyectoMap = await _db.query('proyectos');
    return List.generate(proyectoMap.length, (index) {
      return Proyecto(id: proyectoMap[index]['id'], title: proyectoMap[index]['title'], count: proyectoMap[index]['count'], photo: proyectoMap[index]['photo']);
    });
  }

  Future<Proyecto?> getProyectoById(int proyectoId) async {
    Database _db = await database();
    final maps = await _db.query(
      'proyectos',
      where: 'id = ?',
      whereArgs: [proyectoId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return Proyecto(id: map['id'] as int?, title: map['title'] as String?, count: map['count'] as int?, photo: map['photo'] as String?);
    } else {
      return null; // no project found
    }
  }

  Future<List<Proyecto>> getProyectosFiltered(String text) async {
    Database _db = await database();
    List<Map<String, dynamic>> proyectoMap = await _db.rawQuery("SELECT * FROM proyectos WHERE title LIKE '%$text%'");
    return List.generate(proyectoMap.length, (index) {
      return Proyecto(id: proyectoMap[index]['id'], title: proyectoMap[index]['title'], count: proyectoMap[index]['count'], photo: proyectoMap[index]['photo']);
    });
  }

  Future<List<Report>> getReports() async {
    Database _db = await database();
    List<Map<String, dynamic>> reportMap = await _db.query('reports');
    return List.generate(reportMap.length, (index) {
      return Report(id: reportMap[index]['id'], proyectoId: reportMap[index]['proyectoId'], title: reportMap[index]['title'],  date: reportMap[index]['date'], count: reportMap[index]['count']);
    });
  }

  Future<List<Report>> getProyectoReports(int proyectoId) async {
    Database _db = await database();
    List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE proyectoId = $proyectoId");
    // List<Map<String, dynamic>> reportMap = await _db.query('reports');
    return List.generate(reportMap.length, (index) {
      return Report(id: reportMap[index]['id'], proyectoId: reportMap[index]['proyectoId'], title: reportMap[index]['title'],  date: reportMap[index]['date'], count: reportMap[index]['count']);
    });
  }

  Future<List<Report>> getReportsFiltered(int proyectoId, String text, int Dateini, int Datefin) async {
    Database _db = await database();
    List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE proyectoId = $proyectoId and title LIKE '%$text%' and datetime >= $Dateini and datetime <= $Datefin");
    // List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE proyectoId = $proyectoId and title LIKE '%$text%'");
    return List.generate(reportMap.length, (index) {
      return Report(id: reportMap[index]['id'], proyectoId: reportMap[index]['proyectoId'], title: reportMap[index]['title'],  date: reportMap[index]['date'], count: reportMap[index]['count']);
    });
  }

  Future<Report?> getReport(int reportId) async {
    Database _db = await database();
    List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE id = $reportId");
    if (reportMap.isNotEmpty) {
      return Report(
        id: reportMap[0]['id'],
        proyectoId: reportMap[0]['proyectoId'],
        title: reportMap[0]['title'],
        date: reportMap[0]['date'],
        count: reportMap[0]['count'],
      );
    }
    return null; // return null if no report found
  }

  // Future<List<Report>> getReportsFiltered2(int proyectoId, String text) async {
  //   Database _db = await database();
  //   // List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE proyectoId = $proyectoId and title LIKE '%$text%' and date >= ");
  //   List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE proyectoId = $proyectoId and title LIKE '%$text%'");
  //   return List.generate(reportMap.length, (index) {
  //     return Report(id: reportMap[index]['id'], proyectoId: reportMap[index]['proyectoId'], title: reportMap[index]['title'],  date: reportMap[index]['date'], count: reportMap[index]['count']);
  //   });
  // }


  Future<List<Items>> getReportsItemsFiltered(int proyectoId, String text) async {
    Database _db = await database();
    // List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM reports WHERE proyectoId = $proyectoId and title LIKE '%$text%' and date >= ");
    List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT * FROM items WHERE proyectoId = $proyectoId and description LIKE '%$text%'");
    return List.generate(reportMap.length, (index) {
      return Items(id: reportMap[index]['id'], proyectoId: reportMap[index]['proyectoId'], reportId: reportMap[index]['reportId'], description: reportMap[index]['description'],  photo: reportMap[index]['photo'], count: reportMap[index]['count']);
    });
  }

  Future<List<Map<String, dynamic>>> getItemsWithReportInfo(int proyectoId, String text) async {
    Database _db = await database();
    return await _db.rawQuery("""
    SELECT items.id, items.description, items.proyectoId, items.reportId, items.photo, items.count,
           reports.title AS reportTitle, reports.date AS reportDate
    FROM items
    INNER JOIN reports ON items.reportId = reports.id
    WHERE items.proyectoId = $proyectoId 
      AND items.description LIKE '%$text%'
    ORDER BY reports.datetime DESC
  """);
  }

  Future<List<Report>> getDate(int id) async {
    Database _db = await database();
    List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT date FROM reports WHERE id = '$id'");
    return List.generate(reportMap.length, (index) {
      return Report(date: reportMap[index]['date']);
    });
  }

  Future<List<Items>> getItems(int reportId) async {
    Database _db = await database();
    List<Map<String, dynamic>> itemsMap = await _db.rawQuery("SELECT * FROM items WHERE reportId = $reportId");
    return List.generate(itemsMap.length, (index) {
      return Items(id: itemsMap[index]['id'], proyectoId: itemsMap[index]['proyectoId'], reportId: itemsMap[index]['reportId'], description: itemsMap[index]['description'], photo: itemsMap[index]['photo'], count: itemsMap[index]['count']);
    });
  }

  Future<List<Photos>> getItemPhotos(int itemId) async {
    Database _db = await database();
    List<Map<String, dynamic>> itemsMap = await _db.rawQuery("SELECT * FROM photos WHERE itemId = $itemId");
    return List.generate(itemsMap.length, (index) {
      return Photos(id: itemsMap[index]['id'], proyectoId: itemsMap[index]['proyectoId'], itemId: itemsMap[index]['itemId'], reportId: itemsMap[index]['reportId'], photo: itemsMap[index]['photo']);
    });
  }

  Future<List<Photos>> getSinglePhoto(int ID) async {
    Database _db = await database();
    List<Map<String, dynamic>> itemsMap = await _db.rawQuery("SELECT * FROM photos WHERE id = $ID");
    return List.generate(itemsMap.length, (index) {
      return Photos(id: itemsMap[index]['id'], proyectoId: itemsMap[index]['proyectoId'], itemId: itemsMap[index]['itemId'], reportId: itemsMap[index]['reportId'], photo: itemsMap[index]['photo']);
    });
  }

  Future<int?> getphotocount(int itemId) async {
    Database _db = await database();
    var x = await _db.rawQuery('SELECT COUNT(*) FROM photos WHERE itemId = $itemId');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }


  Future<List<Photos>> getReportPhotos(int reportId) async {
    Database _db = await database();
    List<Map<String, dynamic>> itemsMap = await _db.rawQuery("SELECT * FROM photos WHERE reportId = $reportId");
    return List.generate(itemsMap.length, (index) {
      return Photos(id: itemsMap[index]['id'], proyectoId: itemsMap[index]['proyectoId'], itemId: itemsMap[index]['itemId'], reportId: itemsMap[index]['reportId'], photo: itemsMap[index]['photo']);
    });
  }

  Future<List<Photos>> getProyectoPhotos(int proyectoId) async {
    Database _db = await database();
    List<Map<String, dynamic>> itemsMap = await _db.rawQuery("SELECT * FROM photos WHERE proyectoId = $proyectoId");
    return List.generate(itemsMap.length, (index) {
      return Photos(id: itemsMap[index]['id'], proyectoId: itemsMap[index]['proyectoId'], itemId: itemsMap[index]['itemId'], reportId: itemsMap[index]['reportId'], photo: itemsMap[index]['photo']);
    });
  }


    Future<List> getLogo(int proyectoId) async {
    Database _db = await database();
    // List x = await _db.rawQuery("SELECT * FROM proyectos WHERE id = '$proyectoId'");
    // return x;
    List<Map<String, dynamic>> xMap = await _db.rawQuery("SELECT * FROM proyectos WHERE id = '$proyectoId'");
    return List.generate(xMap.length, (index) {
      return Proyecto(id: xMap[index]['id'], title: xMap[index]['title'], count: xMap[index]['count'], photo: xMap[index]['photo']);
    });
  }

  Future<String?> getLogoPath(int proyectoId) async {
    final db = await database();
    final result = await db.rawQuery("SELECT photo FROM proyectos WHERE id = ?", [proyectoId]);
    if (result.isNotEmpty && result[0]['photo'] != null) {
      return result[0]['photo'] as String;
    }
    return null;
  }

  Future<void> deletePhoto(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM photos WHERE id = '$id'");
  }

  Future<void> deleteLogo(int proyectoId) async {
    String?  del = "";
    Database _db = await database();
    // await _db.rawDelete("DELETE FROM logo WHERE proyectoId = $proyectoId");
    await _db.rawDelete("UPDATE proyectos SET photo = '$del' WHERE id = '$proyectoId'");
  }

  Future<void> deleteItem(int id, int reportId) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM items WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM photos WHERE itemId = '$id'");
    await _db.rawQuery("UPDATE reports SET count = (count - 1) WHERE id = '$reportId'");
    // await _db.rawDelete("DELETE FROM items WHERE reportId = '$reportId' and id = '$id'");
  }

  Future<void> deleteReport(int id, int proyectoId) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM reports WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM items WHERE reportId = '$id'");
    await _db.rawDelete("DELETE FROM photos WHERE reportId = '$id'");
    await _db.rawQuery("UPDATE proyectos SET count = (count - 1) WHERE id = '$proyectoId'");
  }

  Future<void> deleteProyecto(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM proyectos WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM reports WHERE proyectoId = '$id'");
    await _db.rawDelete("DELETE FROM items WHERE proyectoId = '$id'");
    await _db.rawDelete("DELETE FROM photos WHERE proyectoId = '$id'");
    await _db.rawDelete("DELETE FROM logo WHERE proyectoId = '$id'");
  }

  // Future<Foto> saveFoto(int id, String foto) async {
  //   Database _db = await database();
  //   await _db.rawUpdate("UPDATE items SET photo = '$foto' WHERE id = '$id'");
  //   // var dbClient = await db;
  //   // foto.id = await dbClient.insert(TABLE, foto.toMap());
  //   // return foto;
  // }

  Future<Foto> savePhoto(int id, String foto) async {
    Database _db = await database();
    // await _db.rawUpdate("UPDATE items SET photo = '$foto' WHERE id = '$id'");
    await _db.rawUpdate("UPDATE photos SET photo = '$foto' WHERE id = '$id'");
    throw 'Error al salvar foto';
  }

  Future<void> saveLogo(int id, String foto) async {
    try {
      Database _db = await database();
      // Ensure that the path is properly escaped and handled to avoid SQL injection.
      String escapedFoto = foto.replaceAll("'", "''");  // Escape single quotes in the path string
      int result = await _db.rawUpdate(
        "UPDATE proyectos SET photo = '$foto' WHERE id = '$id'");
      print(foto);

      if (result == 0) {
        throw 'Error: Logo not updated. Ensure the project ID exists.';
      }
    } catch (e) {
      print('Error while saving logo: $e');
      throw 'Error al salvar logo';
    }
  }


// Future<List<Items>> getPhoto(int id) async {
  //   Database _db = await database();
  //   List<Map<String, dynamic>> reportMap = await _db.rawQuery("SELECT photo FROM items WHERE id = '$id'");
  //   return List.generate(reportMap.length, (index) {
  //     return Items(photo: reportMap[index]['photo']);
  //   });
  // }
}