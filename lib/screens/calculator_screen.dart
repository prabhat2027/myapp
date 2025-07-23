import 'package:calc_note/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculation.dart';
import '../providers/calculation_provider.dart';
import 'package:math_expressions/math_expressions.dart';


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '';

  void onButtonClick(String value) {
    setState(() {
      if (value == 'C') {
        expression = '';
        result = '';
      } else if (value == '=') {
        try {
          result = _evaluateExpression(expression);
          if (result != 'Error') {
            _askToSaveNote(); // show popup to add note
          }
        } catch (e) {
          result = 'Error';
        }
      } else if (value == '⌫') {
        if (expression.isNotEmpty) {
          setState(() {
            expression = expression.substring(0, expression.length - 1);
          });
        }
      } else {
        expression += value;
      }
    });
  }

String _evaluateExpression(String exp) {
  try {
    final parser = Parser();
    final expression = parser.parse(exp.replaceAll('×', '*').replaceAll('÷', '/'));
    final contextModel = ContextModel();
    final eval = expression.evaluate(EvaluationType.REAL, contextModel);
    return eval.toString();
  } catch (e) {
    return 'Error';
  }
}

void _askToSaveNote() {
  final noteController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF1C1C1C),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 10, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add a Note", style: TextStyle(color: Colors.white)),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: TextField(
        controller: noteController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "What is this calculation about?",
          hintStyle: TextStyle(color: Colors.white54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.orange)),
        ),
        TextButton(
          onPressed: () {
            if (expression.isNotEmpty && result.isNotEmpty && result != 'Error') {
              final calc = Calculation(
                expression: expression,
                result: result,
                note: noteController.text.trim(),
                time: DateTime.now(),
              );
              Provider.of<CalculationProvider>(context, listen: false)
                  .addCalculation(calc);
              Navigator.of(context).pop();
            }
          },
          child: const Text("Save", style: TextStyle(color: Colors.orange)),
        ),
      ],
    ),
  );
}

  // void _saveCalculation() {
  //   final noteController = TextEditingController();
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Add a note"),
  //       content: TextField(
  //         controller: noteController,
  //         decoration: const InputDecoration(hintText: "Enter note..."),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             final calc = Calculation(
  //               expression: expression,
  //               result: result,
  //               note: noteController.text,
  //               time: DateTime.now(),
  //             );
  //             Provider.of<CalculationProvider>(context, listen: false)
  //                 .addCalculation(calc);
  //             Navigator.pop(context);
  //           },
  //           child: const Text("Save"),
  //         )
  //       ],
  //     ),
  //   );
  // }

final List<String> buttons = [
  'C', '⌫', '%', '/',
  '7', '8', '9', '*',
  '4', '5', '6', '-',
  '1', '2', '3', '+',
  '.', '0', '=', 
];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(title: const Text("Calculator + Notes")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(expression, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  Text(result, style: const TextStyle(fontSize: 32)),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    foregroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.history),
                  label: const Text("View Notes"),
                ),
              ],
            ),
          ),


          GridView.builder(
            shrinkWrap: true,
            itemCount: buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (_, index) {
              final btn = buttons[index];

              final isOperator = ['/', '*', '-', '+', '='].contains(btn);
              final isFunction = ['C', '⌫', '%', '±'].contains(btn);

              Color buttonColor;
              Color textColor = Colors.white;

              if (isOperator) {
                buttonColor = const Color(0xFFFF9500); // Orange
              } else if (isFunction) {
                buttonColor = const Color(0xFFA5A5A5); // Light Gray
                textColor = Colors.black;
              } else {
                buttonColor = const Color(0xFF333333); // Dark Gray
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => onButtonClick(btn),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(40), // pill-style iOS look
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(2, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: btn == '⌫'
                          ? Icon(Icons.backspace, size: 26, color: textColor)
                          : Text(
                              btn,
                              style: TextStyle(
                                fontSize: 24,
                                // fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                    ),
                    
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
