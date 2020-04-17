

const brutMajorationPercentage= 23;   // majoration appliquée entre le salaire net et brut
const maxSupplementaryHours= 10;    // max d'heure supplémentaires possible
const supplementaryHoursPercentageLessThan8= 25;  // heure supplémentaires majorées à 25% de plus que le taux horaire normal <= 8h
const supplementaryHoursPercentageMoreThan8= 50;  // heure supplémentaires majorées à 50% de plus que le taux horaire normal > 8h <= 10h


const minNetSalary= 10.15 - (10.15*23) / 100;       // salaire net horaire min

const minRegularHourPerMonth= 10.0;
const maxRegularHourPerMonth= 35.0;

getOvertimePrice(double overtime,double price){
  if(overtime >8)
    return overtime* (price + price*supplementaryHoursPercentageLessThan8);
  else
    return overtime* (price + price*supplementaryHoursPercentageMoreThan8);
}