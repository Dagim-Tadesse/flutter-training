import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = ""; // everything user sees
  String currentNumber = ""; // temporary number being typed
  List<double> numbers = []; // list of all numbers
  List<String> operators = []; // list of operators

  void press(String value) {
    setState(() {
      if (value == "C") {
        // Clear everything
        display = "";
        currentNumber = "";
        numbers.clear();
        operators.clear();
      } else if (value == "+" || value == "-" || value == "*" || value == "/") {
        if (currentNumber.isEmpty) return; // ignore if operator clicked twice

        // Convert to number and push to list
        numbers.add(double.parse(currentNumber));
        operators.add(value);

        // Update display
        display += value;

        // Reset temp number
        currentNumber = "";
      } else if (value == "=") {
        if (currentNumber.isEmpty) return;

        // Add last number
        numbers.add(double.parse(currentNumber));

        // Calculate left-to-right
        double result = numbers[0];

        for (int i = 0; i < operators.length; i++) {
          double next = numbers[i + 1];
          String op = operators[i];

          if (op == "+")
            result += next;
          else if (op == "-")
            result -= next;
          else if (op == "*")
            result *= next;
          else if (op == "/")
            result /= next;
        }

        display = result.toString();

        // Reset everything for next calculation
        currentNumber = display; // allow continued typing from result
        numbers.clear();
        operators.clear();
      } else {
        // Number pressed 0-9
        currentNumber += value;
        display += value;
      }
    });
  }

  Widget btn(String value) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => press(value),
        child: Text(value, style: const TextStyle(fontSize: 28)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Left-to-Right Calculator")),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(20),
            child: Text(display, style: const TextStyle(fontSize: 36)),
          ),

          Expanded(
            child: Column(
              children: [
                Row(children: [btn("7"), btn("8"), btn("9"), btn("/")]),
                Row(children: [btn("4"), btn("5"), btn("6"), btn("*")]),
                Row(children: [btn("1"), btn("2"), btn("3"), btn("-")]),
                Row(children: [btn("0"), btn("C"), btn("="), btn("+")]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
