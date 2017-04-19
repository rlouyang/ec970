forvalues i = 2012/2014 {
    import delimited using `i'/Medicare_Provider_Util_Payment_PUF_CY`i'.txt, delimiters(tab) rowrange(3) varnames(1) clear

    keep npi line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt provider_type year hcpcs_code
    keep if hcpcs_code == “J2278” or hcpcs_code = “J9035”
    
    compress
    save `i'/PUF`i', replace
}

use 2012/PUF2012, clear
append using 2013/PUF2013 2014/PUF2014, generate(year)

* make year into a categorical variable
generate year2 = string(year + 2012)
drop year
encode year2, generate(year)
drop year2

do label.do
