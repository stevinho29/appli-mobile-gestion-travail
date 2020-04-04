import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_manager/layouts/home/main_home_layout.dart';
import 'package:work_manager/models/user.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<User>(context);

    // ignore: missing_return
    _getSharedPrefs().then((status){
      if(!status)
        return Authenticate();
    });



    print(user);
    if( user == null)
      return Authenticate();
    else
      return Home();
  }
}

Future<bool> _getSharedPrefs() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if( prefs.getString("email") != null && prefs.getString("password") != null)
    return true;
  else
    return false;
}