import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:v1/model/models.dart'; // Ensure this path is correct
import 'package:v1/services/services.dart'; // Ensure this path is correct

class SyncService {
  // Synchronize local database with remote server
  Future<void> synchronizeWithServer(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(endpoint));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Convert JSON data to List<Student>
        List<Student> students = data
            .map((json) => Student.fromJson(json))
            .toList();

        // Get the database service instance and insert students into local database
        final databaseService = DatabaseService();
        await databaseService.insertStudent(students);
        log('Synchronization completed successfully');
      } else {
        log('Failed to fetch data from server  ${response.statusCode}');
      }
    } catch (e) {
      log('Error during synchronization: $e');
    }
  }
}
