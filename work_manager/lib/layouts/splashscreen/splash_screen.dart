import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shimmer/shimmer.dart';

import '../wrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}


class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _showSplashScreen().then((value) {

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => Wrapper()));});

    return  Scaffold(
      body: Container(
        child: Center(
            child: Shimmer.fromColors(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Do..it",
                    style: TextStyle(
                        fontSize: 90.0,
                        fontFamily: 'Pacifico',
                        shadows: <Shadow>[
                          Shadow(
                              blurRadius: 18.0,
                              color: Colors.black87,
                              offset: Offset.fromDirection(120,12)
                          ),

                        ]),
                  ),
                ),
                baseColor: Color(0xff7f00ff),
                highlightColor: Color(0xffe100ff))
        ),
      ),
    );
  }


}

// on attends 2 s pour montrer le splashscreen
Future<bool> _showSplashScreen() async {
  await Future.delayed(Duration(milliseconds: 2000),() {});
return true;
}
