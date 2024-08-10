
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v1/model/models.dart';

class DatabaseService {
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  //Database initialisation
  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = getDirectory.path + '/students.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    // Create the Student table
    await db.execute(
      'CREATE TABLE Student(mat TEXT PRIMARY KEY, nom TEXT, payed_amount DOUBLE)',
    );

    // Create the VerificationAmount table
    await db.execute(
      'CREATE TABLE VerificationAmount(amount DOUBLE)',
    );

    log('TABLES CREATED');
  }

  //Retrieve all students stored locally
  Future<List<Student>> getStudents() async {
    final db = await _databaseService.database;
    var data = await db.rawQuery('SELECT * FROM Student');
    List<Student> students =
    List.generate(data.length, (index) => Student.fromJson(data[index]));
    print(students.length);
    return students;
  }

  // Inserting a list of student

  Future<void> insertStudent(List<Student> students) async {
    final db = await _databaseService.database;

    //Getting current list
    List<Student> localList  = getStudents() as List<Student> ;

    for (Student student in students) {

      //insert only new data

      if( !(localList.contains(student)) ) {
        var data = await db.rawInsert(
            'INSERT INTO Movies(mat, name, payed_amount ) VALUES(?,?,?,?)',
            [student.studentID, student.name, student.name]);
        log('inserted $data');

      }
    }
  }



}




//TODO : USE STUDENT ID TO GET THE STUDENT LOCALLY
//TODO : SAVE THE VERIFICATION AMOUNT LOCALLY
//TODO : PERFORM  A TEST USING THE "payed amount" and the "verification amount saved locally"

