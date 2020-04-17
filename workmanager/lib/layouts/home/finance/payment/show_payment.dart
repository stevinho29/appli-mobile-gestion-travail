import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:work_manager/models/contract.dart';
import 'package:work_manager/shared/constantSalary.dart';

class ShowPayment extends StatefulWidget{

  Payment payment;
  ShowPayment({this.payment});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowPaymentState();
  }

}

class _ShowPaymentState extends State<ShowPayment>{

  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
/*
    void _showSettingsPanel(Contract contract){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.all(20),
          child: Text(""),
        );
      });
    }*/

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("fiche de paie"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
              border: new Border.all(
                  color: Colors.cyan,
                  width: 2.0,
                  style: BorderStyle.solid) ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10,),
              Center(child: Text("  ${widget.payment.documentId}",style: TextStyle(color: Colors.cyan,fontSize: 15),)),
              SizedBox(height: 20,),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(width: 25,),
                        Text("Début: "),
                        Text("${DateFormat.yMd('fr-FR').format(widget.payment.startDate)}",style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 15,),
                        Text("Fin: "),
                        Text("${DateFormat.yMd('fr-FR').format(widget.payment.endDate)}",style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("nombre d'heures éffectuées",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 20,),
                        Text(widget.payment.workedHour.toString()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("montant en € :",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 20,),
                        Text(widget.payment.basicSalary.toString()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      height: 1,
                      thickness: 1.0,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("nombre d'heures supplémentaires",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 20,),
                        Text(widget.payment.overtime.toString()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("montant en €",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 20,),
                        Text(getOvertimePrice(widget.payment.overtime, widget.payment.pricePerHour).toString()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Divider(
                      height: 1,
                      thickness: 1.0,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("nombres d'heures à decompter",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 20,),
                        Text(widget.payment.exceptionsHour.toString()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("montant en €",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 20,),
                        Text(" - ${(widget.payment.exceptionsHour * widget.payment.pricePerHour).toString()}"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15,),
              Divider(
                height: 1,
                thickness: 1.0,
                color: Colors.black87,
              ),
              SizedBox(height: 15,),
              Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Rémunération Totale:",style: TextStyle(color: Colors.red)),
                        SizedBox(width: 10,),
                        Text("${widget.payment.finalSalary} € "),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Compositions de la rémunération:",style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    Text("Le calcul  des heures se font essentiellement via l'application do..it\n"
                        "conformément aux conditions générales de la plateforme et de la réglémentation en vigueur"),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Text("Mode de communication des horaires du salarié:",style: TextStyle(color: Colors.red),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("la communication des heures se font essentiellement via l'application do..it\n"
                        "conformément aux conditions générales de la plateforme et de la réglémentation en vigueur")

                  ],
                ),
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

}