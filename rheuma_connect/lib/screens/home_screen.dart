import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'profile_screen.dart';
import 'appointment_screen.dart';
import 'information_hub_screen.dart';
import 'medical_records_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Open drawer or menu
          },
        ),
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
                case 'Appointments':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentScreen()),
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
                case 'Logout':
                  context.read<AuthProvider>().logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
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
                  value: 'Appointments',
                  child: Text('Appointments'),
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
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting section with profile image
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/default_profile.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hello James,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'Good Evening...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),

              // Next Appointment section
              Text(
                'Next Appointment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              _buildAppointmentCard(
                '2024 - 09 - 21',
                '03.45 PM',
                'Dr. Kamal Perera',
                'B526',
              ),
              const SizedBox(height: 20),

              // Read more section
              Row(
                children: [
                  const Text(
                    'Like to Read more on Rheumatic?',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to the article or related info
                    },
                    icon: Icon(Icons.article),
                    label: Text('Read More...'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent, // Updated
                      foregroundColor: Colors.white, // Updated
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Floating Message Button (like a Chat or Message option)
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    // Handle message button press
                  },
                  backgroundColor: Colors.green,
                  child: Icon(Icons.message),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Appointment card widget
  Widget _buildAppointmentCard(
      String date, String time, String consultant, String roomNo) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: $date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text('Time: $time'),
            Text('Consultant: $consultant'),
            Text('Room No: $roomNo'),
          ],
        ),
      ),
    );
  }
}
