import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/user.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/shared/constants.dart';
import 'package:intl/date_symbol_data_local.dart';


class ExceptionSetting extends StatefulWidget{

  Exceptions exceptionData;
  ExceptionSetting({this.exceptionData});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ExceptionSettingState();
  }

}

class _ExceptionSettingState extends State<ExceptionSetting> {

  final _formKey = GlobalKey<FormState>();
  String error = "";
  String _currentMotif;
  double _currentPricePerHour;
  Map<String, DateTime> dat = new Map();

  DateTime _currentStartDate ;
  DateTime _currentEndDate ;
  String _startDate;
  String _endDate;

  Future processDate(String side,DateTime value) async {
      if (side == "left") {
        if (value != null) {
          setState(() {
            _currentStartDate = value;
            _startDate= DateFormat.yMd('fr-FR').format(_currentStartDate);
            print(DateFormat.yMd('fr-FR').format(_currentStartDate));
          });
        }
      }
      else {
        if (value != null) {
          setState(() {
            _currentEndDate = value;
            _endDate= DateFormat.yMd('fr-FR').format(_currentEndDate);
            print(DateFormat.yMd('fr-FR').format(_currentEndDate));
          });
        }
      }
  }

  @override
  void initState() {
  super.initState();
  initializeDateFormatting('fr-FR');
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    String numberValidator(String value) {
      if (value == null) {
        return "saisissez un montant valide";
      }
      final n = num.tryParse(value);
      if (n == null) {
        return 'saisissez un montant valide';
      }
      else {
          setState(() {
            _currentPricePerHour = n;
          });
          return null;
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
                initialValue: widget.exceptionData.motif ?? 'non renseigné',
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "libellé"),
                validator: (val) {
                  return val.isEmpty ? "veuillez saisir un motif" : null;
                },
                onChanged: (val) {
                  setState(() => _currentMotif = val);
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                initialValue: widget.exceptionData.price.toString() ?? '11',
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
                        child: Text( _startDate ??DateFormat.yMd('fr-FR').format(widget.exceptionData.startDate)),
                      ),
                      onTap: () {
                        showDatePicker(context: context, initialDate: _currentStartDate ?? widget.exceptionData.startDate, firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day + 1),
                        ).then((value) => {
                        processDate("left",value)
                        });

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
                        child: Text(_endDate ?? DateFormat.yMd('fr-FR').format(widget.exceptionData.endDate) ),
                      ),
                      onTap: () {
                        showDatePicker(context: context, initialDate: _currentEndDate ?? widget.exceptionData.endDate, firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month, DateTime.now().day + 1),
                        ).then((value) => {
                          processDate("right",value)
                        });

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
                        Text("modifier"),
                        SizedBox(width: 5,),
                        Icon(Icons.update)
                      ]),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _currentStartDate= _currentStartDate ?? widget.exceptionData.startDate;
                        _currentEndDate= _currentEndDate ?? widget.exceptionData.endDate;
                        Duration difference = _currentEndDate.difference(
                            _currentStartDate);
                        print(difference);
                        if (difference.inDays >= 0) {
                          setState(() {
                            error = "";
                          });
                          try {
                            _currentPricePerHour= _currentPricePerHour ?? widget.exceptionData.price;
                            _currentMotif= _currentMotif ?? widget.exceptionData.motif;

                            dat['startDate'] = _currentStartDate ;
                            dat['endDate'] = _currentEndDate ;
                            await ContractDao().updateContractException(widget.exceptionData, _currentPricePerHour,dat,_currentMotif) .then((res) {
                              Alert().goodAlert(context, "Exception modifiée", "votre _currentMotif a été modifiée avec succès")
                                  .then((value) => Navigator.pop(context));
                            });
                          } catch (e) {
                            print(e.toString());
                            Alert().badAlert(context, "opération a échoué",
                                "votre exception: $_currentMotif  n'a pas pu etre modifiée");
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