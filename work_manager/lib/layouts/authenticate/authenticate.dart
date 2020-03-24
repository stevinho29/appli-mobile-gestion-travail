import 'package:flutter/material.dart';
import 'package:workmanager/layouts/authenticate/register.dart';
import 'package:workmanager/layouts/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AuthenticateState();
  }
}
class _AuthenticateState extends State<Authenticate>{
  bool showSignIn= true;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return showSignIn ? SignIn( toggleView: toggleView): Register( toggleView: toggleView);
  }

}

