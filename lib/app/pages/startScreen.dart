import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../gameScreen.dart';
import 'diceScreen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int highScore;
  @override
  void initState() {
    super.initState();
    fetchScore();
  }

  Future fetchScore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      highScore = sharedPreferences.getInt("highscore");
    });
  }

  void navigateTogameScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> firstAnimation,
                Animation<double> secondAnimation) =>
            GameScreen(),
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            width: size.width / 1.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "HighScore",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  highScore.toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                // FadeTransition(opacity: null)
                // SlideTransition(position: null)
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            navigateTogameScreen();
          },
          child: Icon(
            Icons.play_arrow,
            color: Colors.red,
            size: 28,
          ),
        ));
  }
}
