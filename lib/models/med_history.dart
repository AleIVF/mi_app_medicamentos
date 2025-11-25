class MedHistory {
  String id;
  String medicationId;
  String medicationName;
  DateTime takenAt;
  String status; // "taken" o "skipped"

  MedHistory({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.takenAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'medicationId': medicationId,
      'medicationName': medicationName,
      'takenAt': takenAt.toIso8601String(),
      'status': status,
    };
  }

  factory MedHistory.fromMap(String id, Map<String, dynamic> data) {
    return MedHistory(
      id: id,
      medicationId: data['medicationId'] ?? '',
      medicationName: data['medicationName'] ?? '',
      takenAt: DateTime.tryParse(data['takenAt'] ?? '') ?? DateTime.now(),
      status: data['status'] ?? 'taken',
    );
  }
}
