class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final bool taken;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.taken = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'taken': taken,
    };
  }

  factory Medication.fromMap(String id, Map<String, dynamic> map) {
    return Medication(
      id: id,
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      time: map['time'] ?? '',
      taken: map['taken'] ?? false,
    );
  }
}
