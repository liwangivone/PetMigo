/// Status dokter hewan (online / offline)
enum VetStatus { online, offline }

/// Model data dokter hewan
class VetModel {
  final String id;
  final String name;
  final String clinicId;     // Foreign key ke ClinicModel.id
  final String clinicName;   // Nama klinik, bisa kosong
  final String specialization;
  final int experienceYears;
  final String overview;
  final String schedule;
  final VetStatus status;
  final String imageUrl;

  const VetModel({
    required this.id,
    required this.name,
    required this.clinicId,
    required this.clinicName,
    required this.specialization,
    required this.experienceYears,
    required this.overview,
    required this.schedule,
    required this.status,
    required this.imageUrl,
  });

  /// Buat objek dari JSON response backend
  factory VetModel.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] ?? '').toString().toLowerCase();

    // Ambil nama klinik dari berbagai kemungkinan field
    String rawClinicName = (json['clinics']?['name'] ??
        json['clinicName'] ??
        json['clinicname'] ??
        '')
        .toString()
        .trim();

    // Jika backend kirim literal "String", ubah jadi kosong
    if (rawClinicName.toLowerCase() == 'string') rawClinicName = '';

    return VetModel(
      id: (json['vetid'] ?? '').toString(),
      name: json['name'] ?? '',
      clinicId: (json['clinicId'] ?? json['clinicid'] ?? '').toString(),
      clinicName: rawClinicName,
      specialization: json['specialization'] ?? '',
      experienceYears:
          int.tryParse(json['experienceYears']?.toString() ?? '0') ?? 0,
      overview: json['overview'] ?? '',
      schedule: json['schedule'] ?? '',
      status: statusStr == 'online' ? VetStatus.online : VetStatus.offline,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  /// Ubah objek ke JSON (untuk kebutuhan PUT/POST)
  Map<String, dynamic> toJson() => {
        'vetid': id,
        'name': name,
        'clinicId': clinicId,
        'clinicName': clinicName,
        'specialization': specialization,
        'experienceYears': experienceYears,
        'overview': overview,
        'schedule': schedule,
        'status': status.name,
        'imageUrl': imageUrl,
      };
}
