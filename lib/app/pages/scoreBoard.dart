import 'package:flutter/material.dart';
import 'package:flutter_shuffle_dice/app/pages/diceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreBoard extends StatefulWidget {
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  int score;
  int highScore;
  @override
  void initState() {
    super.initState();
    fetchScore();
  }

  Future fetchScore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      score = sharedPreferences.getInt("score");
      highScore = sharedPreferences.getInt("highscore");
    });
  }

  void navigateTogameScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> firstAnimation,
                Animation<double> secondAnimation) =>
            DiceScreen(
          screenWidth: MediaQuery.of(context).size.width,
        ),
        transitionDuration: Duration(milliseconds: 200),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondAnimation, Widget child) {
          var begin = Offset(-100, 0.0);
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
          width: size.width / 1.5,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "Score",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        score.toString(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              Text(
                "Highscore: ${highScore.toString()}",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => navigateTogameScreen(),
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //     builder: (context) => DiceScreen(
        //           screenWidth: MediaQuery.of(context).size.width,
        //         ))),
        child: Icon(
          Icons.play_arrow,
          color: Colors.red,
          size: 32,
        ),
      ),
    );
  }
}
