import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../repositories/medication_repository.dart';
import '../screens/add_edit_medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication med;
  final repo = MedicationRepository();

  MedicationCard({required this.med});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.medical_services, color: Colors.teal),
        title: Text(
          med.name,
          style: TextStyle(
            decoration: med.taken ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('${med.dosage} • ${med.time}'),
        trailing: Wrap(
          spacing: 6,
          children: [
            // ✅ PALOMITA VERDE
            IconButton(
              icon: Icon(
                Icons.check_circle,
                color: med.taken ? Colors.green : Colors.grey,
              ),
              onPressed: () async {
                await repo.updateMedication(
                  Medication(
                    id: med.id,
                    name: med.name,
                    dosage: med.dosage,
                    time: med.time,
                    taken: !med.taken,
                  ),
                );
              },
            ),

            // ✏️ EDITAR
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueGrey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditMedication(med: med),
                  ),
                );
              },
            ),

            // 🗑️ ELIMINAR
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Eliminar medicamento'),
                    content: const Text(
                        '¿Estás seguro de que quieres eliminar este medicamento?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await repo.deleteMedication(med.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
