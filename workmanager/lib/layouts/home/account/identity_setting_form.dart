import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/userDao.dart';
import 'package:work_manager/shared/constants.dart';


class IdentitySetting extends StatefulWidget{

  UserData userData;
  IdentitySetting({this.userData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _IdentitySettingState();
  }

}

class _IdentitySettingState extends State<IdentitySetting>{

  final _formKey= GlobalKey<FormState>();

  String _rue;
  String _codePostal;
  int _num;
  Map<String,String> _address= new Map();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
            child: Form(
              key:_formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: widget.userData.address== "null" ? 'non renseigné': widget.userData.address,
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText: "Adresse").copyWith(labelText: "Adresse"),
                    validator: (val) {
                          return val.isEmpty ? "veuillez saisir votre rue": null;
                          },
                    onChanged: (val) {
                          setState(() => _rue = val);
                        },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    initialValue: widget.userData.codePostal== "null" ? 'non renseigné': widget.userData.codePostal,
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText: "Code postal").copyWith(labelText: "Code postal"),
                    validator: (val) {
                      return val.isEmpty ? "veuillez saisir votre code postal": null;
                    },
                    onChanged: (val) {
                      setState(() => _codePostal = val);
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                    initialValue: (widget.userData.tel == 0) ? '0': widget.userData.tel.toString(),
                    style: TextStyle(color: Colors.black87),
                    decoration: textInputDecoration.copyWith(hintText: "num tel").copyWith(labelText: "numéro de tel"),
                    validator: (val) {
                      try{
                        int tel= num.tryParse(val).toInt();
                        return tel.toString().length <8 ? "pas assez de digit": null;
                      }catch(e){
                        print(e);
                        return " erreur : champs vide ou donnée inattendu";
                      }

                    },
                    onChanged: (val) {
                      try{
                        int tel= num.tryParse(val).toInt();
                        setState(() => _num = tel);
                      }catch(e){
                        print(e);
                      }

                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
                    child: RaisedButton(
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: Row(children: <Widget>[
                            Icon(Icons.update)
                          ]),
                        ),
                        onPressed: () async {
                            if(_formKey.currentState.validate()){
                              _address['code_postal']= _codePostal ?? widget.userData.codePostal;
                              _address['address']= _rue ?? widget.userData.address;
                              _num= _num ?? widget.userData.tel;
                              print("code ${_address['code_postal']}");
                              print("address ${_address['address']}");
                              await UserDao(user.uid).updateUserData(_address,_num);
                              await Alert().goodAlert(context, " mise à jour", "l'opération de mise à jour s'est déroulée avec succès");
                              Navigator.pop(context);
                            }
                        }
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

}
