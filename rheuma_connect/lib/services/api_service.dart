import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';
import '../models/appointment.dart';
import '../models/info_hub.dart';
import '../models/medical_record.dart'; // Import medical_record model

class ApiService {
  final String baseUrl =
      'https://rheuma-bakend-git-main-hansanis-projects.vercel.app/api'; // Replace with your backend's IP address

  // Login a patient
  Future<Map<String, dynamic>> loginPatient(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
      return data; // Return the entire response body
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  // Register a new patient
  Future<http.Response> registerPatient(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']); // Save token locally
    }

    return response;
  }

  // Fetch patient details
  Future<Patient> fetchPatientDetails(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/patients/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body)['patient']);
    } else {
      throw Exception('Failed to load patient details');
    }
  }

  // Update patient profile
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

  // =======================
  // APPOINTMENT FUNCTIONS
  // =======================

  //
  // New Method: Get last appointment for the patient
  Future<Appointment> getLastAppointmentForPatient(String patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/appointments/patient/$patientId/last-appointment'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final appointmentData = jsonDecode(response.body)['appointment'];
      return Appointment.fromJson(appointmentData);
    } else {
      throw Exception('Failed to load last appointment');
    }
  }

  // Fetch last appointment for a patient
  Future<Appointment> getLastAppointment(String patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/appointments/patient/$patientId/last'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Appointment.fromJson(jsonDecode(response.body)['appointment']);
    } else {
      throw Exception('Failed to fetch last appointment');
    }
  }

  // Fetch all appointments for the logged-in patient
  Future<List<Appointment>> getAllAppointments(String patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/appointments/patient/$patientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> appointmentsJson =
          jsonDecode(response.body)['appointments'];
      return appointmentsJson
          .map((json) => Appointment.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  // This is the api called for get the appointment date

  // // Fetch scheduled appointments by patient ID
  // Future<List<Appointment>> getScheduledAppointmentsByPatientId(
  //     String patientId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/appointments/scheduled/patient/$patientId'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> appointmentsJson =
  //         jsonDecode(response.body)['appointments'];
  //     return appointmentsJson
  //         .map((json) => Appointment.fromJson(json))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to fetch scheduled appointments');
  //   }
  // }

  // Fetch scheduled appointments by patient ID
  Future<List<Appointment>> getScheduledAppointmentsByPatientId(
      String patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/appointments/scheduled/patient/$patientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> appointmentsJson = jsonDecode(response.body);
      return appointmentsJson
          .map((json) => Appointment.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch scheduled appointments');
    }
  }

  // Fetch scheduled appointments by patient ID
  Future<List<Appointment>> getAllAppointmentsByPatientId(
      String patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/appointments/all/patient/$patientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> appointmentsJson = jsonDecode(response.body);
      return appointmentsJson
          .map((json) => Appointment.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch scheduled appointments');
    }
  }

  // =======================
  // INFO HUB FUNCTIONS
  // =======================
  // Fetch all articles
  // Future<List<InfoHub>> getAllArticles() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/infoHub/all'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> articlesJson = jsonDecode(response.body)['articles'];
  //     return articlesJson.map((json) => InfoHub.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to fetch articles');
  //   }
  // }

  // // Filter articles by name or category
  // Future<List<InfoHub>> filterArticles(String searchQuery) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/infoHub/filter?searchQuery=$searchQuery'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> articlesJson = jsonDecode(response.body)['articles'];
  //     return articlesJson.map((json) => InfoHub.fromJson(json)).toList();
  //   } else {
  //     throw Exception('No matching articles found');
  //   }
  // }

  // ========================
  // Corrct Infor Hub api s
  // ========================

  // Fetch all info articles
  Future<List<InfoHub>> getAllInfoArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/infoHub/all'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> articlesJson =
          jsonDecode(response.body)['data']; // Access 'data' field
      // List<dynamic> articlesJson = jsonDecode(response.body)['articles'];
      return articlesJson.map((json) => InfoHub.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch info articles');
    }
  }

  // Fetch an info article by ID
  Future<InfoHub> getInfoArticleById(String articleId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/infoHub/$articleId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return InfoHub.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to fetch info article');
    }
  }

  // Filter articles by name, category, or description
  Future<List<InfoHub>> filterInfoArticles(String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/infoHub/filter?searchQuery=$searchQuery'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> articlesJson = jsonDecode(response.body)['articles'];
      return articlesJson.map((json) => InfoHub.fromJson(json)).toList();
    } else {
      throw Exception('No matching articles found');
    }
  }

  // =======================
  // MEDICAL RECORD FUNCTIONS
  // =======================
  Future<List<MedicalRecord>> getAllMedicalRecords(String patientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/medicalRecords/get-all-records/$patientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> recordsJson = jsonDecode(response.body);
      return recordsJson.map((json) => MedicalRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch medical records');
    }
  }

  // =======================
  // LOGOUT FUNCTION
  // =======================
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
}
