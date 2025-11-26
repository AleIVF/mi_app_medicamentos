import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medication.dart';

class MedicationRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Obtener medicamentos en tiempo real
  Stream<List<Medication>> getMedications() {
    final uid = _auth.currentUser!.uid;

    return _db
        .collection('users')
        .doc(uid)
        .collection('medications')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Medication.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Agregar medicamento
  Future<void> addMedication(Medication med) async {
    final uid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('medications')
        .add(med.toMap());
  }

  // Actualizar medicamento 
  Future<void> updateMedication(Medication med) async {
    final uid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('medications')
        .doc(med.id)
        .update(med.toMap());
  }

  //Eliminar medicamento
  Future<void> deleteMedication(String id) async {
    final uid = _auth.currentUser!.uid;

    await _db
        .collection('users')
        .doc(uid)
        .collection('medications')
        .doc(id)
        .delete();
  }
}
