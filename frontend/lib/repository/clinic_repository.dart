import 'package:frontend/services/clinic_service.dart';

import '../models/clinic_model.dart';

class ClinicsRepository {
  final ClinicsService service;
  const ClinicsRepository({required this.service});

  Future<ClinicModel>      create(ClinicModel c)           => service.createClinic(c);
  Future<List<ClinicModel>> fetchAll()                     => service.getAllClinics();
  Future<ClinicModel>      fetchById(String id)            => service.getClinicById(id);
  Future<ClinicModel>      update(String id, ClinicModel c)=> service.updateClinic(id, c);
  Future<void>             remove(String id,{String? vetId})=> service.deleteClinic(id, vetId: vetId);
}
