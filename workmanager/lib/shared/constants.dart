

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


const textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: false,
    contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width:2.0),
    borderRadius: const BorderRadius.all(const Radius.circular(10.0))
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
        borderRadius: const BorderRadius.all(const Radius.circular(10.0))
    )
);

List<Widget> loadingWidget=
<Widget>[
  Expanded(
    child:SpinKitChasingDots(color: Colors.cyanAccent, size: 50.0,),
  ),
];

final snackBar = SnackBar(
  content: Text("Vous n\'etes pas connecté à internet...les opérations que vous performez peuvent ne pas aboutir"),
);
