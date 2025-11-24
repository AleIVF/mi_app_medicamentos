class Medication {
  String id;
  String name;
  String dosage;
  String time;
  bool taken; // Nuevo campo

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.taken = false, // default false
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'taken': taken,
    };
  }

  factory Medication.fromMap(String id, Map<String, dynamic> data) {
    return Medication(
      id: id,
      name: data['name'] ?? '',
      dosage: data['dosage'] ?? '',
      time: data['time'] ?? '',
      taken: data['taken'] ?? false,
    );
  }
}
