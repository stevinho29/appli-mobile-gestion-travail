import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/propositionDao.dart';

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

  final _formKey= GlobalKey<FormState>();
  String error="";
  String _currentLibelle ;
  int _currentPricePerHour;
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
        if(n < 11)
          return "gratification minimum non respectée";
        else {
          setState(() {
            _currentPricePerHour= n;
          });
          return null;
        }
      }
    }
    final user = Provider.of<User>(context);

    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(" Proposition de contrat",style: TextStyle(fontSize: 18),),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
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
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))],
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "Gratification en euros").copyWith(labelText: "prix / heure",).copyWith(
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(children: <Widget>[
                        Text("soumettre"),
                        SizedBox(width: 5,),
                        Icon(Icons.send)
                      ]),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()){
                        Duration difference= _currentEndDate.difference(_currentStartDate);
                        print(difference);
                          if( difference.inDays > 0 ){
                            setState(() {
                              error= "";
                            });
                            try{
                              dat['startDate'] = _currentStartDate;
                              dat['endDate'] = _currentEndDate;
                            await PropositionDao(uid: user.uid).createProposition(widget.choosedUser,_currentLibelle, _currentPricePerHour,dat,planningVariable).then((res){
                              Alert().goodAlert(context, "proposition envoyée", "votre proposition a été envoyée avec succès").then(
                                  (value) => Navigator.pop(context));
                            });
                            }catch(e){
                              print(e.toString());
                              Alert().badAlert(context, "opération a échoué", "votre proposition n'a pas pu etre envoyée");
                            }

                          }else{
                            setState(() {
                              error= "interval de temps non suffisant pour un contrat";
                            });

                          }

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