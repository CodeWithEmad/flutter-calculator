import 'package:calculator/widgets.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _userInput = '';
  var _result = "0";
  _onButtonPressed(String text) {
    setState(() {
      _userInput += text;
    });
  }

  _resetCalculator() {
    setState(() {
      _userInput = '';
      _result = "0";
    });
  }

  _clearLastEntry() {
    setState(() {
      _userInput = _userInput.isNotEmpty
          ? _userInput.substring(0, _userInput.length - 1)
          : '';
    });
  }

  _calculateExpression() {
    try {
      Parser parser = Parser();
      Expression expression =
          parser.parse(_userInput.replaceAll('x', '*').replaceAll('÷', '/'));
      ContextModel contextModel = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        _result = eval.floorToDouble().toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  _onPressedLogic(String text) {
    switch (text) {
      case '=':
        return _calculateExpression;
      case 'AC':
        return _resetCalculator;
      case 'CE':
        return _clearLastEntry;
      default:
        return () => _onButtonPressed(text);
    }
  }

  Widget _buildButtonRow(List<Map<String, dynamic>> buttonConfigs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonConfigs.map((config) {
        return CircleButton(
          text: config['text'],
          bgColor: config['bgColor'],
          textColor: config['textColor'],
          onPressed: _onPressedLogic(config["text"]),
          isSymbol: config['isSymbol'] ?? false,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Map<String, dynamic> styleActionsOrange = {
      "bgColor": Color(0xFFFF9F0A),
      "textColor": Colors.white,
    };

    const Map<String, dynamic> styleActionsGreyLight = {
      "bgColor": Color(0xFFA5A5A5),
      "textColor": Colors.black,
    };

    const Map<String, dynamic> styleNumbersGreyDark = {
      "bgColor": Color(0xFF333333),
      "textColor": Colors.white,
    };

    final List<List<Map<String, dynamic>>> buttonRows = [
      [
        {"text": "AC", ...styleActionsGreyLight},
        {"text": "CE", ...styleActionsGreyLight},
        {"text": "%", ...styleActionsGreyLight, "isSymbol": true},
        {"text": "÷", ...styleActionsOrange, "isSymbol": true},
      ],
      [
        {"text": "7", ...styleNumbersGreyDark},
        {"text": "8", ...styleNumbersGreyDark},
        {"text": "9", ...styleNumbersGreyDark},
        {"text": "x", ...styleActionsOrange, "isSymbol": true},
      ],
      [
        {"text": "4", ...styleNumbersGreyDark},
        {"text": "5", ...styleNumbersGreyDark},
        {"text": "6", ...styleNumbersGreyDark},
        {"text": "-", ...styleActionsOrange, "isSymbol": true},
      ],
      [
        {"text": "1", ...styleNumbersGreyDark},
        {"text": "2", ...styleNumbersGreyDark},
        {"text": "3", ...styleNumbersGreyDark},
        {"text": "+", ...styleActionsOrange, "isSymbol": true},
      ],
      [
        {"text": "00", ...styleNumbersGreyDark},
        {"text": "0", ...styleNumbersGreyDark},
        {"text": ".", ...styleNumbersGreyDark, "isSymbol": true},
        {"text": "=", ...styleActionsOrange, "isSymbol": true},
      ],
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                verticalDirection: VerticalDirection.up,
                children: [
                  Text(
                    _result,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    _userInput,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    buttonRows.map((row) => _buildButtonRow(row)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
