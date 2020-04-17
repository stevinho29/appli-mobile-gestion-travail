import 'package:work_manager/models/contract.dart';
import 'package:work_manager/models/planning.dart';
import 'package:work_manager/services/databases/contractDao.dart';
import 'package:work_manager/services/databases/planningDao.dart';
import 'package:work_manager/shared/constantSalary.dart';

class Calculator{

Contract contract;
List<Payment> paymentList;
Calculator({this.contract,this.paymentList});


static List<Exceptions> exceptionList;
static List<Day> dayList;

 double overtime=0;
 double overtimePrice=0;
 double exceptionsHour=0;
 double exceptionsHourPrice=0;
 double normalHours=0;
 double responsibleHour=0;
 double normalHourPrice=0;
 double donationHour=0;
 double donationHourPrice=0;
 double totalHourPrice=0;

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
    _getExceptionalHours();
    _getTotalPriceForOvertimeHours();
    getTotal();
  }
  staticOrchestrator(){   // à retoucher
  _getStaticNormalHours();
  _getExceptionalHours();
  getTotal();
  }
  _getStaticNormalHours(){ //todo

  }

   _getNormalHours(){
    normalHours= contract.hourPerWeek;
    dayList?.forEach((day) {
      if(contract.startDate.difference(startDate).inDays <=0 && contract.endDate.difference(endDate).inDays >=0)
        responsibleHour +=  day.responsibleHour;
    });
    if((normalHours + ((responsibleHour*2)/3)) <= 40.0)
      normalHourPrice= (((contract.hourPerWeek * 52) / 12)  * contract.pricePerHour +  ((responsibleHour*2)/3 * contract.pricePerHour) );
    else{ // dans le cas d'heures supplémentaires
      normalHourPrice= ((contract.hourPerWeek * 52) / 12)  * contract.pricePerHour + (40- contract.hourPerWeek) * contract.pricePerHour;  // les heures par semaine selon contrat + les heures complémentaires calculées au cout horaire de base
      overtime= (normalHours + (responsibleHour * 2) / 3) - 40;
    }
  }

  _getExceptionalHours(){
    exceptionList?.forEach((exception) {
      exceptionsHour += exception.endDate.difference(exception.endDate).inHours;
    });
  }

  _getTotalPriceForOvertimeHours(){
    if(overtime <=8)  // majoration à 25%
    overtimePrice= overtime*((contract.pricePerHour+ contract.pricePerHour*supplementaryHoursPercentageLessThan8)/100) ;
    else // majoration à 50 %
      overtimePrice= overtime*((contract.pricePerHour+ contract.pricePerHour*supplementaryHoursPercentageMoreThan8)/100);

  }

  getTotalPriceForExceptionalHours(){   // montant déductible du salaire de base mensuel
    return exceptionsHourPrice= exceptionsHour * contract.pricePerHour;
  }

  getTotalPriceForDonation(double nbHours,double price){
    donationHour= nbHours;
    donationHourPrice = nbHours*price;
  }

  getTotal(){
    try {
      totalHourPrice = (normalHourPrice - exceptionsHourPrice + overtimePrice +
          donationHourPrice);
    }catch(e){
      print(e);
      print("error when calculating total Price");
    }
  }
}