import 'package:v1/model/models.dart';
import 'package:v1/services/services.dart';

class Verification {
   final DatabaseService _databaseService = DatabaseService();

   Future<bool> checkStudent(int studentID) async {
     /**
      * This function takes the studentID as a parameter and returns whether the student is in order or not.
      * The process is as follows:
      * 1. Retrieve the student by ID.
      * 2. Get the amount the student has already paid.
      * 3. Get the verification amount required.
      * 4. Check if the paid amount matches the verification amount.
      * The return type is a boolean and will be used to design the result pages.
      */
     try {
       // Retrieve the student by ID from the database

       final Student? student = await _databaseService.getStudentByID(studentID);
       if (student == null) {
         // Handle the case where the student is not found
         print("Student with ID $studentID not found.");
         return false;
       }

       // Get the required verification amount from the database
       final int verificationAmount = await _databaseService.getAmount();

       // Check if the student's paid amount matches the required verification amount
       return  (student.payedAmount ?? 0) >= (verificationAmount ?? 0);
     } catch (e) {
       // Handle any errors by logging them and returning false
       print("Error retrieving student or amount: $e");
       return false;
     }
   }




}