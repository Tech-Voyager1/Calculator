import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

class NewCalc extends StatefulWidget {
  const NewCalc({super.key});

  @override
  State<NewCalc> createState() => _NewCalcState();
}

class _NewCalcState extends State<NewCalc> {
  String num1 = ""; //. and 0 -9
  String num2 = ""; //. and 0 -9
  String op = ""; // % / + - *
  String top = "";
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  //to make a outline border over the container
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white60),
                  ),
                  child: Container(
                    height: height / 4,
                    width: width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(0, 255, 193, 7),
                    ),
                    alignment: Alignment
                        .bottomRight, //if not given , column content will be in center
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              top.isEmpty ? "" : top,
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "$num1$op$num2".isEmpty ? "0" : "$num1$op$num2",
                              style: TextStyle(fontSize: 50),
                              // softWrap: true,
                              // overflow: TextOverflow.visible,
                              // maxLines: null,
                              //didn't work
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20,
              ),
              child: Wrap(
                children: Btn.btnValues
                    .map(
                      (value) => SizedBox(
                        height: width / 5,
                        width: value == Btn.zero ? width / 2 : (width / 4),
                        child: createBtn(value),
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createBtn(value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: btnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.white12)),
        child: InkWell(
          onTap: () => onClick(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void onClick(String value) {
    //if keys => del , clear are pressed , then operations for them performed
    if (value == Btn.del) {
      //if pressed value is delete
      delete();
      return;
    }
    if (value == Btn.clr) {
      //if pressed value is clear
      clear();
      return;
    }
    if (value == Btn.per) {
      //if pressed value is percentage
      percent();
      return;
    }
    if (value == Btn.eql) {
      //if equal to is pressed  calculate
      calculate();
      return;
    }

    //if the above conditions are not met => then the pressed value will be (dot.) or (numbers) or (operators)
    assignValue(value);
  }

  void delete() {
    //checking from backwards (78*55) <==
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (op.isNotEmpty) {
      //since operator is a single value , then just delete it
      op = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    //if (_ _ _) num1 - operator - num2 is empty => check for top value
    else if (top.isNotEmpty) {
      //whatever in the top value , if bottom is empty (0) then top should be empty(zero)
      top = "";
    }

    setState(() {});
  }

  void clear() {
    setState(() {
      num1 = op = num2 = top = "";
    });
  }

  void percent() {
    if (num1.isEmpty) return; //if num1 itself doesn't exist => just return
    //checking from backwards 64+88 <==
    if (num1.isNotEmpty && op.isNotEmpty && num2.isNotEmpty) {
      //if already expression is exists then evaluate it and find percentage for it
      calculate();
      //once calculated num1 only exists (num2 = op = "")
      //once calculated then find percent
    }

    if (op.isNotEmpty) {
      //if the above if condition executed then the op and num2 will be empty , hence this won't be execcuted
      //if operator already exista => (54-) finding percentage for it is not valid
      return;
    }

    //num1 only exists
    final number = double.tryParse(num1);

    setState(() {
      num1 = "${(number! / 100)}";
      //once calulated the expression and found percentage => then make operator and number2 to empty
      num2 = op = "";
    });
  }

  void calculate() {
    //calculate the expression 98+22

    //if num1 is empty then no need to calclate , the pressed is a false one .
    if (num1.isEmpty) return; //priority high
    if (op.isEmpty) return;
    if (num2.isEmpty) return;

    //convert the numbers (string) => (double)
    double n1 = double.parse(num1);
    double n2 = double.parse(num2);

    var result = 0.0; //double type

    switch (op) {
      case Btn.add:
        result = n1 + n2;
        break;
      case Btn.sub:
        result = n1 - n2;
        break;
      case Btn.mul:
        result = n1 * n2;
        break;
      case Btn.div:
        result = n1 / n2;
        break;
      default:
    }

    setState(() {
      top = "$num1$op$num2";
      num1 = "$result";

      //if answer ends with (65.0) make to => (65) remove (.0)
      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }

      //once calculated then make num2 and operator to Empty
      op = num2 = "";
    });
  }

  void assignValue(String value) {
    if (value != Btn.dot && (int.tryParse(value) == null)) {
      //this block will be executed when operator clicked
      //operator clicked
      if (op.isNotEmpty && num2.isNotEmpty) {
        //evaluate the existing expression 9+3 and add the operator
        //TODO: Calculate()
        calculate();
      }

      //calculated and operator added (40) (new: +) <=
      op = value;
    } else if (num1.isEmpty || op.isEmpty) {
      //this block will be executed when Numbers are clicked
      //num1 or operator is empty then , no operator hence append the numbers i num1

      if (value == Btn.dot && num1.contains(Btn.dot)) {
        //if dot(.) pressed and already dot(.) exists jsut leave it
        return;
      }
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.zero)) {
        //num1 might be zero , hence make (0) => .0
        value = "0.";
      }
      //once the last if is executed(0.) then the next numbers are appended to num1
      num1 = num1 + value;
    } else if (num2.isEmpty || op.isNotEmpty) {
      //this block will be executed when Numbers are clicked
      //num2 is empty or operator is not empty => then (9+_) append the numers in num2

      if (value == Btn.dot && num2.contains(Btn.dot)) {
        //if dot(.) pressed and already dot(.) exists jsut leave it
        return;
      }
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.zero)) {
        //num1 might be zero , hence make (0) => .0
        value = "0.";
      }
      //once the last if is executed(0.) then the next numbers are appended to num1
      num2 = num2 + value;
    }

    setState(() {});
  }

  Color btnColor(value) {
    return [Btn.clr, Btn.del].contains(value)
        ? Colors.blueGrey
        : [Btn.per, Btn.div, Btn.mul, Btn.add, Btn.sub, Btn.eql].contains(value)
            ? Colors.amber
            : Colors.black26;
  }
}
