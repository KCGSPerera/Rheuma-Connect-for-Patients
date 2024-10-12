import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/api_service.dart';

class AppointmentProvider with ChangeNotifier {
  Appointment? _lastAppointment;
  List<Appointment> _scheduledAppointments =
      []; // List to hold scheduled appointments
  List<Appointment> _allAppointments =
      []; // List to hold scheduled appointments

  final ApiService _apiService = ApiService();

  Appointment? get lastAppointment => _lastAppointment;
  List<Appointment> get scheduledAppointments =>
      _scheduledAppointments; // Getter for scheduled appointments
  List<Appointment> get allAppointments =>
      _allAppointments; // Getter for scheduled appointments

  // Fetch last appointment
  Future<void> fetchLastAppointment(String patientId) async {
    try {
      _lastAppointment =
          await _apiService.getLastAppointmentForPatient(patientId);
      notifyListeners();
    } catch (error) {
      print('Error fetching last appointment: $error');
      throw error;
    }
  }

  // Fetch scheduled appointments by patient ID
  Future<void> getScheduledAppointmentsByPatientId(String patientId) async {
    try {
      _scheduledAppointments =
          await _apiService.getScheduledAppointmentsByPatientId(patientId);
      notifyListeners();
    } catch (error) {
      print('Error fetching scheduled appointments: $error');
      throw error;
    }
  }

  // Fetch scheduled appointments by patient ID
  Future<void> getAllAppointmentsByPatientId(String patientId) async {
    try {
      _allAppointments =
          await _apiService.getAllAppointmentsByPatientId(patientId);
      notifyListeners();
    } catch (error) {
      print('Error fetching appointments: $error');
      throw error;
    }
  }
}
