import 'package:flutter/material.dart';
import 'package:work_manager/services/auth.dart';
import 'package:work_manager/shared/constants.dart';
import 'package:work_manager/shared/loading.dart';

class Register extends StatefulWidget{

  final Function toggleView;
  Register({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }

}

class _RegisterState extends State<Register>{

  final AuthService _authService = AuthService();
  final _formKey= GlobalKey<FormState>();

  bool loading =false;
  bool passwordVisible= true;
  bool check= false;
  String name= '';
  String surname= '';
  String email= '';
  String password= '';
  String error='';


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
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Icon(
                Icons.account_circle,
                size: 75.0,
                semanticLabel: 'rejoins-nous',
              ),
              SizedBox(height: 5.0),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: textInputDecoration.copyWith(hintText: "Nom"),
                validator: (val) {
                  return val.isEmpty ? "veuillez saisir votre nom": null;
                },
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: textInputDecoration.copyWith(hintText: "Prenom"),
                validator: (val) {
                  return val.isEmpty ? "veuillez saisir votre prenom": null;
                },
                onChanged: (val) {
                  setState(() => surname = val);
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) {
                  return val.isEmpty ? "saisissez votre email": null;
                },
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                style: TextStyle(color: Colors.white),
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
                  return val.length < 6 ? "pas assez de caractères ": null;
                },
                obscureText: passwordVisible,
                onChanged: (val){
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: textInputDecoration.copyWith(hintText: "confirmez votre mdp"),
                /*validator: (val) {
                  return val != password  ? "mots de passes sont différents": null;
                },*/
                obscureText: true,
                onChanged: (val) {}
              ),
              SizedBox(height: 5.0),
              CheckboxListTile(
                secondary: Text("j'accepte les conditions\n d'utilisation ") ,
                onChanged: (bool value) => setState(() {check= !check;}),
                value: check,

              ),
              SizedBox(height: 0.0),
              RaisedButton(
                color: Colors.white,
                child: Icon(Icons.send),
                onPressed: () async {
                  if(check) {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _authService.registerWithEmailAndPassword(name,surname,email, password);
                      if (result == null) {
                        setState(() {
                          loading = false;
                          error = "email non valide";
                        });
                      }
                    }
                  }else{
                    setState(() {
                      error = "acceptez les conditions";
                    });
                  }
                },
              ),
              SizedBox(height: 5.0),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.toggleView();
        },
        label: Text('deja inscrit ?'),
        icon: Icon(Icons.lock_open),
        backgroundColor: Colors.pinkAccent,
      ),
      );

  }

}