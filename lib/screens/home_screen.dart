import 'package:flutter/material.dart';
import '../repositories/medication_repository.dart';
import '../models/medication.dart';
import '../widgets/medication_card.dart';
import 'add_edit_medication.dart';
import '../services/auth_service.dart';

// SearchDelegate para la lupa
class MedicationSearch extends SearchDelegate<Medication?> {
  final List<Medication> medications;
  MedicationSearch({required this.medications});

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final results = medications
        .where((med) => med.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: MedicationCard(
          med: results[i],
          onTaken: results[i].taken
              ? null
              : () async {
                  await MedicationRepository().markAsTaken(results[i]);
                  close(context, null);
                },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = medications
        .where((med) => med.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(suggestions[i].name),
        onTap: () {
          query = suggestions[i].name;
          showResults(context);
        },
      ),
    );
  }
}

// HomeScreen principal
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final repo = MedicationRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.teal),
              child: const Text(
                'Mi App de Medicamentos',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.teal),
              title: const Text('Inicio'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.green),
              title: const Text('Agregar Medicamento'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEditMedication()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await AuthService().logout();
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mis Medicamentos",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () async {
              final meds = await repo.getMedications().first ?? [];
              showSearch(
                context: context,
                delegate: MedicationSearch(medications: meds),
              );
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
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final meds = snapshot.data ?? [];
          final pendingMeds = meds.where((m) => !m.taken).toList();
          final takenMeds = meds.where((m) => m.taken).toList();

          if (meds.isEmpty) {
            return const Center(
              child: Text(
                "No hay medicamentos aún.",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (pendingMeds.isNotEmpty) ...[
                  const Text(
                    'Medicamentos pendientes',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...pendingMeds.map(
                    (m) => MedicationCard(
                      med: m,
                      onTaken: () async {
                        await repo.markAsTaken(m);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (takenMeds.isNotEmpty) ...[
                  const Text(
                    'Medicamentos tomados',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  ...takenMeds.map((m) => MedicationCard(med: m)),
                ],
              ],
            ),
          );
        },
      ),

      floatingActionButton: Container(
        height: 62,
        width: 62,
        decoration: BoxDecoration(
          color: const Color(0xFF1EC8A5),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color(0xFF1EC8A5),
          child: const Icon(Icons.add, size: 32),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditMedication()),
            );
          },
        ),
      ),
    );
  }
}
