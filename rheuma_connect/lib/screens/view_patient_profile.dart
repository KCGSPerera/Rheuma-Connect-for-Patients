import 'package:flutter/material.dart';
import 'package:rheuma_connect/screens/appointment_screen.dart';
import '../providers/patient_provider.dart';
import 'update_profile_screen.dart';
import 'medical_records_screen.dart';
import 'information_hub_screen.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class ViewPatientProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final patient = patientProvider.patient;

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set the background color to DAFDF9
      appBar: AppBar(
        backgroundColor: Colors.blue[600], // Darker blue for app bar
        title: const Text(
          'Patient Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                        builder: (context) => const AppointmentScreen()),
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
      body: patient == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header with rounded avatar and name
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue[100],
                            backgroundImage: patient.profilePhoto != null
                                ? NetworkImage(
                                    'http://localhost:3001${patient.profilePhoto}')
                                : const AssetImage('assets/default_profile.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${patient.name ?? "Name not provided"}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${patient.age?.toString() ?? "Age not provided"} Years',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Profile Information",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildProfileCard(patient),
                    const SizedBox(height: 30),

                    // Edit Button with updated style
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          "EDIT PROFILE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Profile Information Card with rounded edges
  Widget _buildProfileCard(patient) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildProfileRow("Medical ID", patient.medicalId),
            buildProfileRow("Username", patient.username),
            buildProfileRow("Email", patient.email),
            buildProfileRow("Blood Type", patient.bloodType ?? "Select"),
            buildProfileRow("Contact", patient.contactNumber ?? "Not Provided"),
            buildProfileRow(
                "Member Since",
                patient.createdAt != null
                    ? patient.createdAt.toString().split(' ')[0]
                    : "Not Provided"),
            buildProfileRow(
                "Birth Date",
                patient.birthday != null
                    ? patient.birthday!.toString().split(' ')[0]
                    : "Not Provided"),
            buildProfileRow(
                "Rheumatic Type", patient.rheumaticType ?? "Select"),
            buildProfileRow("Age", patient.age?.toString() ?? "Not Provided"),
          ],
        ),
      ),
    );
  }

  // Helper function to build profile rows
  Widget buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
