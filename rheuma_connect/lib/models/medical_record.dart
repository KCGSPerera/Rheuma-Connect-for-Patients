class MedicalRecord {
  final String id;
  final String description;
  final String duration;
  final List<String> medicines;
  final DateTime date;
  final String generatedBy; // This will hold the doctor's name or ID
  final String patient;

  MedicalRecord({
    required this.id,
    required this.description,
    required this.duration,
    required this.medicines,
    required this.date,
    required this.generatedBy,
    required this.patient,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['_id']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      medicines: List<String>.from(json['medicines'] ?? []),
      date: DateTime.parse(json['date']),
      generatedBy: json['generatedBy']?['name'] ??
          '', // Assuming populated doctor's name
      patient: json['patient']?.toString() ?? '',
    );
  }
}














// class MedicalRecord {
//   final String id;
//   final String photo; // URL to the photo
//   final DateTime date; // Date when the record was generated
//   final String generatedBy; // Doctor ID who generated the record
//   final String patientId; // Patient ID associated with the record

//   MedicalRecord({
//     required this.id,
//     required this.photo,
//     required this.date,
//     required this.generatedBy,
//     required this.patientId,
//   });

//   factory MedicalRecord.fromJson(Map<String, dynamic> json) {
//     return MedicalRecord(
//       id: json['_id'],
//       photo: json['photo'],
//       date: DateTime.parse(json['date']), // Parse the date
//       generatedBy: json['generatedBy'], // Reference to the doctor ID
//       patientId: json['patient'], // Reference to the patient ID
//     );
//   }
// }
