import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../repositories/medication_repository.dart';

class AddEditMedication extends StatefulWidget {
  final Medication? med;
  const AddEditMedication({this.med, Key? key}) : super(key: key);

  @override
  State<AddEditMedication> createState() => _AddEditMedicationState();
}

class _AddEditMedicationState extends State<AddEditMedication> {
  final repo = MedicationRepository();
  final name = TextEditingController();
  final dosage = TextEditingController();
  final time = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.med != null) {
      name.text = widget.med!.name;
      dosage.text = widget.med!.dosage;
      time.text = widget.med!.time;
    }
  }

  InputDecoration inputStyle(String text, IconData icon) {
    return InputDecoration(
      labelText: text,
      prefixIcon: Icon(icon, color: Colors.teal),
      filled: true,
      fillColor: const Color(0xFFF4F9F9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Medicamento')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: name, decoration: inputStyle('Nombre', Icons.medical_services)),
            const SizedBox(height: 14),
            TextField(controller: dosage, decoration: inputStyle('Dosis', Icons.opacity)),
            const SizedBox(height: 14),
            TextField(controller: time, decoration: inputStyle('Hora', Icons.access_time)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  if (widget.med == null) {
                    await repo.addMedication(
                      Medication(id: '', name: name.text.trim(), dosage: dosage.text.trim(), time: time.text.trim()),
                    );
                  } else {
                    await repo.updateMedication(
                      Medication(id: widget.med!.id, name: name.text.trim(), dosage: dosage.text.trim(), time: time.text.trim()),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
