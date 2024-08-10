
import 'dart:developer';
import 'dart:ffi';
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
    String path = '${getDirectory.path}/students.db';
    log(path);
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    // Create the Student table
    await db.execute(
      'CREATE TABLE Student(mat INT PRIMARY KEY, name TEXT, payed_amount DOUBLE)',
    );

    // Create the VerificationAmount table
    await db.execute(
      'CREATE TABLE VerificationAmount(amount DOUBLE)',
    );

    log('TABLES CREATED');
  }




  // Retrieve all students stored locally
  Future<List<Student>> getStudents() async {
    final db = await _databaseService.database;
    var data = await db.rawQuery('SELECT * FROM Student');
    print(data);
    List<Student> students = data.map((json) => Student.fromJson(json)).toList();
    print(students.length);
    return students;
  }

  //Update student
  Future<void> editStudent(Student student) async {
    final db = await _databaseService.database;
    var data = await db.rawUpdate(
        'UPDATE Student SET name=?,payed_amount=? WHERE mat=?',
        [student.name, student.payedAmount,  student.studentID]);
    log('updated $data');
  }

  //select a student by id
  Future<Student?> getStudentByID(int studentID) async {
    final db = await _databaseService.database;

    // Execute the query to find the student by ID
    var data = await db.rawQuery(
      'SELECT * FROM Student WHERE mat = ?',
      [studentID],
    );

    // Check if any data is returned
    if (data.isNotEmpty) {
      // Convert the first result into a Student object
      return Student.fromJson(data.first);
    } else {
      // Return null if no student was found
      return null;
    }
  }

  Future<double> getAmount() async {
    final db = await _databaseService.database;

    // Execute the query to get the amount to verify
    var data = await db.rawQuery(
      'SELECT amount FROM VerificationAmount '
    );
    return VerificationAmount.fromJson(data.first).amount;

  }





  // Insert a list of students
  Future<void> insertStudent(List<Student> students) async {
    final db = await _databaseService.database;

    // Getting current list
    List<Student> localList = await getStudents(); // Await the result
    print(localList);

    for (Student student in students) {
      // Insert only new data
      if (!localList.any((localStudent) => localStudent.studentID == student.studentID)) {
        var data = await db.rawInsert(
          'INSERT INTO Student(mat, name, payed_amount) VALUES(?, ?, ?)', // Corrected the number of placeholders
          [student.studentID, student.name, student.payedAmount],
        ) ;
        log('inserted $data');
      } else  {
        //if the student exists update
        editStudent(student);
      }
    }
  }

  // Insert or update amount
  Future<void> setAmount(double amount) async {
    final db = await _databaseService.database;

    // Check if an amount already exists
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM VerificationAmount'));

    if (count! > 0) {
      // Update the existing amount
      await db.update(
        'VerificationAmount',
        {'amount': amount},
        where: 'rowid = ?',
        whereArgs: [1], // Assume there's only one row
      );
    } else {
      // Insert a new amount
      await db.insert(
        'VerificationAmount',
        {'amount': amount},
      );
    }
  }


}




