/*
ECON 970 Project Analysis
Richard Ouyang
Brad Rice and Sophie Yang
Empirical Economic Issues in Healthcare
*/

cd "/Users/richard/Desktop/ec970"
set more off
cap log close
log using project.log, replace

* do PUFclean.do

* do aggregateclean.do

* do PUFcombine.do

* do aggregatecombine.do

***** AGGREGATE *****

use aggregate, clear

* sample 50

do fix_provider_gender.do

local x_vars total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_provider_gender i.year

eststo clear

gen average_medicare_allowed_amt = total_medicare_allowed_amt / total_services
label variable average_medicare_allowed_amt "Average Medicare allowed amount"

eststo: reg average_medicare_allowed_amt i.nppes_provider_state `x_vars', r
* eststo: reg average_medicare_allowed_amt `x_vars', r

gen average_submitted_chrg_amt = total_submitted_chrg_amt / total_services
label variable average_submitted_chrg_amt "Average submitted charge amount"

eststo: reg average_submitted_chrg_amt i.nppes_provider_state `x_vars', r
* eststo: reg average_submitted_chrg_amt `x_vars', r

gen average_medicare_payment_amt = total_medicare_payment_amt / total_services
label variable average_medicare_payment_amt "Average Medicare payment amount"

eststo: reg average_medicare_payment_amt i.nppes_provider_state `x_vars', r
* eststo: reg average_medicare_payment_amt `x_vars', r

estwide using aggregate1.tex, nocons star label title("Average Cost per Healthcare Service over Time, by Provider\label{table:aggregate1}") booktabs replace b(a3) nonotes indicate(State Effects = *.nppes_provider_state)

***** DRUG *****

eststo clear

gen avg_drug_medicare_allowed_amt = total_drug_medicare_allowed_amt / total_services
label variable avg_drug_medicare_allowed_amt "Average drug Medicare allowed amount"

eststo: reg avg_drug_medicare_allowed_amt i.nppes_provider_state `x_vars' if avg_drug_medicare_allowed_amt != 0, r
* eststo: reg avg_drug_medicare_allowed_amt `x_vars', r

gen avg_drug_submitted_chrg_amt = total_drug_submitted_chrg_amt / total_services
label variable avg_drug_submitted_chrg_amt "Average drug submitted charge amount"

eststo: reg avg_drug_submitted_chrg_amt i.nppes_provider_state `x_vars' if avg_drug_submitted_chrg_amt != 0, r
* eststo: reg avg_drug_submitted_chrg_amt `x_vars', r

gen avg_drug_medicare_payment_amt = total_drug_medicare_payment_amt / total_services
label variable avg_drug_medicare_payment_amt "Average drug Medicare payment amount"

eststo: reg avg_drug_medicare_payment_amt i.nppes_provider_state `x_vars' if avg_drug_medicare_payment_amt != 0, r
* eststo: reg avg_drug_medicare_payment_amt `x_vars', r

estwide using aggregatedrug1.tex, nocons star label title("Average Cost per Drug Service over Time, by Provider\label{table:aggregatedrug1}") booktabs replace b(a3) nonotes indicate(State Effects = *.nppes_provider_state)

***** MEDICAL *****

eststo clear

gen avg_med_medicare_allowed_amt = total_med_medicare_allowed_amt / total_services
label variable avg_med_medicare_allowed_amt "Average medical Medicare allowed amount"

eststo: reg avg_med_medicare_allowed_amt i.nppes_provider_state `x_vars', r
* eststo: reg avg_med_medicare_allowed_amt `x_vars', r

gen avg_med_submitted_chrg_amt = total_med_submitted_chrg_amt / total_services
label variable avg_med_submitted_chrg_amt "Average medical submitted charge amount"

eststo: reg avg_med_submitted_chrg_amt i.nppes_provider_state `x_vars', r
* eststo: reg avg_med_submitted_chrg_amt `x_vars', r

gen avg_med_medicare_payment_amt = total_med_medicare_payment_amt / total_services
label variable avg_med_medicare_payment_amt "Average medical Medicare payment amount"

eststo: reg avg_med_medicare_payment_amt i.nppes_provider_state `x_vars', r
* eststo: reg avg_med_medicare_payment_amt `x_vars', r


estwide using aggregatemed1.tex, nocons star label title("Average Cost per Medical Service over Time, by Provider\label{table:aggregatemed1}") booktabs replace b(a3) nonotes indicate(State Effects = *.nppes_provider_state)

***** SUMMARY STATISTICS *****

eststo clear

bysort year: eststo: estpost sum average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt avg_drug_medicare_allowed_amt avg_drug_submitted_chrg_amt avg_drug_medicare_payment_amt avg_med_medicare_allowed_amt avg_med_submitted_chrg_amt avg_med_medicare_payment_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score 

eststo: estpost sum average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt avg_drug_medicare_allowed_amt avg_drug_submitted_chrg_amt avg_drug_medicare_payment_amt avg_med_medicare_allowed_amt avg_med_submitted_chrg_amt avg_med_medicare_payment_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score 

estwide using aggregatesum.tex, main(mean) aux(sd) booktabs label title("Summary Statistics, Aggregate Table\label{table:aggregatesum}") mtitle("2012" "2013" "2014" "Overall") nonotes replace

***** END AGGREGATE *****

***** PUF *****

use PUF, clear

* sample 50

do fix_provider_gender.do

decode place_of_service, generate(place_of_service2)
drop place_of_service
replace place_of_service2 = "Facility (place of service)" if place_of_service2 == "F"
replace place_of_service2 = "Office (place of service)" if place_of_service2 == "O"
encode place_of_service2, generate(place_of_service)
drop place_of_service2

local x_vars line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt i.place_of_service i.nppes_provider_gender i.nppes_provider_state i.provider_type i.year

eststo clear 

eststo: reg average_medicare_allowed_amt i.nppes_provider_state `x_vars', r

eststo: reg average_submitted_chrg_amt i.nppes_provider_state `x_vars', r

eststo: reg average_medicare_payment_amt i.nppes_provider_state `x_vars', r

estwide using PUF1.tex, nocons star label title("Average Medicare Payment Amount over Time, by Procedure Type per Provider\label{table:PUF1}") booktabs replace b(a3) nonotes indicate("State Effects = *.nppes_provider_state" "Provider Type Effects = *.provider_type")

***** SUMMARY STATISTICS *****

eststo clear

bysort year: eststo: estpost sum average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt

eststo: estpost sum average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt

estwide using PUFsum.tex, main(mean) aux(sd) booktabs label title("Summary Statistics, Public Use File\label{table:PUFsum}") mtitle("2012" "2013" "2014" "Overall") nonotes replace

* eststo: reg average_medicare_allowed_amt `x_vars', r

* eststo: reg average_submitted_chrg_amt `x_vars', r

* eststo: reg average_medicare_payment_amt `x_vars', r

***** END PUF *****

log close