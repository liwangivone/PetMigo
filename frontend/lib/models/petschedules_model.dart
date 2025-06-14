import 'package:intl/intl.dart';

/// Kategori jadwal untuk hewan peliharaan
enum PetScheduleCategory {
  Vaccination,
  Grooming,
  Food,
  Toys,
  Snack,
  Others,
}

/// Model jadwal aktivitas hewan
class PetSchedule {
  final String id;
  final PetScheduleCategory category;
  final int expense;
  final String description;
  final DateTime date;
  final String petId;
  final String petName;
  final String petType;

  /// Konstruktor utama
  PetSchedule({
    required this.id,
    required this.category,
    required this.expense,
    required this.description,
    required this.date,
    required this.petId,
    required this.petName,
    required this.petType,
  });

  /// Buat `PetSchedule` dari JSON, dengan nama dan tipe hewan tambahan
  factory PetSchedule.fromJson(
    Map<String, dynamic> json, [
    String petName = '',
    String petType = '',
  ]) {
    return PetSchedule(
      id: json['schedule_id']?.toString() ?? '',
      category: PetScheduleCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => PetScheduleCategory.Others,
      ),
      expense: json['expense'] ?? 0,
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      petId: json['pet']?['petid']?.toString() ?? '',
      petName: petName,
      petType: petType,
    );
  }

  /// Duplikasi dari `PetSchedule` lain dengan menambahkan `petName` dan `petType`
  factory PetSchedule.fromSchedule(
    PetSchedule schedule,
    String petName,
    String petType,
  ) {
    return PetSchedule(
      id: schedule.id,
      category: schedule.category,
      expense: schedule.expense,
      description: schedule.description,
      date: schedule.date,
      petId: schedule.petId,
      petName: petName,
      petType: petType,
    );
  }

  /// Konversi ke bentuk JSON (untuk kirim ke API)
  Map<String, dynamic> toJson() {
    return {
      'schedule_id': id,
      'category': category.name,
      'expense': expense,
      'description': description,
      'date': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(date),
      'pet_id': petId,
      'pettype': petType,
    };
  }
}
