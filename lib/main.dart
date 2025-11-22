// import 'dart:ffi';

import 'package:calculator/landing.dart';
import 'package:calculator/newCalc.dart';
import 'package:calculator/oldCalc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Calc());
}

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: NewCalc(),
    );
  }
}
