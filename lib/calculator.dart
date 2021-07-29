import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_styles.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  ColorStyles _colorStyles = ColorStyles();
  String _history = '';
  String _expression = '';
  bool _lightTheme = true;

  late Color _myBackgroundColor;
  late Color _changeThemeButtonIconColor;
  late Color _changeThemeButtonBackgroundColor;
  late IconData _changeThemeButtonIcon;
  late Color _exampleColor;
  late Color _buttonsColor;
  late Color _buttonsShadowColor;

  @override
  void initState() {
    super.initState();
    _changeTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _myBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 21.0, top: 60.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _changeTheme,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3.0,
                            spreadRadius: 2.0,
                            offset: Offset(-2.0, -2.0),
                            color: _buttonsShadowColor.withOpacity(0.1))
                      ],
                      shape: BoxShape.circle,
                      color: _changeThemeButtonBackgroundColor),
                  child: Center(
                    child: Icon(
                      _changeThemeButtonIcon,
                      color: _changeThemeButtonIconColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 102.0),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              height: 96.0,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(_history,
                        style: GoogleFonts.roboto(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            color: _colorStyles.color8)),
                  )),
                  Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _expression,
                          style: GoogleFonts.roboto(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              color: _exampleColor),
                        ),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
          Container(
            height: MediaQuery.of(context).size.height - 338.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: _buttonsColor),
            child: Padding(
              padding: EdgeInsets.fromLTRB(17.0, 26.0, 18.0, 10.0),
              child: Container(
                height: 380,
                width: 340,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _createButton(_colorStyles.color4, 'AC'),
                        _createButton(_colorStyles.color4, 'C'),
                        _createButton(_colorStyles.color4, '%'),
                        _createButton(_colorStyles.color5, '÷')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _createButton(_colorStyles.color3, '7'),
                        _createButton(_colorStyles.color3, '8'),
                        _createButton(_colorStyles.color3, '9'),
                        _createButton(_colorStyles.color5, 'x')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _createButton(_colorStyles.color3, '4'),
                        _createButton(_colorStyles.color3, '5'),
                        _createButton(_colorStyles.color3, '6'),
                        _createButton(_colorStyles.color5, '-')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _createButton(_colorStyles.color3, '1'),
                        _createButton(_colorStyles.color3, '2'),
                        _createButton(_colorStyles.color3, '3'),
                        _createButton(_colorStyles.color5, '+')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _createButton(_colorStyles.color3, '<'),
                        _createButton(_colorStyles.color3, '0'),
                        _createButton(_colorStyles.color3, '.'),
                        _createButton(_colorStyles.color5, '=')
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _createButton(Color color, String text) {
    return InkWell(
      onTap: () {
        _keyboardListener(text);
      },
      child: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _buttonsColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3.0,
                  spreadRadius: 2.0,
                  offset: Offset(-2.0, -2.0),
                  color: _buttonsShadowColor.withOpacity(0.1))
            ]),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.roboto(
                fontSize: 35.0,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: color),
          ),
        ),
      ),
    );
  }

  _keyboardListener(String key) {
    setState(() {
      switch (key) {
        case '<':
          _expression = _expression.substring(0, _expression.length - 1);
          return;
        case 'AC':
          _history = '';
          _expression = '';
          return;
        case 'C':
          _expression = '';
          return;
        case '÷':
          _expression += '/';
          return;
        case 'x':
          _expression += '*';
          return;
        case '=':
          _history = _expression;
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
          return;
      }
      if (_expression.length < 15) _expression += key;
    });
  }

  _changeTheme() {
    setState(() {
      if (_lightTheme) {
        _lightTheme = false;
        _myBackgroundColor = _colorStyles.color1;
        _changeThemeButtonIconColor = Colors.white;
        _changeThemeButtonBackgroundColor = _colorStyles.color1;
        _changeThemeButtonIcon = Icons.light_mode_outlined;
        _exampleColor = _colorStyles.color7;
        _buttonsColor = _colorStyles.color2;
        _buttonsShadowColor = _colorStyles.color6;
      } else {
        _lightTheme = true;
        _myBackgroundColor = Colors.white;
        _changeThemeButtonIconColor = _colorStyles.color1;
        _changeThemeButtonBackgroundColor = Colors.white;
        _changeThemeButtonIcon = Icons.dark_mode_outlined;
        _exampleColor = _colorStyles.color1;
        _buttonsColor = _colorStyles.color6;
        _buttonsShadowColor = _colorStyles.color1;
      }
    });
  }
}
