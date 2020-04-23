import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
    return Container(
        height: 200,
        child: Icon(Icons.more_horiz,size: 40,),
      );
  }

}

class Error extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text('une erreur s\'est produite'),
        )
      ],
    );;
  }

}

class Indicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          width: 60,
          height: 60,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Awaiting result...'),
        )
      ],
    );
  }

}