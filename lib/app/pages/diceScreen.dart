import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shuffle_dice/app/pages/scoreBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiceScreen extends StatefulWidget {
  DiceScreen({this.screenWidth});
  final screenWidth;

  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  int score = 0;
  double width = 0.0;
  int gameTimer = 60;
  bool isIgnoring = false;
  bool checkValue;
  int tempnum;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 300), (Timer timer) {
      setState(() {
        width += widget.screenWidth / 59.8;
      });

      if (timer.tick == gameTimer) {
        setState(() {
          isIgnoring = true;
        });
        storingData(
          score: score,
        );

        timer.cancel();

        navigateTogameScreen();
      }
    });
    randDice();
  }

  Future storingData({int score}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    checkValue = sharedPreferences.containsKey("highscore");

    // * 😜 checking score-history of user
    if (checkValue) {
      print("highscore is heree");
      if (score < sharedPreferences.getInt("highscore")) {
        sharedPreferences.setInt("score", score);
      } else {
        sharedPreferences.setInt("highscore", score);
        sharedPreferences.setInt("score", score);
      }
    } else {
      sharedPreferences.setInt("highscore", score);
      sharedPreferences.setInt("score", score);
    }
  }

  int randNum;
  String _randDiceNmme;

  int userRandNum;
  String _userRandDiceName = "1-dice.jpg";

  List<String> _listOfDice = [
    "1-dice",
    "2-dice",
    "3-dice",
    "4-dice",
    "5-dice",
    "6-dice",
  ];

  Map<String, String> _mapedDice = {
    "1-dice": "1-dice.jpg",
    "2-dice": "2-dice.jpg",
    "3-dice": "3-dice.jpg",
    "4-dice": "4-dice.jpg",
    "5-dice": "5-dice.jpg",
    "6-dice": "6-dice.jpg",
  };

  void randDice() {
    setState(() {
      randNum = Random().nextInt(6);
      _randDiceNmme = _mapedDice[_listOfDice[randNum]];
    });
    print(_randDiceNmme);
  }

  void userRandDice() {
    setState(() {
      userRandNum = Random().nextInt(6);
      // * 😜 checking if userRandNum contains pervious number
      if (userRandNum == tempnum) {
        userRandNum = Random().nextInt(6);
      }
      tempnum = userRandNum;
      _userRandDiceName = _mapedDice[_listOfDice[userRandNum]];
    });

    if (_userRandDiceName == _randDiceNmme) {
      print("Congrats");
      setState(() {
        score++;
        randNum = Random().nextInt(6);
        if (randNum == tempnum) {
          randNum = Random().nextInt(6);
        }
        _randDiceNmme = _mapedDice[_listOfDice[randNum]];
      });

      print(score);
    }
  }

  void navigateTogameScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> firstAnimation,
                Animation<double> secondAnimation) =>
            ScoreBoard(),
        transitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, Widget child) {
          var begin = Offset(100, 0.0);
          var end = Offset.zero;
          Curve curve = Curves.easeInCirc;

          var tween = Tween(begin: begin, end: end)
            ..chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0.0,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: widget.screenWidth,
                        height: 4.5,
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                      Container(
                        width: width,
                        height: 4.5,
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                    ],
                  ),
                  Text(
                    "Score: $score",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IgnorePointer(
                    ignoring: isIgnoring,
                    child: InkWell(
                      onTap: userRandDice,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  offset: Offset(5, 3),
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.85),
                                  offset: Offset(-5, -3),
                                  blurRadius: 5),
                            ],
                          ),
                          width: 100,
                          height: 100,
                          child: Card(
                            elevation: 0,
                            semanticContainer: false,
                            shape: RoundedRectangleBorder(),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.asset(
                              _userRandDiceName,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // * ™ ©
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: Offset(5, 3),
                              blurRadius: 5),
                          BoxShadow(
                              color: Colors.white.withOpacity(0.85),
                              offset: Offset(-5, -3),
                              blurRadius: 5),
                        ],
                      ),
                      width: 100,
                      height: 100,
                      child: Card(
                        elevation: 0,
                        semanticContainer: false,
                        shape: RoundedRectangleBorder(),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          _randDiceNmme,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
