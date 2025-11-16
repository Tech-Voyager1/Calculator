import 'package:flutter/material.dart';

class OldCalc extends StatefulWidget {
  const OldCalc({super.key});

  @override
  State<OldCalc> createState() => _OldCalcState();
}

class _OldCalcState extends State<OldCalc> {
  String currentValue = "";
  String firstValue = "";
  String lastValue = "";
  String operator = "";
  String topvalue = "";
  String bottomValue = "";
  String leftOperand = "";

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "CALCULATOR",
            style: TextStyle(
                fontSize: 30, color: Colors.amber, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 30, left: 20, right: 20),
              child: Container(
                height: height / 3.5,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                alignment: Alignment.bottomRight,
                // child: Padding(
                //   padding: const EdgeInsets.all(.0),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       Text(
                //         topvalue,
                //         style: TextStyle(fontSize: 50),
                //         // textAlign: TextAlign.right,
                //       ),
                //       Text(
                //         bottomValue,
                //         style: TextStyle(fontSize: 80),
                //       ),
                //     ],
                //   ),
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment:
                        CrossAxisAlignment.end, // align text to right
                    children: [
                      // 🔹 TOP VALUE (moves in smoothly)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          // slide + fade effect
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin:
                                  const Offset(0, 0), // starts slightly below
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                                opacity: animation, child: child),
                          );
                        },
                        child: Text(
                          topvalue,
                          key: ValueKey(
                              topvalue), // important! triggers animation on change
                          style: const TextStyle(
                              fontSize: 50, color: Colors.black38),
                        ),
                      ),

                      // 🔹 BOTTOM VALUE (new input or result)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0), // slides from below
                              end: Offset.zero,
                            ).animate(animation),
                            child: FadeTransition(
                                opacity: animation, child: child),
                          );
                        },
                        child: Text(
                          bottomValue,
                          key: ValueKey(bottomValue), // triggers animation
                          style: const TextStyle(
                              fontSize: 80, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        createButton(context, "7", Colors.grey),
                        createButton(context, "8", Colors.grey),
                        createButton(context, "9", Colors.grey),
                        createButton(context, "/", Colors.amber),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        createButton(context, "4", Colors.grey),
                        createButton(context, "5", Colors.grey),
                        createButton(context, "6", Colors.grey),
                        createButton(context, "x", Colors.amber),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        createButton(context, "3", Colors.grey),
                        createButton(context, "2", Colors.grey),
                        createButton(context, "1", Colors.grey),
                        createButton(context, "-", Colors.amber),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        createButton(context, "0", Colors.grey),
                        createButton(context, "Clear", Colors.amber),
                        createButton(context, "=", Colors.amber),
                        createButton(context, "+", Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget createButton(BuildContext context, text, Color color) {
    return GestureDetector(
      onTap: () => {
        if (text == "Clear")
          {
            setState(() {
              currentValue = "";
              operator = "";
              lastValue = "";
              firstValue = "";
              topvalue = bottomValue = leftOperand = "";
            }),
          }
        else if (text == "/" || text == "x" || text == "-" || text == "+")
          {
            setState(() {
              if (operator.isEmpty) {
                firstValue = currentValue;
                topvalue = currentValue;
                currentValue = "";
              }

              bottomValue = text;
              operator = text;
              print("Operator $text is Clicked");
            }),
          }
        else if (text == "=")
          {
            if (operator.isNotEmpty)
              {
                setState(() {
                  double first = double.parse(firstValue);
                  double last = double.parse(currentValue);
                  print("$first $operator $last");
                  topvalue = topvalue + currentValue;
                  switch (operator) {
                    case "+":
                      bottomValue = currentValue = (first + last).toString();
                      break;
                    case "-":
                      bottomValue = currentValue = (first - last).toString();
                      break;
                    case "x":
                      bottomValue = currentValue = (first * last).toString();
                      break;
                    case "/":
                      bottomValue = currentValue = (first / last).toString();
                      break;
                    default:
                  }
                }),
              }
          }
        else
          {
            setState(() {
              if (operator.isNotEmpty) {
                if (leftOperand.isNotEmpty) {
                  print(
                      "leftopernad is not empty \n leftOperand is $leftOperand");
                  bottomValue = bottomValue + text;
                  currentValue = bottomValue;
                } else {
                  print("Left operand is empty");
                  topvalue = topvalue + operator;
                  leftOperand = text;
                  currentValue = text;
                  bottomValue = text;
                }
              } else {
                currentValue = currentValue + text;
                bottomValue = currentValue;
                print("currentValue is $currentValue");
              }
            }),
          },
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.width / 5,
          width: MediaQuery.of(context).size.width / 5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
