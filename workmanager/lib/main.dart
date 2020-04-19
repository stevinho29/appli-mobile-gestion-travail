import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/services/auth.dart';
import 'layouts/wrapper.dart';
import 'models/user.dart';

//version 2.0
void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

/*
  Workmanager.initialize(callbackDispatcher,isInDebugMode:
  true );// If enabled it will post a notification whenever the task is running. Handy for debugging tasks);
  Workmanager.registerOneOffTask(
    "1",
    "test",
    initialDelay: Duration(seconds: 0),
    inputData: <String, dynamic>{
      'int': 1,
      'bool': true,
      'double': 1.0,
      'string': 'string',
      'array': [1, 2, 3],
    },
  );
*/


}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}

/*
void callbackDispatcher() {
  Workmanager.executeTask((task,inputData) {
    switch (task) {
      case "test":
        print("this method was called from native!");
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
}*/
