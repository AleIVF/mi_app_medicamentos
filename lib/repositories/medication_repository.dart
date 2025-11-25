import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/med_history.dart';

class MedicationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Medication>> getMedications() {
    return _db
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) =>
                Medication.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addMedication(Medication med) async {
    await _db
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .add(med.toMap());
  }

  Future<void> updateMedication(Medication med) async {
    await _db
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(med.id)
        .update(med.toMap());
  }

  Future<void> deleteMedication(String id) async {
    await _db
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(id)
        .delete();
  }

  /// Marca como tomado y agrega un registro al historial
  Future<void> markAsTaken(Medication med) async {
    // 1) actualizar el medicamento a taken = true
    await _db
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(med.id)
        .update({'taken': true});

    // 2) agregar registro al historial
    await addHistoryEntry(med.id, med.name, taken: true);
  }

  /// Agregar un registro manual al historial (taken = true/false)
  Future<void> addHistoryEntry(String medId, String medName,
      {required bool taken, DateTime? at}) async {
    final date = at ?? DateTime.now();
    final entry = MedHistory(
      id: '',
      medicationId: medId,
      medicationName: medName,
      takenAt: date,
      status: taken ? 'taken' : 'skipped',
    );

    await _db
        .collection('users')
        .doc(_userId)
        .collection('history')
        .add(entry.toMap());
  }

  /// Obtener stream de historial (ordenado por fecha desc)
  Stream<List<MedHistory>> getHistory() {
    return _db
        .collection('users')
        .doc(_userId)
        .collection('history')
        .orderBy('takenAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => MedHistory.fromMap(d.id, d.data() as Map<String, dynamic>))
            .toList());
  }

  /// Obtener registros entre dos fechas (útil si quieres filtrar 'ayer')
  Future<List<MedHistory>> getHistoryBetween(DateTime from, DateTime to) async {
    final snap = await _db
        .collection('users')
        .doc(_userId)
        .collection('history')
        .where('takenAt', isGreaterThanOrEqualTo: from.toIso8601String())
        .where('takenAt', isLessThanOrEqualTo: to.toIso8601String())
        .orderBy('takenAt', descending: true)
        .get();

    return snap.docs
        .map((d) => MedHistory.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }
}
