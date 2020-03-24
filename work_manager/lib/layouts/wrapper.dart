import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/layouts/home/home.dart';
import 'package:workmanager/models/user.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<User>(context);
    print(user);
    if( user == null)
      return Authenticate();
    else
      return Home();
  }


}