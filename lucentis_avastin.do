cd "/Users/richard/Desktop/ec970"

forvalues i = 2012/2014 {
    import delimited using Medicare_Provider_Util_Payment_PUF_CY`i'.txt, delimiters(tab) rowrange(3) varnames(1) clear

    keep npi line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt provider_type hcpcs_code
    keep if hcpcs_code == "J2778" | hcpcs_code == "J9035" | hcpcs_code == "Q2024"
    
    compress
    save PUF`i', replace
}

use PUF2012, clear
append using PUF2013 PUF2014, generate(year)

* make year into a categorical variable
generate year2 = string(year + 2012)
drop year
encode year2, generate(year)

do label.do
do rename.do

drop if provider_type != "Ophthalmology"

eststo clear

bysort hcpcs_code: eststo: estpost sum line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt

estwide using lucentisavastinsum.tex, main(mean) aux(sd) booktabs label title("Summary Statistics, Lucentis and Avastin\label{table:lucentisavastinsum}") mtitle("Lucentis 2012" "Lucentis 2013" "Lucentis 2014" "Avastin 2012" "Avastin 2013" "Avastin 2014") nonotes replace

collapse (sum) line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt, by(npi hcpcs_code year2)

reshape wide line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt, i(npi hcpcs_code) j(year2) string

* replace all missing values with 0
mvencode _all, mv(0)

* useful
* contract hcpcs_code year
