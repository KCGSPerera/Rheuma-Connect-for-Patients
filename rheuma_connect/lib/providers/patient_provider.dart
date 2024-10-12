import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';
import '../services/api_service.dart';
import '../models/medical_record.dart'; // Import the medical record model
import '../models/info_hub.dart'; // Import the info hub model

class PatientProvider with ChangeNotifier {
  Patient? _patient;
  List<MedicalRecord> _medicalRecords = []; // List to hold medical records
  List<InfoHub> _infoArticles = []; // List to hold info articles
  final ApiService _apiService = ApiService();

  Patient? get patient => _patient;
  List<MedicalRecord> get medicalRecords =>
      _medicalRecords; // Getter for medical records
  List<InfoHub> get infoArticles => _infoArticles; // Getter for info articles

// Login function -> handelling token part modved to api_service
  Future<String> login(String email, String password) async {
    try {
      final response = await _apiService.loginPatient(email, password);

      // Ensure that we check for '_id' instead of 'patientId'
      final patientId = response['id'] ?? response['_id'];

      if (patientId == null) {
        throw Exception('No patientId returned in the login response');
      }

      notifyListeners();
      return patientId;
    } catch (error) {
      print("Login error: $error");
      throw error;
    }
  }

// Register function
  Future<void> register(String username, String email, String password) async {
    try {
      final response =
          await _apiService.registerPatient(username, email, password);

      if (response.statusCode == 201) {
        print('Registration successful');
      } else {
        throw Exception('Registration failed');
      }

      notifyListeners();
    } catch (error) {
      print("Registration error: $error");
      throw error;
    }
  }

// Fetch patient function
  Future<void> fetchPatient(String patientId) async {
    try {
      _patient = await _apiService.fetchPatientDetails(patientId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch patient details: $error');
    }
  }

// Update profile function
  Future<void> updateProfile(
      String id, Map<String, String> data, String? profilePhotoPath) async {
    try {
      await _apiService.updatePatientProfile(id, data, profilePhotoPath);
      await fetchPatient(id);
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

// Logout function
  Future<void> logout(BuildContext context) async {
    try {
      // Clear the saved token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      // Clear the patient data locally
      _patient = null;
      notifyListeners();

      // Redirect to the login page
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (error) {
      print('Error logging out: $error');
    }
  }

// Fetch all medical records for the patient
  Future<List<MedicalRecord>> getAllMedicalRecords(String patientId) async {
    try {
      final records = await _apiService.getAllMedicalRecords(patientId);
      // Assuming _medicalRecords is a local variable storing the records
      _medicalRecords = records;
      notifyListeners();
      return records; // Return the list of medical records
    } catch (error) {
      print('Failed to fetch medical records: $error');
      throw error;
    }
  }

  // Fetch all info articles
  Future<List<InfoHub>> getAllInfoArticles() async {
    try {
      final articles = await _apiService.getAllInfoArticles();
      print(articles);

      _infoArticles = articles;
      print(articles);

      notifyListeners();
      return articles;
    } catch (error) {
      print('Failed to fetch info articles: $error');
      throw error;
    }
  }

  // Fetch a specific info article by ID
  Future<InfoHub> getInfoArticleById(String articleId) async {
    try {
      final article = await _apiService.getInfoArticleById(articleId);
      return article;
    } catch (error) {
      print('Failed to fetch info article: $error');
      throw error;
    }
  }

  // Filter info articles by name, category, or description
  Future<List<InfoHub>> filterInfoArticles(String searchQuery) async {
    try {
      final filteredArticles =
          await _apiService.filterInfoArticles(searchQuery);
      _infoArticles = filteredArticles;
      notifyListeners();
      return filteredArticles;
    } catch (error) {
      print('Failed to filter info articles: $error');
      throw error;
    }
  }
}
