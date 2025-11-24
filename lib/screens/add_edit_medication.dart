import 'package:flutter/material.dart';
import '../models/medication.dart';
import '../repositories/medication_repository.dart';

class AddEditMedication extends StatefulWidget {
  final Medication? med;

  AddEditMedication({this.med, Key? key}) : super(key: key);

  @override
  _AddEditMedicationState createState() => _AddEditMedicationState();
}

class _AddEditMedicationState extends State<AddEditMedication> {
  final repo = MedicationRepository();

  final name = TextEditingController();
  final dosage = TextEditingController();
  final time = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.med != null) {
      name.text = widget.med!.name;
      dosage.text = widget.med!.dosage;
      time.text = widget.med!.time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Degradado moderno en el AppBar
      appBar: AppBar(
        title: Text(widget.med == null ? 'Agregar Medicamento' : 'Editar Medicamento'),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFF6F6F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Campo Nombre
              TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.medical_services, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Dosis
              TextField(
                controller: dosage,
                decoration: InputDecoration(
                  labelText: 'Dosis',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.healing, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 16),

              // Campo Hora
              TextField(
                controller: time,
                decoration: InputDecoration(
                  labelText: 'Hora',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.access_time, color: Colors.teal),
                ),
              ),
              const SizedBox(height: 32),

              // Botón Guardar
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() => _loading = true);
                          try {
                            if (widget.med == null) {
                              await repo.addMedication(Medication(
                                  id: '',
                                  name: name.text.trim(),
                                  dosage: dosage.text.trim(),
                                  time: time.text.trim()));
                            } else {
                              await repo.updateMedication(Medication(
                                  id: widget.med!.id,
                                  name: name.text.trim(),
                                  dosage: dosage.text.trim(),
                                  time: time.text.trim()));
                            }
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')));
                          } finally {
                            setState(() => _loading = false);
                          }
                        },
                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Guardar',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
