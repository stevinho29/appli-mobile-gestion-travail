import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:work_manager/models/user.dart';


import '../main_home_layout.dart';
import 'new_tile.dart';

class News extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsState();
  }
}

class _NewsState extends State<News>{

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
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