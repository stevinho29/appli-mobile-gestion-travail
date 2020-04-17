import 'package:flutter/material.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/layouts/authenticate/sendResetPasswordEmail.dart';
import 'package:work_manager/services/auth.dart';
import 'package:work_manager/shared/constants.dart';
import 'package:work_manager/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget{

  final Function toggleView;
  SignIn({this.toggleView});


  @override
  State<StatefulWidget> createState() {
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
                    Icons.lock,
                    size: 100.0,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    autofocus: false,
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white,),
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
                    child: Icon(Icons.lock_open),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                      await _authService.signInWithRegisterAndPassword(email, password).then((result) async {
                        setState(() {
                          loading = false;
                        });
                        if (result == 0){
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString(("email"), email);
                          prefs.setString("password", password);
                        }
                        else{
                          switch(result){
                            case 1: Alert().badAlert(context, "Mot de passe érroné", "le mot de passe ne correspond pas ");break;
                            case 2: Alert().badAlert(context, "Email non valide", "l'adresse email utilisée n'est pas correcte");break;
                            case 3: Alert().badAlert(context, "utilisateur non trouvé", "aucun utilisateur ne correspond à cette adresse mail ");break;
                            case 4: Alert().badAlert(context, "Connexion impossible", "votre compte a été désactivé");break;
                            case 5: Alert().badAlert(context, "Connexion désactivée", "Vous avez tentez plusieurs fois de vous connecter,\n il vous est donc impossible de vous connecter pendant un certain temps");break;
                            case 6: Alert().badAlert(context, "Connexion impossible", "Impossible d'établir une connexion avec les serveurs");break;
                            default:  Alert().badAlert(context, "Une erreur s'est produite", "Une erreur s'est produite, veuillez réessayer plus tard");
                          }
                        }
                      });

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