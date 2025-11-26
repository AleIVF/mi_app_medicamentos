import 'package:flutter/material.dart';
import '../repositories/medication_repository.dart';
import '../models/medication.dart';
import '../widgets/medication_card.dart';
import 'add_edit_medication.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicationRepository repo = MedicationRepository();
  final TextEditingController searchController = TextEditingController();

  bool isSearching = false;
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== DRAWER =====
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Medify',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await AuthService().logout();
              },
            ),
          ],
        ),
      ),

      // ===== APPBAR CON BUSCADOR =====
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar medicamento...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    search = value.toLowerCase();
                  });
                },
              )
            : const Text('Mis Medicamentos'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  search = '';
                }
                isSearching = !isSearching;
              });
            },
          )
        ],
      ),

      // ===== LISTA =====
      body: StreamBuilder<List<Medication>>(
        stream: repo.getMedications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay medicamentos'));
          }

          final all = snapshot.data!;
          final filtered = all
              .where((m) => m.name.toLowerCase().contains(search))
              .toList();

          final pendientes = filtered.where((m) => !m.taken).toList();
          final tomados = filtered.where((m) => m.taken).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Medicamentos pendientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...pendientes.map((m) => MedicationCard(med: m)),

              const SizedBox(height: 24),

              const Text(
                'Medicamentos tomados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...tomados.map((m) => MedicationCard(med: m)),
            ],
          );
        },
      ),

      // ===== FAB =====
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditMedication()),
          );
        },
      ),
    );
  }
}
