import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import 'view_patient_profile.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedBloodType = 'Select';
  String? _selectedRheumaticType = 'Select';

  @override
  void initState() {
    super.initState();
    final patient =
        Provider.of<PatientProvider>(context, listen: false).patient;
    if (patient != null) {
      _nameController.text = patient.name ?? '';
      _birthdayController.text = patient.birthday ?? '';
      _usernameController.text = patient.username;
      _emailController.text = patient.email;
      _phoneController.text = patient.contactNumber ?? '';
      _selectedBloodType = patient.bloodType ?? 'Select';
      _selectedRheumaticType = patient.rheumaticType ?? 'Select';
      _ageController.text = patient.age?.toString() ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      backgroundColor:
          const Color(0xFFDAFDF9), // Set background color to DAFDF9
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: const Text(
          'Update Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (patientProvider.patient?.profilePhoto != null
                                      ? NetworkImage(
                                          'http://localhost:3001${patientProvider.patient!.profilePhoto}')
                                      : const AssetImage(
                                          'assets/default_profile.png'))
                                  as ImageProvider,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue[600],
                          child:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextFormField('Name', _nameController),
                _buildTextFormField('Birthday', _birthdayController),
                _buildTextFormField('Username', _usernameController),
                _buildTextFormField('Email', _emailController),
                _buildTextFormField('Phone', _phoneController),
                const SizedBox(height: 20),
                _buildDropdown(
                  'Blood Type',
                  _selectedBloodType,
                  ['Select', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                  (String? newValue) {
                    setState(() {
                      _selectedBloodType = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  'Rheumatic Type',
                  _selectedRheumaticType,
                  ['Select', 'Type 1', 'Type 2', 'Type 3', 'Type 4'],
                  (String? newValue) {
                    setState(() {
                      _selectedRheumaticType = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildTextFormField('Age', _ageController),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final updatedData = {
                      'name': _nameController.text.isNotEmpty
                          ? _nameController.text
                          : '',
                      'birthday': _birthdayController.text.isNotEmpty
                          ? _birthdayController.text
                          : '',
                      'username': _usernameController.text.isNotEmpty
                          ? _usernameController.text
                          : '',
                      'email': _emailController.text.isNotEmpty
                          ? _emailController.text
                          : '',
                      'contactNumber': _phoneController.text.isNotEmpty
                          ? _phoneController.text
                          : '',
                      'bloodType': _selectedBloodType != null &&
                              _selectedBloodType != 'Select'
                          ? _selectedBloodType!
                          : 'Select',
                      'rheumaticType': _selectedRheumaticType != null &&
                              _selectedRheumaticType != 'Select'
                          ? _selectedRheumaticType!
                          : 'Select',
                      'age': _ageController.text.isNotEmpty
                          ? _ageController.text
                          : '',
                    };
                    patientProvider.updateProfile(
                      patientProvider.patient!.id,
                      updatedData,
                      _imageFile?.path,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPatientProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewPatientProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
