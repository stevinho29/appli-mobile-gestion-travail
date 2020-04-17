import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/propositionDao.dart';
import 'package:work_manager/services/databases/userDao.dart';
import 'package:work_manager/shared/constantSalary.dart';

import 'package:work_manager/shared/constants.dart';

class PropositionMaker extends StatefulWidget{

  UserData choosedUser;
  PropositionMaker({this.choosedUser});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PropositionMakerState();
  }

}

enum Planning { fixe, variable} // nécessite un planning hebdomadaire(variable) ou alors fixe
class _PropositionMakerState extends State<PropositionMaker>{

  final priceController= TextEditingController();
  final hourPerWeekController= TextEditingController();
  final _formKey= GlobalKey<FormState>();
  String error="";
  String _currentLibelle ;
  String _currentOrigin= "employer";  // whether if the proposition comes from an employer or an employee
  String _currentDescription;       //description de la proposition
  double _currentPricePerHour;
  double _currentHourPerWeek= 25.0;       // nombre d'heures de travail par semaine
  Map<String,DateTime> dat= new Map();

  Planning _planning = Planning.fixe;
  bool planningVariable= false;
  DateTime _currentStartDate= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1);
  DateTime _currentEndDate= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1);
  String _endDate;
  String _startDate;
  Future selectedDate(BuildContext context,String side) async {
    showDatePicker(
      context: context,
      initialDate: _currentStartDate ,
      firstDate:  DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
      lastDate: DateTime(DateTime.now().year+1,DateTime.now().month,DateTime.now().day+1),
    ).then((value) {
      if(side == "left") {
        if(value != null) {
          setState(() {
            _currentStartDate = value;
            _startDate = value.toString().split(" ")[0];
            print(_startDate);
          });
        }
      }
      else{
        if(value != null) {
          setState(() {
            _currentEndDate = value;
            _endDate = value.toString().split(" ")[0];
            print(_endDate);
          });
        }
      }
    });

  }

  final _controller = PageController(
    initialPage: 0,
  );
  bool visibility= true;


  @override
  void dispose() {
    super.dispose();
    priceController.dispose();
    hourPerWeekController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String numberValidator(String value) {
      if(value == null) {
        return "saisissez un montant valide";
      }
      final n = num.tryParse(value);
      if(n == null) {
        return 'saisissez un montant valide';
      }
      else{
        if(n.toDouble() < minNetSalary)
          return " minimum est de $minNetSalary €";
        else {
          setState(() {
            _currentPricePerHour= n.toDouble();
          });
          return null;
        }
      }
    }
    final user = Provider.of<User>(context);

    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB( 60, 20, 20, 0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: RaisedButton(
                    child:  Container(
                      child: Row(children: <Widget>[
                        Text("employeur"),
                      ]),
                    ),
                    color: visibility ? Colors.blue: Colors.white,
                    onPressed: (){
                      _controller.animateToPage(0, duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: RaisedButton(
                      child:  Container(
                        child: Row(children: <Widget>[
                          Text("prestataire"),
                        ]),
                      ),
                      color: visibility ? Colors.white: Colors.blue,
                    onPressed: (){
                      _controller.animateToPage(1, duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,);
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (val){
                setState(() {
                  visibility= !visibility;
                  if(visibility)
                    _currentOrigin= "employer";
                  else
                    _currentOrigin= "employee";
                });
              },
              controller: _controller,
              children: <Widget>[
                Visibility(
                  visible: visibility,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          Center(child: Text("Offre faite à Mr/Mme ${widget.choosedUser.name.toUpperCase()} ${widget.choosedUser.surname} ",style: TextStyle(fontSize: 15),),),
                          SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Colors.black87),
                            decoration: textInputDecoration.copyWith(hintText: "Libellé de la proposition").copyWith(labelText: "un thème accrocheur",).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black,),
                                )),
                            validator: (val) {
                              return val.isEmpty ? "veuillez saisir un libellé": null;
                            },
                            onChanged: (val) {
                              setState(() => _currentLibelle = val);
                            },
                          ),
                          SizedBox(height: 10,),
                          TextField(
                            maxLines: 5,
                            decoration: textInputDecoration.copyWith(hintText: "descriptif de la proposition").copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.library_books, color: Colors.black,),
                                )),
                            onChanged: (val){
                              setState(() {
                                _currentDescription= val;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                            style: TextStyle(color: Colors.black87),
                            decoration: textInputDecoration.copyWith(hintText: "Gratification en euros").copyWith(labelText: "prix / heure",).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.euro_symbol, color: Colors.black,),
                                )),
                            validator: numberValidator,
                            onChanged: (val) {
                              setState(() {
                                _currentPricePerHour =
                                    num.tryParse(priceController.text).toDouble();
                              });
                            }
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            initialValue: _currentHourPerWeek?.toString() ?? "10",
                            keyboardType: TextInputType.number,
                            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                            style: TextStyle(color: Colors.black87),
                            decoration: textInputDecoration.copyWith(hintText: "Nombres d'heures par semaines").copyWith(labelText: "heures / semaine",).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.hourglass_empty, color: Colors.black,),
                                )),
                            validator: (val){
                              double number= num.tryParse(val).toDouble();
                              if(number <= maxRegularHourPerMonth && number > minRegularHourPerMonth) return null;
                            else if(number < minRegularHourPerMonth) return "nombre d'heures par semaine inférieur à 10h";
                            else return "le nombre est supérieur à 35 h";},
                            onChanged: (val) {
                              setState(() { _currentHourPerWeek =  num.tryParse(hourPerWeekController.text)?.toDouble();

                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          Card(
                            child: ListTile(
                              title: const Text('ne necessite pas de prévision: planning fixe '),
                              leading: Radio(
                                value: Planning.fixe ,
                                groupValue: _planning,
                                onChanged: (Planning value) {
                                  setState(() { _planning = value;
                                  planningVariable= false;});
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Card(
                            child: ListTile(
                              title: const Text('necessite des prévisions: planning variable'),
                              leading: Radio(
                                value: Planning.variable ,
                                groupValue: _planning,
                                onChanged: (Planning value) {
                                  setState(() { _planning = value;
                                  planningVariable= true;});
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              Text(" début"),
                              SizedBox(width: 5,),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      const BorderRadius.all(const Radius.circular(5.0)),
                                      border: new Border.all(
                                          color: Colors.black87,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  child: Text(_startDate ?? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1).toString().split(" ")[0]),
                                ),
                                onTap: (){
                                  selectedDate(context, "left");
                                },
                              ),
                              SizedBox(width: 15,),
                              Text(" fin"),
                              SizedBox(width: (5),),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                 const BorderRadius.all(const Radius.circular(5.0)),
                                  border: new Border.all(
                                  color: Colors.black87,
                                  width: 2.0,
                                  style: BorderStyle.solid)),
                                  child: Text(_endDate ?? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1).toString().split(" ")[0]),
                                ),
                                onTap: (){
                                  selectedDate(context, "right");
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(error,style: TextStyle(color: Colors.red),),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 70),
                            child: RaisedButton(
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Row(children: <Widget>[
                                    Text("soumettre"),
                                    SizedBox(width: 5,),
                                    Icon(Icons.send)
                                  ]),
                                ),
                                onPressed: () async {
                                  UserData userData= await UserDao(user.uid).getUserData();
                                  if(userData.address != null && userData.codePostal !=null || userData.address != null && userData.codePostal !=null && !planningVariable ) {
                                    if (_formKey.currentState.validate()) {
                                      Duration difference = _currentEndDate
                                          .difference(_currentStartDate);
                                      print(difference);
                                      if (difference.inDays > 0) {
                                        setState(() {
                                          error = "";
                                        });
                                        try {

                                          dat['startDate'] = _currentStartDate;
                                          dat['endDate'] = _currentEndDate;
                                          await PropositionDao(uid: user.uid)
                                              .createProposition(
                                              widget.choosedUser,
                                              _currentLibelle,
                                              _currentPricePerHour,
                                              dat,
                                              planningVariable,
                                              _currentOrigin,
                                              _currentDescription,_currentHourPerWeek)
                                              .then((res) {
                                            Alert()
                                                .goodAlert(
                                                context, "proposition envoyée",
                                                "votre proposition a été envoyée avec succès")
                                                .then(
                                                    (value) =>
                                                    Navigator.pop(context));
                                          });
                                        } catch (e) {
                                          print(e.toString());
                                          Alert().badAlert(
                                              context, "opération a échoué",
                                              "votre proposition n'a pas pu etre envoyée");
                                        }
                                      } else {
                                        setState(() {
                                          error =
                                          "interval de temps non suffisant pour un contrat";
                                        });
                                      }
                                    }
                                  }else{
                                    Alert().badAlert(context, "Opération impossible", "Vous devez fournir votre adresse + code postal pour pouvoir etre employeur sur planning variable\n  rdv dans la rubrique identité ");
                                  }
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: !visibility,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          Center(child: Text("je propose mes services à Mr/Mme ${widget.choosedUser.name.toUpperCase()} ${widget.choosedUser.surname} ",style: TextStyle(fontSize: 15),),),
                          SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Colors.black87),
                            decoration: textInputDecoration.copyWith(hintText: "Libellé de la proposition").copyWith(labelText: "un thème accrocheur",).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black,),
                                )),
                            validator: (val) {
                              return val.isEmpty ? "veuillez saisir un libellé": null;
                            },
                            onChanged: (val) {
                              setState(() => _currentLibelle = val);
                            },
                          ),
                          SizedBox(height: 10,),
                          TextField(
                            maxLines: 5,
                            decoration: textInputDecoration.copyWith(hintText: "descriptif de la proposition").copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.library_books, color: Colors.black,),
                                )),
                            onChanged: (val){
                              setState(() {
                                _currentDescription=val;
                              });
                            },
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                            style: TextStyle(color: Colors.black87),
                            decoration: textInputDecoration.copyWith(hintText: "Gratification nette en euros").copyWith(labelText: "prix / heure net",).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.euro_symbol, color: Colors.black,),
                                )),
                            validator: numberValidator,
                            onChanged: (val) {
                              setState(() => _currentPricePerHour =  num.tryParse(val));
                            },
                          ),
                          SizedBox(height: 10,),
                          Card(
                            child: ListTile(
                              title: const Text('ne necessite pas de prévision: planning fixe '),
                              leading: Radio(
                                value: Planning.fixe ,
                                groupValue: _planning,
                                onChanged: (Planning value) {
                                  setState(() { _planning = value;
                                  planningVariable= false;});
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Card(
                            child: ListTile(
                              title: const Text('necessite des prévisions: planning pouvant varier'),
                              leading: Radio(
                                value: Planning.variable ,
                                groupValue: _planning,
                                onChanged: (Planning value) {
                                  setState(() { _planning = value;
                                  planningVariable= true;});
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: <Widget>[
                              Text(" début"),
                              SizedBox(width: 5,),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      const BorderRadius.all(const Radius.circular(5.0)),
                                      border: new Border.all(
                                          color: Colors.black87,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  child: Text(_startDate ?? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1).toString().split(" ")[0]),
                                ),
                                onTap: (){
                                  selectedDate(context, "left");
                                },
                              ),
                              SizedBox(width: 15,),
                              Text(" fin"),
                              SizedBox(width: (5),),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      const BorderRadius.all(const Radius.circular(5.0)),
                                      border: new Border.all(
                                          color: Colors.black87,
                                          width: 2.0,
                                          style: BorderStyle.solid)),
                                  child: Text(_endDate ?? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+1).toString().split(" ")[0]),
                                ),
                                onTap: (){
                                  selectedDate(context, "right");
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(error,style: TextStyle(color: Colors.red),),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 70),
                            child: RaisedButton(
                                color: Colors.white,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Row(children: <Widget>[
                                    Text("soumettre"),
                                    SizedBox(width: 5,),
                                    Icon(Icons.send)
                                  ]),
                                ),
                                onPressed: () async {
                                  if(widget.choosedUser.address != null && widget.choosedUser.codePostal !=null || widget.choosedUser.address == null && widget.choosedUser.codePostal ==null && !planningVariable) {
                                    if (_formKey.currentState.validate()) {
                                      Duration difference = _currentEndDate
                                          .difference(_currentStartDate);
                                      print(difference);
                                      if (difference.inDays > 0) {
                                        setState(() {
                                          error = "";
                                        });
                                        try {
                                          dat['startDate'] = _currentStartDate;
                                          dat['endDate'] = _currentEndDate;
                                          await PropositionDao(uid: user.uid)
                                              .createProposition(
                                              widget.choosedUser,
                                              _currentLibelle,
                                              _currentPricePerHour,
                                              dat,
                                              planningVariable,
                                              _currentOrigin,
                                              _currentDescription,30)
                                              .then((res) {
                                            Alert()
                                                .goodAlert(
                                                context, "proposition envoyée",
                                                "votre proposition a été envoyée avec succès")
                                                .then(
                                                    (value) =>
                                                    Navigator.pop(context));
                                          });
                                        } catch (e) {
                                          print(e.toString());
                                          Alert().badAlert(
                                              context, "opération a échoué",
                                              "votre proposition n'a pas pu etre envoyée");
                                        }
                                      } else {
                                        setState(() {
                                          error =
                                          "interval de temps non suffisant pour un contrat";
                                        });
                                      }
                                    }
                                  }else{
                                    Alert().badAlert(context, "Opération impossible", "l'employeur que vous essayez de contacter doit avoir fourni une adresse de valide");
                                  }
                                }
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}