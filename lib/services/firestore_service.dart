import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';
import 'auth_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get userId => AuthService().currentUser!.uid;

  // ===== OBTENER MEDICAMENTOS =====
  Stream<List<Medication>> getMedications() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('medications')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => Medication.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  // ===== AGREGAR =====
  Future<void> addMedication(Medication med) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('medications')
        .add(med.toMap());
  }

  // ===== ACTUALIZAR =====
  Future<void> updateMedication(Medication med) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('medications')
        .doc(med.id)
        .update(med.toMap());
  }

  // ===== ELIMINAR =====
  Future<void> deleteMedication(String id) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('medications')
        .doc(id)
        .delete();
  }
}
