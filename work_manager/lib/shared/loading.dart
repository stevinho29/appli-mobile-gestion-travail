import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      color: Colors.cyan,
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
