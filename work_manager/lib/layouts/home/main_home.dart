import 'package:flutter/material.dart';
import 'package:workmanager/layouts/news/main_news.dart';
import 'package:workmanager/layouts/propositions/main_propositions.dart';

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
    // TODO: implement build
    return Container(
      child: ListView(
      children: <Widget>[
        Container(
          height: 200,
          child: News(),
        ),
        SizedBox(height: 10,),
        Container(
          height: 200,
          child: Propositions(),
        ),
      ],
      )
    );
  }

}