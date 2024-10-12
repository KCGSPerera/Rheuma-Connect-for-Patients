class Appointment {
  final String id;
  final DateTime date;
  final String time;
  final DateTime? nextAppDateTime;
  final DateTime? lastAppDateTime;
  final String roomNo;
  final String consultant; // This will hold the doctor's name or ID
  final String status;
  final String patientId;
  final List<String> patientVitals;
  final List<String> medicalRecords;

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    this.nextAppDateTime,
    this.lastAppDateTime,
    required this.roomNo,
    required this.consultant,
    required this.status,
    required this.patientId,
    required this.patientVitals,
    required this.medicalRecords,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id']?.toString() ?? '',
      date: DateTime.parse(json['date']),
      time: json['time']?.toString() ?? '',
      nextAppDateTime: json['nextAppDateTime'] != null
          ? DateTime.parse(json['nextAppDateTime'])
          : null,
      lastAppDateTime: json['lastAppDateTime'] != null
          ? DateTime.parse(json['lastAppDateTime'])
          : null,
      roomNo: json['roomNo']?.toString() ?? '',
      consultant:
          json['consultant']?['name'] ?? '', // Assuming populated doctor's name
      status: json['status']?.toString() ?? 'Scheduled',
      patientId: json['patientId']?.toString() ?? '',
      patientVitals: List<String>.from(json['patientVitals'] ?? []),
      medicalRecords: List<String>.from(json['medicalRecords'] ?? []),
    );
  }
}
