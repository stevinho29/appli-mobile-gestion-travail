import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/news/main_news.dart';
import 'package:work_manager/layouts/home/propositions/main_propositions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/userDao.dart';

class MainHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainHomeState();
  }
}

class _MainHomeState extends State<MainHome>{

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  // ...

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

  dynamic fct= () async {
      // Get the token for this device
      String fcmToken = await _fcm.getToken();
      // Save it to Firestore
      print("USER UID ${user.uid}");
      await UserDao(user.uid).updateUserDataWithToken(fcmToken, Platform.operatingSystem);
    };

  fct();

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

  /// Get the token, save it to the database for current user

}