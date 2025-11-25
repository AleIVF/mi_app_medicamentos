import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../repositories/medication_repository.dart';
import '../screens/add_edit_medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication med;
  final repo = MedicationRepository();

  MedicationCard({Key? key, required this.med}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  med.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditMedication(med: med),
                          ),
                        );
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await repo.deleteMedication(med.id);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text("Dosis: ${med.dosage}"),
            Text("Hora: ${med.time}"),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () async {
                  await repo.addHistoryEntry(med.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registrado en historial")),
                  );
                },
                child: const Text("Marcar como tomado"),
              ),
            ),

            const SizedBox(height: 12),

            if (med.history.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Historial reciente:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  ...med.history.take(3).map(
                    (h) => Text(
                      "• ${h.toLocal().toString().substring(0, 16)}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              )
            else
              const Text(
                "Sin historial aún.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
