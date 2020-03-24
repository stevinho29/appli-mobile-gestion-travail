import 'package:flutter/material.dart';
import 'package:workmanager/services/auth.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
          title: Text("Bienvenue"),
          backgroundColor: Colors.cyanAccent[100],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.settings),
                label: Text(''),
                onPressed: () async {
                  await _authService.signOut();
                }),
          ]),
    );
  }
}
