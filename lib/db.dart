import 'globals.dart' as globals;

import 'Score.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

class DB{

  Future<Database> _openDB() async{
    return openDatabase(join(await getDatabasesPath(),
      'Score.db'), 
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE Score (id INTEGER PRIMARY KEY, points INTEGER)",
        );
      }
    );

    print("DB inicializada");
  }

  Future<void> insert(Score score) async {
    Database database=await _openDB();

    print( await database.insert("Score", score.toMap()));
  }

  Future<void> delete(Score score) async{
    Database database=await _openDB();

    database.delete("Score",where: "id = ?", whereArgs: [score.id]);
  }

  Future<void> update(Score score) async{
    Database database=await _openDB();

    database.update("Score", score.toMap(), where: "id = ?", whereArgs: [score.id]);
  }

  Future<void> score() async{
    Database database=await _openDB();

    final List<Map<String, dynamic>> scoreMap = await database.query("Score");

    print("Got: ${scoreMap.length}");

    var s= List.generate(scoreMap.length, (i) => Score(
      id: scoreMap[i]['id'], 
      points: scoreMap[i]['points'])
    );

    if (s.isNotEmpty) {
      globals.lastpoint=s.last;
      Score a=Score(id: 0, points: 0);
      for(var x in s){
        if(x.points>a.points){
          a=x;
        }
      }
      globals.pointers=a;
    }
    
    
  }
}