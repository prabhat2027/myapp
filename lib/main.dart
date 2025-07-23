import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/calculation.dart';
import 'providers/theme_provider.dart';
import 'providers/calculation_provider.dart';
import 'screens/calculator_screen.dart';
import 'screens/history_screen.dart';

import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CalculationAdapter());

  await Hive.openBox<Calculation>('calcBox');


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CalculationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalcNote',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        dialogBackgroundColor: Color(0xFF1C1C1C),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _index = 0;
  final screens = const [
    CalculatorScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: "Calculator"),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: "Notes"),
        ],
      ),
    );
  }
}
