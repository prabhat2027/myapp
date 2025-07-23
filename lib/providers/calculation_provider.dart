import 'package:flutter/foundation.dart';
import '../models/calculation.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class CalculationProvider with ChangeNotifier {
  List<Calculation> _history = [];

  List<Calculation> get calculations => _history; // ✅ ADD THIS LINE

  CalculationProvider() {
    loadCalculations();
  }

  Future<void> loadCalculations() async {
    final box = await Hive.openBox<Calculation>('calcBox');
    _history = box.values.toList();
    notifyListeners();
  }

  Future<void> addCalculation(Calculation calculation) async {
    final box = await Hive.openBox<Calculation>('calcBox');
    await box.add(calculation);
    _history = box.values.toList();
    notifyListeners();
  }
}
