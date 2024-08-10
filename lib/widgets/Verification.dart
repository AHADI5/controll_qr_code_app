import 'package:v1/model/models.dart';
import 'package:v1/services/services.dart';

class Verification {
   final DatabaseService _databaseService = DatabaseService();

   Future<bool> checkStudent(int studentID) async {
     /**
      * this function takes the studentID in parameter , and return wether he is in order or not
      * we first retrieve the student
      * get his amount already payed ,
      * get the verification amount
      * and then check
      * the return type is a boolean
      * and will be used to design , result pages
      *
      * */
     try {
       final Student? student = await _databaseService.getStudentByID(studentID);
       if (student == null) {
         // Handle the case where the student is not found
         print("Student with ID $studentID not found.");
         return false;
       }

       final double amount = await _databaseService.getAmount();
       return student.payedAmount == amount;
     } catch (e) {
       // Handle the error by logging it and returning false
       print("Error retrieving student: $e");
       return false;
     }
   }



}