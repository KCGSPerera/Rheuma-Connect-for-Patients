import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/api_service.dart';

class PatientProvider with ChangeNotifier {
  Patient? _patient;
  final ApiService _apiService = ApiService();

  Patient? get patient => _patient;

  // Future<void> register(String username, String email, String password) async {
  //   await _apiService.registerPatient(username, email, password);
  //   notifyListeners();
  // }

  // Future<void> login(String email, String password) async {
  //   await _apiService.loginPatient(email, password);
  //   notifyListeners();
  // }

  Future<void> login(String email, String password) async {
    try {
      await _apiService.loginPatient(email, password);
      notifyListeners();
    } catch (error) {
      print("Login error: $error"); // Log the error
      throw error;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      // Log the registration attempt
      print('Attempting to register user: $username, $email');
      final response =
          await _apiService.registerPatient(username, email, password);

      if (response.statusCode == 201) {
        print('Registration successful');
      } else {
        print('Registration failed: ${response.statusCode}');
        throw Exception('Registration failed');
      }

      notifyListeners();
    } catch (error) {
      print("Registration error: $error"); // Log the error
      throw error;
    }
  }

  Future<void> fetchPatient(String patientId) async {
    try {
      // Call the API to fetch the patient details
      _patient = await _apiService.fetchPatientDetails(patientId);
      notifyListeners();
    } catch (error) {
      print('Failed to fetch patient details: $error');
    }
  }

  Future<void> updateProfile(
      String id, Map<String, String> data, String? profilePhotoPath) async {
    try {
      await _apiService.updatePatientProfile(id, data, profilePhotoPath);
      // Re-fetch patient data after update
      await fetchPatient(id);
    } catch (error) {
      print('Error updating profile: $error');
    }
  }

  // Future<void> fetchPatient(String id) async {
  //   _patient = await _apiService.fetchPatientDetails(id);
  //   notifyListeners();
  // }

  // Future<void> updateProfile(
  //     String id, Map<String, String> data, String? profilePhotoPath) async {
  //   await _apiService.updatePatientProfile(id, data, profilePhotoPath);
  //   fetchPatient(id);
  //   notifyListeners();
  // }
}
