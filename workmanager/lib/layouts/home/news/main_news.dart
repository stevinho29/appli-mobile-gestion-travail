
import 'package:flutter/material.dart';

class News extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsState();
  }
}

class _NewsState extends State<News>{

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return StreamBuilder<int>(
      stream: null,
      builder: (context, snapshot) {
        //List list= snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
             // return NewsTile(propositionsData: list[index]);
              return Scaffold(
                body: Center(child: Text(snapshot.toString())),
              );
            },);
        }else
          return Container(
              child: ListTile(
                title: Center(child: Icon(Icons.more_horiz)),
              ),
          );
      }
    );
  }

}