import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';

import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/shared/constants.dart';


class ContractSetting extends StatefulWidget{

  Contract contractData;
  ContractSetting({this.contractData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContractSettingState();
  }

}

class _ContractSettingState extends State<ContractSetting> {

  final _formKey = GlobalKey<FormState>();
  String error = "";
  String _currentLibelle;

  int _currentPricePerHour;
  Map<String, DateTime> dat = new Map();

  DateTime _currentStartDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  DateTime _currentEndDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  String _endDate;
  String _startDate;

  Future selectedDate(BuildContext context, String side) async {
    showDatePicker(
      context: context,
      initialDate: _currentStartDate,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day + 1),
    ).then((value) {
      if (side == "left") {
        if (value != null) {
          setState(() {
            _currentStartDate = value;
            _startDate = value.toString().split(" ")[0];
            print(_startDate);
          });
        }
      }
      else {
        if (value != null) {
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
    final user = Provider.of<User>(context);

    String numberValidator(String value) {
      if (value == null) {
        return "saisissez un montant valide";
      }
      final n = num.tryParse(value);
      if (n == null) {
        return 'saisissez un montant valide';
      }
      else {
        if (n < 11)
          return "gratification minimum non respectée";
        else {
          setState(() {
            _currentPricePerHour = n;
          });
          return null;
        }
      }
    }
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              TextFormField(
                initialValue: widget.contractData.libelle ?? 'non renseigné',
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "libellé"),
                validator: (val) {
                  return val.isEmpty ? "veuillez saisir un libellé" : null;
                },
                onChanged: (val) {
                  setState(() => _currentLibelle = val);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: widget.contractData.pricePerHour.toString() ?? '11',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
                ],
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(
                    hintText: "Gratification en euros").copyWith(
                  labelText: "prix / heure",).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.euro_symbol, color: Colors.black,),
                    )),
                validator: numberValidator,
                onChanged: (val) {
                  setState(() => _currentPricePerHour = num.tryParse(val));
                },
              ),
              SizedBox(height: 10),
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
                        child: Text(_startDate ?? DateTime(DateTime
                            .now()
                            .year, DateTime
                            .now()
                            .month, DateTime
                            .now()
                            .day + 1).toString().split(" ")[0]),
                      ),
                      onTap: () {
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
                        child: Text(_endDate ?? DateTime(DateTime
                            .now()
                            .year, DateTime
                            .now()
                            .month, DateTime
                            .now()
                            .day + 1).toString().split(" ")[0]),
                      ),
                      onTap: () {
                        selectedDate(context, "right");
                      },
                    ),

                  ]),
              SizedBox(height: 10,),
              Text(error, style: TextStyle(color: Colors.red),),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 45),
                child: RaisedButton(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Row(children: <Widget>[
                        Text("soumettre"),
                        SizedBox(width: 5,),
                        Icon(Icons.update)
                      ]),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Duration difference = _currentEndDate.difference(
                            _currentStartDate);
                        print(difference);
                        if (difference.inDays > 0) {
                          setState(() {
                            error = "";
                          });
                          try {
                            _currentPricePerHour= _currentPricePerHour ?? widget.contractData.pricePerHour;
                            _currentLibelle= _currentLibelle ?? widget.contractData.libelle;

                            dat['startDate'] = _currentStartDate ?? widget.contractData.startDate;
                            dat['endDate'] = _currentEndDate ?? widget.contractData.endDate;
                            await ContractDao(uid: user.uid).updateContractData(widget.contractData, _currentLibelle, _currentPricePerHour, dat)
                                .then((res) {
                              Alert().goodAlert(context, "proposition modifiée", "votre proposition a été modifiée avec succès")
                                  .then((value) => Navigator.pop(context));
                            });
                          } catch (e) {
                            print(e.toString());
                            Alert().badAlert(context, "opération a échoué",
                                "votre proposition n'a pas pu etre modifiée");
                          }
                        } else {
                          setState(() {
                            error =
                            "interval de temps non suffisant pour un contrat";
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