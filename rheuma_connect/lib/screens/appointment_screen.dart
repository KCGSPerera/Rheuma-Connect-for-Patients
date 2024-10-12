import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';
import '../providers/patient_provider.dart';
import 'view_patient_profile.dart';
import 'medical_records_screen.dart';
import 'information_hub_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:intl/intl.dart'; // For formatting date

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  bool _isLoading = true; // State to track if the appointments are loading

  @override
  void initState() {
    super.initState();
    // Fetch the scheduled appointments when the screen is first loaded
    _loadAppointments();
  }

  void _loadAppointments() async {
    final patientProvider =
        Provider.of<PatientProvider>(context, listen: false);
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    final patient = patientProvider.patient;
    if (patient != null) {
      await appointmentProvider.getAllAppointmentsByPatientId(patient.id);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final patient = patientProvider.patient;

    return Scaffold(
      backgroundColor: Color(0xFFDAFDF9), // Set the background color to DAFDF9
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.blueAccent, // Apply blue color here
        elevation: 0, // Flat appearance, no shadow for AppBar
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewPatientProfileScreen()),
                  );
                  break;
                case 'Medical Records':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MedicalRecordsScreen()),
                  );
                  break;
                case 'Information Hub':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InformationHubScreen()),
                  );
                  break;
                case 'Appointments':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentScreen()),
                  );
                  break;
                case 'Home':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                  break;
                case 'Logout':
                  context.read<PatientProvider>().logout(context).then((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  });
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                PopupMenuItem(
                  value: 'Medical Records',
                  child: Text('Medical Records'),
                ),
                PopupMenuItem(
                  value: 'Information Hub',
                  child: Text('Information Hub'),
                ),
                PopupMenuItem(
                  value: 'Appointments',
                  child: Text('Appointments'),
                ),
                PopupMenuItem(
                  value: 'Home',
                  child: Text('Home'),
                ),
                PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<AppointmentProvider>(
                builder: (context, provider, child) {
                  final appointments = provider.allAppointments;

                  if (appointments == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (appointments.isEmpty) {
                    return const Center(
                        child: Text('No scheduled appointments.'));
                  }

                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return _buildAppointmentCard(
                        'Completed Appointment',
                        appointment.date != null
                            ? DateFormat('yyyy-MM-dd').format(appointment.date)
                            : 'No upcoming appointment',
                        appointment.time,
                        'Dr. ${appointment.consultant ?? 'No Consultant'}', // Ensure the consultant's name is present
                        appointment.roomNo,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildAppointmentCard(String title, String date, String time,
      String consultant, String roomNo) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.date_range,
                    color: Colors.blue), // Set icon color to blue
                const SizedBox(width: 10),
                Text(
                  'Date: $date',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time,
                    color: Colors.blue), // Set icon color to blue
                const SizedBox(width: 10),
                Text(
                  'Time: $time',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person,
                    color: Colors.blue), // Set icon color to blue
                const SizedBox(width: 10),
                Text(
                  'Consultant: $consultant',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.meeting_room,
                    color: Colors.blue), // Set icon color to blue
                const SizedBox(width: 10),
                Text(
                  'Room No: $roomNo',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
