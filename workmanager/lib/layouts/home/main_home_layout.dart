import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/home/account.dart';
import 'package:work_manager/layouts/home/work.dart';
import 'package:work_manager/models/user.dart';
import 'employe.dart';
import 'main_home.dart';

class Home extends StatefulWidget {

  Stream<int> timedCounter(Duration interval, [int maxCount]) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
      if (i == maxCount) break;
    }
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
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
        print("onMessage: ${message}");

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<User>(context);
  }

  final _controller = PageController(
    initialPage: 0,
  );
  static Color _colorActive= Colors.cyan;
  static Color _colorInactive= Colors.grey;

  Icon actu = Icon(Icons.new_releases,color: _colorActive,key: Key("first"));
  Icon work = Icon(Icons.work,color: _colorActive,key: Key("second"));
  Icon balance= Icon(Icons.account_balance,color: Colors.cyan,key: Key("third"));
  Icon account= Icon(Icons.account_circle,color: Colors.cyan,key: Key("fourth"));

  int _currentSlideVal= 100;

  
  @override
  Widget build(BuildContext context) {




    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,

      body:
          Container(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                        child: GestureDetector(child: actu,
                            onTap: (){ setState((){
                              setState(() {
                                _currentSlideVal= 100;
                                if ( _controller.hasClients) {
                                  _controller.animateToPage(
                                    0,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              });
                            });
                            })),
                        Expanded(
                            child:GestureDetector(child:work,
                                onTap: (){ setState((){
                                  setState(() {
                                    if (_controller.hasClients) {
                                      _controller.animateToPage(
                                        1,
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                      actu= Icon(Icons.new_releases,color: _colorInactive,key: Key("first"));

                                    }
                                  });
                                });
                                })),
                        Expanded(
                            child:GestureDetector(child:balance,
                                onTap: (){ setState((){
                                  setState(() {
                                    _currentSlideVal= 100+ 2*100;
                                    if (_controller.hasClients) {
                                      _controller.animateToPage(
                                        2,
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                });
                                })),
                        Expanded(
                            child:GestureDetector(child:account,
                                onTap: (){ setState((){
                                  setState(() {
                                    _currentSlideVal= 100+ 3*100;
                                    if (_controller.hasClients) {
                                      _controller.animateToPage(
                                        3,
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                });
                                }))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child:Slider(
                            value: _currentSlideVal.toDouble(),
                            activeColor:
                            Colors.cyan,
                            inactiveColor:
                            Colors.grey,
                            min: 100,
                            max: 400,
                            divisions: 3,
                            onChanged: (val) {
                              //setState(() => _currentSlideVal = val.round());
                            },
                          )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child:PageView(
                  controller: _controller,
                  onPageChanged: (val) {
                    setState(() {
                      _currentSlideVal= 100+val*100;
                    });
                  },
                  children: <Widget>[
                    MainHome(),
                    Work(),
                    Employe(),
                    Account()
                  ],
                ),
                )
              ],
            ),
          ),
    );
  }
}

