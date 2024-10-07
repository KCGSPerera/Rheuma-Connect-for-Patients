// import 'dart:ffi';

class Patient {
  final String id;
  final String username;
  final String email;
  final String medicalId;
  final String? profilePhoto;
  final String? name;
  final String? birthday;
  final String? contactNumber;
  final String? bloodType;
  final String? rheumaticType;
  final int? age;

  Patient(
      {required this.id,
      required this.username,
      required this.email,
      required this.medicalId,
      this.profilePhoto,
      this.name,
      this.birthday,
      this.contactNumber,
      this.bloodType,
      this.rheumaticType,
      this.age});

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        id: json['_id'],
        username: json['username'],
        email: json['email'],
        medicalId: json['medicalId'],
        profilePhoto: json['profilePhoto'],
        name: json['name'],
        birthday: json['birthday'],
        contactNumber: json['contactNumber'],
        bloodType: json['bloodType'],
        rheumaticType: json['rheumaticType'],
        age: json['age']);
  }
}
