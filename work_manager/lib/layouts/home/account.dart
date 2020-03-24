import 'package:flutter/material.dart';
import 'package:workmanager/shared/constants.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountState();
  }
}

class _AccountState extends State<Account> {

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Profil et réglages",style: TextStyle(fontSize: 17.0,color: Colors.cyan),)
          ],),
        Container(
          height: 50,
          color: Colors.white,
          child:  Row(
              children:<Widget>[Icon(Icons.person), Text('identité')]),
        ),
        Container(
          height: 50,
          color: Color(0xffe100ff),
          child: Row(
              children:<Widget>[Icon(Icons.settings), Text('Préférences')]),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: Row(
              children:<Widget>[Icon(Icons.lock), Text('Sécutité')]),
        ),
      ],
    );
  }
}
