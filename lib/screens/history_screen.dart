import 'package:flutter/material.dart';
import '../repositories/medication_repository.dart';
import '../models/med_history.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final repo = MedicationRepository();
  final DateFormat dateFmt = DateFormat('dd MMM yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<List<MedHistory>>(
        stream: repo.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text('No hay registros en el historial.'));
          }

          // Agrupar por fecha (día) para facilitar mostrar "Hoy" / "Ayer"
          final grouped = <String, List<MedHistory>>{};
          for (final h in items) {
            final key = DateFormat('yyyy-MM-dd').format(h.takenAt);
            grouped.putIfAbsent(key, () => []).add(h);
          }

          final keys = grouped.keys.toList()..sort((a,b)=> b.compareTo(a)); // desc

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: keys.length,
            itemBuilder: (context, idx) {
              final day = keys[idx];
              final listForDay = grouped[day]!;
              final date = DateTime.parse(day);
              final today = DateTime.now();
              final yesterday = DateTime.now().subtract(const Duration(days: 1));

              String headerLabel;
              if (date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day) {
                headerLabel = 'Hoy';
              } else if (date.year == yesterday.year &&
                  date.month == yesterday.month &&
                  date.day == yesterday.day) {
                headerLabel = 'Ayer';
              } else {
                headerLabel = DateFormat('dd MMM yyyy').format(date);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(headerLabel,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ...listForDay.map((h) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            h.status == 'taken' ? Icons.check_circle : Icons.close,
                            color: h.status == 'taken' ? Colors.green : Colors.red,
                          ),
                          title: Text(h.medicationName),
                          subtitle: Text(dateFmt.format(h.takenAt)),
                          trailing: Text(h.status == 'taken' ? 'Tomado' : 'Omitido'),
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
