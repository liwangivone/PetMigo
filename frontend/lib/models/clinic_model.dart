class ClinicModel {
  final String id;            // clinicsid/clinicId jadi String
  final String name;
  final String location;
  final String openingHours;
  final String imageUrl;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.location,
    required this.openingHours,
    required this.imageUrl,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
        id: json['clinicsid']?.toString() ??
            json['clinicId']?.toString() ??
            '',
        name: json['name']?.toString() == 'String' ? '' : json['name'] ?? '',
        location: json['location']?.toString() == 'String'
            ? ''
            : json['location'] ?? '',
        openingHours: json['openingHours']?.toString() == 'String'
            ? ''
            : json['openingHours'] ??
                json['openinghours'] ?? // fallback tambahan
                '',
        imageUrl: json['imageUrl']?.toString() == 'String'
            ? ''
            : json['imageUrl'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'clinicsid': id,
        'name': name,
        'location': location,
        'openingHours': openingHours,
        'imageUrl': imageUrl,
      };
}
