import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/layouts/home/account.dart';
import 'package:workmanager/layouts/home/employeur.dart';
import 'package:workmanager/services/auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'employe.dart';
import 'main_home.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  final AuthService _authService = AuthService();
  final _controller = PageController(
    initialPage: 1,
  );
  static Color _colorActive= Colors.cyan;
  static Color _colorInactive= Colors.grey;

  static int _pagePosition= 1;
  static int _previousPagePosition;


  int _currentSlideVal= 100;

  int getPage(int page){
    _previousPagePosition= _pagePosition;
    _pagePosition= (page -_previousPagePosition);
    print(_pagePosition);
    return _pagePosition;


    /*if(_pagePosition > page)
     return _pagePosition.toDouble()-page.toDouble();
    else if( _pagePosition < page)
      return page.toDouble() - _pagePosition.toDouble();
*/
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
     /* appBar: AppBar(
        centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.settings),
                label: Text(''),
                onPressed: () async {
                  await _authService.signOut();
                  _deleteSharedPrefs();
                }),
          ]), */
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
                        child: GestureDetector(child: Icon(Icons.new_releases,color: _colorActive,key: Key("first")),
                            onTap: (){ setState((){
                              setState(() {
                                _currentSlideVal= 100;
                                print(_controller.page);
                                _controller.jumpTo(0.0);
                              });
                            });
                            })),
                        Expanded(
                            child:GestureDetector(child:Icon(Icons.work,color: Colors.cyan,key: Key("second")),
                                onTap: (){ setState((){
                                  setState(() {
                                    _currentSlideVal= 100+ 1*100;
                                    print(_controller.page);
                                    _controller.jumpTo(.0);
                                  });
                                });
                                })),
                        Expanded(
                            child:GestureDetector(child:Icon(Icons.account_balance,color: Colors.cyan,key: Key("third")),
                                onTap: (){ setState((){
                                  setState(() {
                                    _currentSlideVal= 100+ 2*100;
                                    print(_controller.page);
                                    _controller.jumpTo(3.0);
                                  });
                                });
                                })),
                        Expanded(
                            child:GestureDetector(child:Icon(Icons.account_circle,color: Colors.cyan,key: Key("fourth")),
                                onTap: (){ setState((){
                                  setState(() {
                                    _currentSlideVal= 100+ 3*100;
                                    print(_controller.page);
                                    _controller.jumpTo(0.0);
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
                    Employeur(),
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

Future<bool> _deleteSharedPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.clear();
}


