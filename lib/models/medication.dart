class Medication {
  String id;
  String name;
  String dosage;
  String time;
  bool taken;
  List<DateTime> history; // ← AGREGADO

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.taken = false,
    this.history = const [], // ← DEFAULT VACÍO
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time,
      'taken': taken,
      'history': history.map((h) => h.toIso8601String()).toList(), 
    };
  }

  factory Medication.fromMap(String id, Map<String, dynamic> data) {
    return Medication(
      id: id,
      name: data['name'] ?? '',
      dosage: data['dosage'] ?? '',
      time: data['time'] ?? '',
      taken: data['taken'] ?? false,
      history: (data['history'] as List<dynamic>? ?? [])
          .map((h) => DateTime.parse(h))
          .toList(),
    );
  }
}

