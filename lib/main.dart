import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Calculator',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Color(0xFF333333),
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String expression = '';
  String result = '';

  void numClick(String text) {
    setState(() {
      if (result.isNotEmpty) {
        if (['+', '-', '×', '÷'].contains(text)) {
          expression = result + text;
          result = '';
        } else {
          expression = text;
          result = '';
        }
      } else {
        expression += text;
      }
    });
  }

  void delete() {
    setState(() {
      if (expression.isNotEmpty) {
        expression = expression.substring(0, expression.length - 1);
      }
    });
  }

  String preprocessExpression(String input) {
    String exp = input.replaceAll('×', '*').replaceAll('÷', '/');
    return exp;
  }

  void calculate() {
    try {
      String finalExpression = preprocessExpression(expression);
      Parser parser = Parser();
      Expression exp = parser.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        result = eval == eval.toInt()
            ? eval.toInt().toString()
            : eval.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Math Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                expression,
                style: TextStyle(
                  fontSize: 28,
                  color: result.isEmpty ? Colors.white : Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),
            buildButtonRow(['AC', 'DEL']),
            buildButtonRow(['7', '8', '9', '÷']),
            buildButtonRow(['4', '5', '6', '×']),
            buildButtonRow(['1', '2', '3', '-']),
            buildButtonRow(['00', '0', '.', '+']),
            buildButtonRow(['=']),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((btnText) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: GestureDetector(
              onLongPress: btnText == '⌫'
                  ? () => setState(() {
                      expression = '';
                      result = '';
                    })
                  : null,
              child: ElevatedButton(
                onPressed: () {
                  if (btnText == 'DEL') {
                    delete();
                  } else if (btnText == 'AC') {
                    setState(() {
                      expression = '';
                      result = '';
                    });
                  } else if (btnText == '=') {
                    calculate();
                  } else {
                    numClick(btnText);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getButtonColor(btnText),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  btnText,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getButtonColor(String btnText) {
    if (btnText == 'AC') return Color(0xFFEF476F);
    if (btnText == 'DEL') return Color(0xFFDD2C00);
    if (btnText == '=') return Color.fromARGB(255, 2, 135, 99);
    if (['+', '-', '×', '÷'].contains(btnText)) {
      return Color(0xFFFFA502);
    }
    return Color(0xFF2C2C3E);
  }
}
