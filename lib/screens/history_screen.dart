import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculation_provider.dart';
import '../models/calculation.dart';

import 'package:intl/intl.dart';

import 'package:hive/hive.dart';

final DateFormat timeFormat = DateFormat('dd MMM, hh:mm a');


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final history = Provider.of<CalculationProvider>(context).history;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Saved Notes"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<CalculationProvider>(
        builder: (context, provider, _) {
          final history = provider.calculations.reversed.toList();

          if (history.isEmpty) {
            return const Center(
              child: Text(
                'No history yet',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (_, index) {
              final calc = history[index];

              return Dismissible(
                key: Key(calc.time.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  final box = await Hive.openBox<Calculation>('calcBox');
                  final keyToDelete = box.keys.firstWhere(
                    (key) => box.get(key) == calc,
                    orElse: () => null,
                  );
                  if (keyToDelete != null) {
                    await box.delete(keyToDelete);
                    Provider.of<CalculationProvider>(context, listen: false).loadCalculations();
                  }
                },
                child: Card(
                  color: const Color(0xFF1C1C1C),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      '${calc.expression} = ${calc.result}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      calc.note,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                    trailing: Text(
                      timeFormat.format(calc.time),
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
              );
            },
);

        },
      ),
    );
  }
}
