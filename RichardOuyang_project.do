/*
ECON 970 Project Analysis
Richard Ouyang
Brad Rice and Sophie Yang
Empirical Economic Issues in Healthcare
*/

cd "/Users/richard/Desktop/ec970"
set more off
cap log close
log using RichardOuyang_project.log, replace

* do RichardOuyang_PUFclean.do

* do RichardOuyang_aggregateclean.do

* do RichardOuyang_PUFcombine.do

* do RichardOuyang_aggregatecombine.do

***** AGGREGATE *****

use aggregate, clear

eststo clear

gen average_medicare_allowed_amt = total_medicare_allowed_amt / total_services
label variable average_medicare_allowed_amt "Average Medicare allowed amount"

eststo: reg average_medicare_allowed_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

gen average_submitted_chrg_amt = total_submitted_chrg_amt / total_services
label variable average_submitted_chrg_amt "Average submitted charge amount"

eststo: reg average_submitted_chrg_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

gen average_medicare_payment_amt = total_medicare_payment_amt / total_services
label variable average_medicare_payment_amt "Average Medicare payment amount"

eststo: reg average_medicare_payment_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

estwide using RichardOuyang_aggregate1.tex, se nocons star label title("Average Cost per Healthcare Service over Time, by Provider\label{table:aggregate1}") booktabs replace keep(*.year) b(a3) nonotes

***** DRUG *****

eststo clear

gen avg_drug_medicare_allowed_amt = total_drug_medicare_allowed_amt / total_services
label variable avg_drug_medicare_allowed_amt "Average drug Medicare allowed amount"

eststo: reg avg_drug_medicare_allowed_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

gen avg_drug_submitted_chrg_amt = total_drug_submitted_chrg_amt / total_services
label variable avg_drug_submitted_chrg_amt "Average drug submitted charge amount"

eststo: reg avg_drug_submitted_chrg_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

gen avg_drug_medicare_payment_amt = total_drug_medicare_payment_amt / total_services
label variable avg_drug_medicare_payment_amt "Average drug Medicare payment amount"

eststo: reg avg_drug_medicare_payment_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

estwide using RichardOuyang_aggregatedrug.tex, se nocons star label title("Average Cost per Drug Service over Time, by Provider\label{table:aggregatedrug}") booktabs replace keep(*.year) b(a3) nonotes

***** MEDICAL *****

eststo clear

gen avg_med_medicare_allowed_amt = total_med_medicare_allowed_amt / total_services
label variable avg_med_medicare_allowed_amt "Average medical Medicare allowed amount"

eststo: reg avg_med_medicare_allowed_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

gen avg_med_submitted_chrg_amt = total_med_submitted_chrg_amt / total_services
label variable avg_med_submitted_chrg_amt "Average medical submitted charge amount"

eststo: reg avg_med_submitted_chrg_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

gen avg_med_medicare_payment_amt = total_med_medicare_payment_amt / total_services
label variable avg_med_medicare_payment_amt "Average medical Medicare payment amount"

eststo: reg avg_med_medicare_payment_amt total_services total_unique_benes beneficiary_average_age beneficiary_female_count beneficiary_average_risk_score i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.year, r

estwide using RichardOuyang_aggregatemed.tex, se nocons star label title("Average Cost per Medical Service over Time, by Provider\label{table:aggregatemed}") booktabs replace keep(*.year) b(a3) nonotes

***** END AGGREGATE *****

***** PUF *****

use PUF, clear

eststo clear

eststo: reg average_medicare_allowed_amt line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt i.place_of_service i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.provider_type i.year, r

eststo: reg average_submitted_chrg_amt line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt i.place_of_service  i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.provider_type i.year, r

eststo: reg average_medicare_payment_amt line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt i.place_of_service  i.nppes_entity_code i.nppes_provider_gender i.nppes_provider_state i.provider_type i.year, r

estwide using RichardOuyang_PUF1.tex, se nocons star label title("Average Medicare Payment Amount over Time, by Procedure Type per Provider\label{table:PUF1}") booktabs replace keep(*.year) b(a3) nonotes
* addnote("NOTE -- Table reports regression coefficients with standard errors in parentheses. The dependent variable in each regression is one of several measures of Medicare payment amounts. The years are 2012-14. Data is taken from the CMS Provider Utilization and Payment Data Physician and Other Supplier Public Use File." "Standard errors in parentheses. " "\sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)" ) 

***** END PUF *****

log close