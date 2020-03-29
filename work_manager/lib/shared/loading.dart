import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      color: Colors.white,
      child: Center(
          child: Column( children: <Widget>[
            Expanded(
              child:SpinKitChasingDots(color: Colors.cyanAccent, size: 50.0,),
            ),
          ])
      ),
    );
  }
}

class Blank extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 200,
        child: Icon(Icons.more_horiz,size: 40,),
      );
  }

}