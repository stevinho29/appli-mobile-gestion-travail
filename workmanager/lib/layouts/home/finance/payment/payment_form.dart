import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_manager/layouts/alerts/alert.dart';
import 'package:work_manager/models/contract.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:work_manager/services/calculator.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/shared/constants.dart';
import 'package:work_manager/shared/loading.dart';


class PaymentForm extends StatefulWidget{
  Contract contractData;
  List<Payment> paymentList;

  PaymentForm({this.contractData,this.paymentList});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PaymentFormState();
  }

}

class _PaymentFormState extends State<PaymentForm>{

  final _controller = PageController(
    initialPage: 0,
  );
  final donationHourController= TextEditingController();
  final donationPriceController= TextEditingController();

  static Calculator _calculator;
  bool isSwitched = false;
  bool loading= true;
  DateTime startDate;
  DateTime endDate;
  double overtime;
  double overtimePrice;
  double exceptionsHour;
  double exceptionsHourPrice;
  double totalHour;
  double donationHour;
  double donationHourPrice;
  String error="";

  @override
  void dispose() {
  donationHourController.dispose();
  donationPriceController.dispose();
  super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr-FR');
    _calculator= Calculator(contract: widget.contractData,paymentList: widget.paymentList);
    _delayToInitializeCalculator();

    print("curseur ${widget.contractData.cursorPayment}");
    if(widget.contractData.cursorPayment == 0)
      startDate = widget.contractData.startDate;
    else{
      int len= widget.paymentList.length;
      startDate= widget.paymentList[len -1].endDate;
    }
    endDate= DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    var firstPage= ListView(
      children: <Widget>[
        SizedBox(height: 30,),
        Text("Période ",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Text(DateFormat.yMd('fr-FR').format(startDate) +" au " +DateFormat.yMd('fr-FR').format(endDate)),
        SizedBox(height: 30,),
        Text("Nombre d'heures éffectuées",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Row(
          children: <Widget>[
            Text(_calculator.normalHours.toString()),
            SizedBox(width: 50,),
            Text(_calculator.normalHourPrice.round().toString()),
            SizedBox(width: 15,),
            Icon(Icons.euro_symbol)
          ],
        ),
        SizedBox(height: 30,),
        Text("Nombre d'heures supplémentaires",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Row(
          children: <Widget>[
            Text(_calculator.overtime.toString()),
            SizedBox(width: 50,),
            Text(_calculator.overtimePrice.floor().toString()),
            SizedBox(width: 15,),
            Icon(Icons.euro_symbol)
          ],
        ),
        SizedBox(height: 30,),
        Text("heures d'exception",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 10,),
        Row(
          children: <Widget>[
            Text(_calculator.exceptionsHour.toString()),
            SizedBox(width: 50,),
            Text("- ${_calculator.exceptionsHourPrice.floor().toString()}"),
            SizedBox(width: 15,),
            Icon(Icons.euro_symbol)
          ],
        ),


      ],
    );


    var secondPage= ListView(
      children: <Widget>[
        Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15,),
              TextFormField(
                initialValue: donationHour?.toString() ?? "0",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
                ],
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "je rajoute des heures").copyWith(labelText: "je rajoute des heures"),
                onChanged: (val){
                  setState(() {
                    donationHour= num.tryParse(val)?.toDouble();
                    print(donationHour);
                    _calculator.getTotalPriceForDonation(donationHour ?? 0, donationHourPrice ?? 0);
                  });
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                initialValue: donationHourPrice?.toString() ?? "0",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
                ],
                style: TextStyle(color: Colors.black87),
                decoration: textInputDecoration.copyWith(hintText: "taux horaire en euros").copyWith(labelText: "taux horaire"),
                validator: (val) {
                  return val.isEmpty ? "veuillez saisir un motif" : null;
                },
                onChanged: (val){
                  setState(() {
                    donationHourPrice= num.tryParse(val)?.toDouble();
                    print(donationHourPrice);
                    _calculator.getTotalPriceForDonation(donationHour ?? 0.0, donationHourPrice ?? 0.0);
                    _calculator.getTotal();
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        Row(
          children: <Widget>[
            Text(_calculator.donationHour.toString()),
            SizedBox(width: 50,),
            Text(_calculator.donationHourPrice.toString()),
            SizedBox(width: 15,),
            Icon(Icons.euro_symbol)
          ],
        ),
        SizedBox(height: 40,),
        Row(
          children: <Widget>[
            Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(width: 50,),
            Text(_calculator.totalHourPrice.floor().toString()),
            SizedBox(width: 10,),
            Icon(Icons.euro_symbol)
          ],
        ),
        SizedBox(height: 15,),
        Row(
          children: <Widget>[
            Text("etes vous sur sachez\n que cette opération\n est irréversible"),
            Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeTrackColor: Colors.cyan[100],
              activeColor: Colors.cyan,
            ),
          ],
        ),
        SizedBox(height: 5,),
        Text(error,style: TextStyle(color: Colors.red),),
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 45),
          child: RaisedButton(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: <Widget>[
                  Text("valider",style: TextStyle(color: Colors.black87),),
                  SizedBox(width: 5,),
                  Icon(Icons.update,color: Colors.black87,)
                ]),
              ),
              onPressed: () async {
                if(isSwitched) {
                  setState(() {
                    error="";
                  });
                  try {
                    ContractDao().createPayment(
                        widget.contractData, _calculator);
                    ContractDao().updateContractCursor(widget.contractData,
                        widget.contractData.cursorPayment + 1);
                    Navigator.pop(context);
                  }catch(e){
                    print(e);
                    print("une erreur c'est produite lors de la creéation de la fiche de paie");
                    Alert().badAlert(context, "erreur s'est produite", "une erreur s'est produite lors de la création de la fiche de paie");
                  }

                }else{
                  setState(() {
                    error="vous devez cocher la case";
                  });
                }
              }
          ),
        )
      ],
    );
    // TODO: implement build
    return loading? Loading():Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (val){

              },
              children: <Widget>[
                firstPage,
                secondPage
              ],
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(width: 65,),
              GestureDetector(child: Icon(Icons.navigate_before,size: 40,),
                onTap: (){
                  _controller.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                },),
              SizedBox(width: 10,),
              GestureDetector(child: Icon(Icons.navigate_next,size: 40,),
                onTap: (){
                _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  })
            ],
          )
        ],
      ),
    );
  }

  Future _delayToInitializeCalculator() async{
      _calculator.initializeCalculator().then((value) {
        if(widget.contractData.planningVariable) {
          print("dynamic orchestrator");
          _calculator.orchestrator();
          setState(() {
            loading = false;
          });
        }else{
          print("static orchestrator");
          _calculator.staticOrchestrator();
          setState(() {
            loading = false;
          });
        }
        //return null;
       });
}
}