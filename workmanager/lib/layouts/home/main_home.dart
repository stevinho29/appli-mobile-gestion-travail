import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/news/main_news.dart';
import 'package:work_manager/layouts/home/propositions/main_propositions.dart';

import 'package:work_manager/models/user.dart';

class MainHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainHomeState();
  }
}

class _MainHomeState extends State<MainHome>{

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      child: ListView(
      children: <Widget>[
        Text("Actualités"),
        SizedBox(height: 10),
        Container(
          decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
          border: new Border.all(
              color: Colors.cyan,
              width: 2.0,
              style: BorderStyle.solid) ),
          height: 180,
          child: News(),
        ),
        SizedBox(height: 10,),
        Text("Propositions"),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.all(5),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
              border: new Border.all(
                  color: Colors.cyan,
                  width: 2.0,
                  style: BorderStyle.solid) ),
          height: 180,
          child: PropositionsOverview(),
        ),
      ],
      )
    );
  }



}