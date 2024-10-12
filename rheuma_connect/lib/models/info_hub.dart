class InfoHub {
  final String id;
  final String name;
  final String doc; // This holds the detailed description
  final String category;
  final String uploadedBy; // This will hold the doctor's name or ID
  final DateTime uploadedAt;

  InfoHub({
    required this.id,
    required this.name,
    required this.doc,
    required this.category,
    required this.uploadedBy,
    required this.uploadedAt,
  });

  factory InfoHub.fromJson(Map<String, dynamic> json) {
    return InfoHub(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      doc: json['doc']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      uploadedBy:
          json['uploadedBy']?['name'] ?? '', // Assuming populated doctor's name
      uploadedAt: DateTime.parse(
          json['uploadedAt']?.toString() ?? DateTime.now().toString()),
    );
  }
}
















// class InfoHub {
//   final String id;
//   final String name; // Title of the article
//   final String category; // Category of the article
//   final String doc; // Path to the uploaded PDF document
//   final String doctorId; // ID of the doctor who uploaded the article
//   final String uploadedAt; // Date when the article was uploaded

//   InfoHub({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.doc,
//     required this.doctorId,
//     required this.uploadedAt,
//   });

//   factory InfoHub.fromJson(Map<String, dynamic> json) {
//     return InfoHub(
//       id: json['_id'],
//       name: json['name'],
//       category: json['category'],
//       doc: json['doc'], // Path to the PDF document
//       doctorId: json['uploadedBy'], // Reference to the doctor who uploaded it
//       uploadedAt: json['uploadedAt'],
//     );
//   }
// }
