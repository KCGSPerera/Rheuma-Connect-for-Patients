import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';

class ApiService {
  final String baseUrl =
      'http://192.168.56.1:3001/api'; // Change to your backend's IP address

  // Register a new patient
  Future<http.Response> registerPatient(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Store token locally
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
    }

    return response;
  }

// Login a patient
  Future<void> loginPatient(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse response and store the token
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  // Fetch patient details
  Future<Patient> fetchPatientDetails(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/patients/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body)['patient']);
    } else {
      throw Exception('Failed to load patient details');
    }
  }

  // Future<Patient> fetchPatientDetails(String id) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/patients/$id'),
  //     headers: {
  //       'Authorization':
  //           'Bearer YOUR_JWT_TOKEN', // Make sure token is provided if needed
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // Convert the response to Patient object
  //     return Patient.fromJson(jsonDecode(response.body)['patient']);
  //   } else {
  //     throw Exception('Failed to load patient details');
  //   }
  // }

  // Update patient profile (with profile photo)
  Future<http.Response> updatePatientProfile(
      String id, Map<String, String> data, String? profilePhotoPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    var request =
        http.MultipartRequest('PUT', Uri.parse('$baseUrl/patients/$id/update'));
    request.headers['Authorization'] = 'Bearer $token';

    if (profilePhotoPath != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profilePhoto', profilePhotoPath));
    }

    data.forEach((key, value) {
      request.fields[key] = value;
    });

    final response = await request.send();
    return http.Response.fromStream(response);
  }
}

// import 'package:shared_preferences/shared_preferences.dart';

// Logout a patient
Future<void> logoutPatient() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove the stored token
  bool result = await prefs.remove('token');

  if (result) {
    print("Token removed successfully. User logged out.");
  } else {
    throw Exception("Failed to remove token.");
  }
}
