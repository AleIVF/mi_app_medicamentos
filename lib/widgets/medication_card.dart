import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../repositories/medication_repository.dart';
import '../screens/add_edit_medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication med;
  final VoidCallback? onTaken;
  final repo = MedicationRepository();

  MedicationCard({required this.med, this.onTaken, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: Icon(
          med.taken ? Icons.check_circle : Icons.medical_services,
          color: med.taken ? Colors.green : Colors.teal,
        ),
        title: Text(
          med.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: med.taken ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${med.dosage} • ${med.time}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!med.taken)
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: onTaken,
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await repo.deleteMedication(med.id);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditMedication(med: med)),
          );
        },
      ),
    );
  }
}
