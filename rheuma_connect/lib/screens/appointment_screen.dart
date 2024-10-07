import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'medical_records_screen.dart';
import 'information_hub_screen.dart';
// import 'appointments_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
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
                  context.read<AuthProvider>().logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem(
                  value: 'Medical Records',
                  child: Text('Medical Records'),
                ),
                const PopupMenuItem(
                  value: 'Information Hub',
                  child: Text('Information Hub'),
                ),
                const PopupMenuItem(
                  value: 'Appointments',
                  child: Text('Appointments'),
                ),
                const PopupMenuItem(
                  value: 'Home',
                  child: Text('Home'),
                ),
                const PopupMenuItem(
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
        child: Column(
          children: [
            _buildAppointmentCard(
              'Next Appointment',
              '2024 - 09 - 21',
              '03.45 PM',
              'Dr. Kamal Perera',
              'B526',
            ),
            const SizedBox(height: 20),
            _buildAppointmentCard(
              'Last Appointment',
              '2024 - 05 - 19',
              '03.45 PM',
              'Dr. Namal Udara',
              'B412',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle request for a new appointment
              },
              child: const Text('Request a new Appointment Date'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(String title, String date, String time,
      String consultant, String roomNo) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Consultant: $consultant'),
            Text('Room No: $roomNo'),
          ],
        ),
      ),
    );
  }
}
