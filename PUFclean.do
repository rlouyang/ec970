/*
Turns tab-delimited .txt files into usable .dta files.
takes original CMS data
cleans it a little
deletes unneeded variables
saves it as a .dta file

This has been run already, so no need to do it again.
WARNING: this takes a really long time.
*/

local tokeep npi nppes_credentials nppes_provider_gender nppes_entity_code nppes_provider_state provider_type place_of_service hcpcs_code hcpcs_drug_indicator line_srvc_cnt bene_unique_cnt bene_day_srvc_cnt average_medicare_allowed_amt average_submitted_chrg_amt average_medicare_payment_amt
local categorical nppes_credentials nppes_provider_gender nppes_entity_code nppes_provider_state place_of_service hcpcs_code hcpcs_drug_indicator

forvalues i = 2012/2014 {
    import delimited using `i'/Medicare_Provider_Util_Payment_PUF_CY`i'.txt, delimiters(tab) rowrange(3) varnames(1) clear

    * limit analysis to just the US for now
    drop if nppes_provider_country != "US"
    drop if nppes_provider_state == "XX"

    drop if medicare_participation_indicator == "N"

    * drop variables I definitely won't use
    keep `tokeep'

    replace nppes_credentials = subinstr(nppes_credentials, ".", "", .)
    foreach var of varlist `categorical' {
        local newvar = substr("`var'", 1, 31)
        encode `var', generate(`newvar'2)
        drop `var'
        rename `newvar'2 `var'
    }
    
    compress
    save `i'/PUF`i', replace
}