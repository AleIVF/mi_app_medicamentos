import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Nuevo método para marcar medicamento como tomado
  Future<void> markAsTaken(Medication med) async {
    await _db
        .collection('users')
        .doc(_userId)
        .collection('medications')
        .doc(med.id)
        .update(med.toMap()..['taken'] = true);
  }
}
