import 'dart:async';

import 'package:flutter/material.dart';

import 'app/pages/CountDownScreen.dart';
import 'app/pages/diceScreen.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int index = 0;
  int count = 0;
  
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        count = timer.tick;
      });

      if(timer.tick > 3){
        index = 1;
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List screenList = [
      CountDownScreen(
        startCount: count,
      ),
      DiceScreen(
        screenWidth: MediaQuery.of(context).size.width,
      )
    ];
    return Scaffold(
      body: screenList[index],
    );
  }
}
