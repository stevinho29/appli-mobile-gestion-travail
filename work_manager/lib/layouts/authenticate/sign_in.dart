import 'package:flutter/material.dart';
import 'package:workmanager/layouts/authenticate/sendResetPasswordEmail.dart';
import 'package:workmanager/services/auth.dart';
import 'package:workmanager/shared/constants.dart';
import 'package:workmanager/shared/loading.dart';

class SignIn extends StatefulWidget{

  final Function toggleView;
  SignIn({this.toggleView});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignInState();
  }
}

class _SignInState extends State<SignIn>{

  final AuthService _authService = AuthService();
  final _formKey= GlobalKey<FormState>();


  bool loading =false;
  bool passwordVisible= true;
  String email= '';
  String password= '';
  String error='';
  String errorReset='';



  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return loading? Loading():Scaffold(
        resizeToAvoidBottomInset: false, // disabled les widgets flottants
        backgroundColor: Colors.cyan,

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg2.png'),
                fit: BoxFit.cover
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Icon(
                    Icons.lock_open,
                    size: 100.0,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    autofocus: false,
                    style: TextStyle(color: Colors.black),
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    validator: (val) {
                      return val.isEmpty ? "Entrez un email": null;
                    },
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    autofocus: false,
                    style: TextStyle(color: Colors.black,),
                    decoration: textInputDecoration.copyWith(hintText: "Mot de passe").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() => passwordVisible = !passwordVisible);
                        },
                      ),
                    ),
                    validator: (val) {
                      return val.length < 6 ? "pas assez de caractères( 6 ) ": null;
                    },
                    obscureText: passwordVisible,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: Colors.white,
                    child: Text("Se connecter", style: TextStyle(color: Colors.black)),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _authService.signInWithRegisterAndPassword(email, password);
                        if (result == null){
                          setState(() {
                            loading = false;
                            error= "svp entrez un email valide";
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 12.0),
                  GestureDetector(
                    child: Text("mot de passe oublié ?"),
                    onTap: () {
                      showSendEmailDialog(context);
                    },
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            widget.toggleView();
          },
          label: Text('créer mon compte'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
}