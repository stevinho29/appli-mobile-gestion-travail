import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_manager/models/user.dart';


import 'new_tile.dart';

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

    final user = Provider.of<User>(context);
    // TODO: implement build
    return StreamBuilder<List<News>>(
      stream: null,
      builder: (context, snapshot) {
        List list= snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return NewsTile(propositionsData: list[index]);
            },);
        }else
          return Container(
            child: Text("UP TO DATE"),
          );
      }
    );
  }

}