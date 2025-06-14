import 'package:frontend/models/petschedules_model.dart';
import 'package:intl/intl.dart'; // 👈 diperlukan untuk format LocalDate

class Pet {
  final String id;
  final String name;
  final String gender;
  final String type;
  final DateTime birthdate;
  final String? breed;
  final double? weight;
  final String? color;
  final List<PetSchedule> petSchedules;

  const Pet({
    required this.id,
    required this.name,
    required this.gender,
    required this.type,
    required this.birthdate,
    this.breed,
    this.weight,
    this.color,
    this.petSchedules = const [],
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['petid']?.toString() ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      type: json['type'] ?? '',
      birthdate: DateTime.parse(json['birthdate']),
      breed: json['breed'],
      weight: (json['weight'] != null) ? double.tryParse(json['weight'].toString()) : null,
      color: json['color'],
      petSchedules: (json['schedules'] as List<dynamic>? ?? [])
          .map((s) => PetSchedule.fromJson(s))
          .toList(),
    );
  }

  static final DateFormat _dateFmt = DateFormat('yyyy-MM-dd'); // ✅ untuk LocalDate

  Map<String, dynamic> toJson() {
    return {
      'petid': id,
      'name': name,
      'gender': gender,
      'type': type,
      'birthdate': _dateFmt.format(birthdate), // ✅ pastikan bentuk "2025-06-18"
      'breed': breed,
      'weight': weight,
      'color': color,
      'schedules': petSchedules.map((s) => s.toJson()).toList(),
    };
  }
}
