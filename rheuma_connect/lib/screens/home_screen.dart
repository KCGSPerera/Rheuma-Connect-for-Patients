import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rheuma_connect/providers/appointment_provider.dart';
import 'package:rheuma_connect/providers/patient_provider.dart';
import 'package:rheuma_connect/screens/login_screen.dart';
import 'package:rheuma_connect/screens/view_patient_profile.dart';
import 'appointment_screen.dart';
import 'information_hub_screen.dart';
import 'medical_records_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true; // State to track if the appointment is loading

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
      await appointmentProvider.getScheduledAppointmentsByPatientId(patient.id);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final patient = patientProvider.patient;
    String firstName = patient != null && patient.name != null
        ? patient.name!.split(' ')[0]
        : "Dear"; // Fallback to "Dear" if patient name is not available

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        backgroundColor: const Color(0xFFADD8E6), // Light blue color
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer on press
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildDrawerItem(
                Icons.person, 'Profile', ViewPatientProfileScreen()),
            _buildDrawerItem(
                Icons.calendar_today, 'Appointments', AppointmentScreen()),
            _buildDrawerItem(Icons.medical_services, 'Medical Records',
                MedicalRecordsScreen()),
            _buildDrawerItem(
                Icons.info, 'Information Hub', InformationHubScreen()),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 23),
              ),
              onTap: () async {
                await context
                    .read<PatientProvider>()
                    .logout(context); // Use logout function
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50.0, // Slightly move content lower on the screen
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User greeting section with profile image
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/default_profile.png'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, $firstName...',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Next Appointment section
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.blue, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        'Next Appointment',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Consumer<AppointmentProvider>(
                          builder: (context, provider, child) {
                            final appointments = provider.scheduledAppointments;
                            if (appointments == null || appointments.isEmpty) {
                              return _buildInfoCard(
                                  'No upcoming appointment available.');
                            }

                            final nextAppointment = appointments.first;
                            return _buildAppointmentCard(
                              DateFormat('yyyy-MM-dd')
                                  .format(nextAppointment.date),
                              nextAppointment.time,
                              'Dr. ${nextAppointment.consultant}',
                              nextAppointment.roomNo,
                            );
                          },
                        ),
                  const SizedBox(height: 20),

                  // Centered Read More Section
                  Center(
                    child: Column(
                      children: [
                        const Icon(Icons.article,
                            color: Colors.green, size: 40),
                        const SizedBox(height: 10),
                        Text(
                          'Like to Read more on Rheumatic?',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InformationHubScreen()),
                            );
                          },
                          icon: const Icon(Icons.article,
                              size: 18, color: Colors.white),
                          label: const Text(
                            'Read More...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Move section a little lower
                ],
              ),
            ),
          ),

          // Floating Message Button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  // Handle message button press
                },
                backgroundColor: Colors.green,
                child: const Icon(Icons.message),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Appointment card widget
  Widget _buildAppointmentCard(
      String date, String time, String consultant, String roomNo) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRowWithIcon(Icons.event, 'Date: $date'),
              const SizedBox(height: 8),
              _buildRowWithIcon(Icons.access_time, 'Time: $time'),
              const SizedBox(height: 8),
              _buildRowWithIcon(Icons.person, 'Consultant: $consultant'),
              const SizedBox(height: 8),
              _buildRowWithIcon(Icons.meeting_room, 'Room No: $roomNo'),
            ],
          ),
        ),
      ),
    );
  }

  // Info card for no appointments or error messages
  Widget _buildInfoCard(String message) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  // Drawer item widget
  Widget _buildDrawerItem(IconData icon, String title, Widget targetScreen) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(fontSize: 23),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
    );
  }

  // Helper method to build a row with icon and text
  Widget _buildRowWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
