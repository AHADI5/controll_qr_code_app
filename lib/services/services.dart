
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
    await db.execute(
      'CREATE TABLE Student(mat INT PRIMARY KEY, name TEXT, payed_amount DOUBLE)',
    );
    // Create the VerificationAmount table with an id as the primary key
    await db.execute(
      'CREATE TABLE IF NOT EXISTS VerificationAmount('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, ' // Primary key
          'amount DOUBLE)',
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
      print("the student found is ${Student.fromJson(data.first).name}");
      return Student.fromJson(data.first);
    } else {
      // Return null if no student was found
      print("no student found with matricule $studentID");
      return null;
    }
  }

  Future<double> getAmount() async {
    final db = await _databaseService.database;

    // Execute the query to get the amount to verify
    var data = await db.rawQuery(
      'SELECT amount FROM VerificationAmount WHERE id = ?',
      [1], // Assuming you are still using the first row (id = 1)
    );

    if (data.isNotEmpty) {
      print("the actual amount is   ${VerificationAmount.fromJson(data.first).amount}");
      return VerificationAmount.fromJson(data.first).amount;
    } else {
      throw Exception('No amount found');
    }
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

  // this method insert a new amount , or update it if it already exists

  Future<void> setAmount(double amount) async {
    final db = await _databaseService.database;

    //get the actual value
    var data = await db.rawQuery(
      'SELECT amount FROM VerificationAmount WHERE id = ?',
      [1], // Assuming you are still using the first row (id = 1)
    );

    if (data.isNotEmpty) {
      await db.update(
        'VerificationAmount',
        {'amount': amount},
        where: 'id = ?', // Use the id field
        whereArgs: [1], // Assuming there's only one row
      );
      print("amount exists and has been  updated") ;
    } else {
      await db.insert(
        'VerificationAmount',
        {'amount': amount},
      );
      print("no amount found , new one has been inserted ") ;
    }
  }






}




