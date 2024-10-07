import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

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
    final patient = patientProvider.patient;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: SafeArea(child: const Text('Profile')),
      ),
      body: patient == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (patient.profilePhoto != null
                              ? NetworkImage(
                                  'http://localhost:3001${patient.profilePhoto}')
                              : const AssetImage(
                                  'assets/default_profile.png')) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: patient.name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      // Store new name locally
                      patientProvider.updateProfile(
                          patient.id, {'name': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.birthday,
                    decoration: const InputDecoration(labelText: 'Birthday'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(
                          patient.id, {'birthday': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.medicalId,
                    decoration: const InputDecoration(labelText: 'Medical ID'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(
                          patient.id, {'medicalId': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.username,
                    decoration: const InputDecoration(labelText: 'User Name'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(
                          patient.id, {'username': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(
                          patient.id, {'email': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.contactNumber,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(patient.id,
                          {'contactNumber': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.bloodType,
                    decoration: const InputDecoration(labelText: 'Blood Type'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(
                          patient.id, {'bloodType': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.rheumaticType,
                    decoration:
                        const InputDecoration(labelText: 'Rheumatic Type'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(patient.id,
                          {'rheumaticType': value}, _imageFile?.path);
                    },
                  ),
                  TextFormField(
                    initialValue: patient.age?.toString(),
                    decoration: const InputDecoration(labelText: 'Age'),
                    onChanged: (value) {
                      // Store new birthday locally
                      patientProvider.updateProfile(
                          patient.id, {'age': value}, _imageFile?.path);
                    },
                  ),

                  // Add fields for other profile info like bloodType, contactNumber, etc.
                ],
              ),
            ),
    );
  }
}
