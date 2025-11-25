import 'package:flutter/material.dart';
import '../repositories/medication_repository.dart';
import '../models/medication.dart';
import '../widgets/medication_card.dart';
import 'add_edit_medication.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final repo = MedicationRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f6f5),

      appBar: AppBar(
        title: const Text(
          'Mis Medicamentos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
            },
          ),
        ],
      ),

      body: StreamBuilder<List<Medication>>(
        stream: repo.getMedications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final meds = snapshot.data ?? [];
          if (meds.isEmpty) {
            return const Center(
              child: Text("No hay medicamentos aún.",
                  style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meds.length,
            itemBuilder: (_, i) => MedicationCard(med: meds[i]),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditMedication()),
          );
        },
      ),
    );
  }
}
