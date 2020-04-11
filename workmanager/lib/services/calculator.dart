import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/services/databases/planningDao.dart';

class Calculator{

Contract contract;
List<Payment> paymentList;
Calculator({this.contract,this.paymentList});


static List<Exceptions> exceptionList;
static List<Day> dayList;

 int overtime=0;
 int overtimePrice=0;
 int exceptionsHour=0;
 int exceptionsHourPrice=0;
 int normalHours=0;
 int normalHourPrice=0;
 int donationHour=0;
 int donationHourPrice=0;
 int totalHourPrice=0;

DateTime startDate;
DateTime endDate;

int totalHour;
  Future initializeCalculator() async {    // must be done before using every function in this class
    exceptionList= await ContractDao().getExceptionList(contract);
    dayList= await PlanningDao().getDaysList(contract);
    if(contract.cursorPayment == 0)
      startDate = contract.startDate;
    else{
      int len= paymentList.length;
      startDate= paymentList[len -1].endDate;
    }
    endDate= DateTime.now();
  }

  orchestrator(){
    _getNormalHours();
    _getOvertimeHours();
    _getExceptionalHours();
    _getTotalPriceForNormalHours();
    _getTotalPriceForOvertimeHours();
    getTotal();
  }
  staticOrchestrator(){   // à retoucher
  _getStaticNormalHours();
  _getExceptionalHours();
  _getTotalPriceForNormalHours();
  getTotal();
  }
  _getStaticNormalHours(){ //todo

  }
   _getNormalHours(){
    dayList?.forEach((day) {
      if( day.startHour.difference(startDate).inDays >= 0 && endDate.difference(day.endHour).inDays >=0)
        normalHours += day.endHour.difference(day.startHour).inHours;
    });
  }

  _getOvertimeHours(){
    if(normalHours > 40)
      overtime = normalHours-40;
  }
  _getExceptionalHours(){
    exceptionList?.forEach((exception) {
      exceptionsHour += exception.endDate.difference(exception.endDate).inHours;
      exceptionsHourPrice += exception.endDate.difference(exception.endDate).inHours*exception.price;
    });
  }
  _getTotalPriceForNormalHours(){    // à modifier si on opte pour la solution du prix par jour
    normalHourPrice = normalHours* contract.pricePerHour;
  }

  _getTotalPriceForOvertimeHours(){
  // overtimePrice= overtime*
  }

  getTotalPriceForExceptionalHours(){
    return exceptionsHourPrice;
  }

  getTotalPriceForDonation(int nbHours,int price){
    donationHour= nbHours;
    donationHourPrice = nbHours*price;
  }

  getTotal(){
      totalHourPrice = normalHourPrice+exceptionsHourPrice+overtimePrice+donationHourPrice;
  }
}