import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/news/main_news.dart';
import 'package:work_manager/layouts/home/propositions/main_propositions.dart';

class MainHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainHomeState();
  }
}

class _MainHomeState extends State<MainHome>{

String value;
  didChangeDependencies() {
    super.didChangeDependencies();
    final value = Provider.of<ConnectivityResult>(context).toString();
    if (value.contains("mobile")) {
      this.value = value;
      print(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 5),
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