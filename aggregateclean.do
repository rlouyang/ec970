/*
Cleans aggregate data from 2012-2014 and saves as dta file. 
NEED to convert to tab-delimited .txt file first, since computer will swap like crazy when trying to import excel files.
*/
forvalues i = 2012/2014 {

    import delimited using `i'/Medicare-Physician-and-Other-Supplier-NPI-Aggregate-CY`i'.txt, delimiters(tab) clear

    * resolve inconsistencies between 2012/2013 and 2014
    if `i' != 2014 {
        * if 2012 or 2013, rename variables so they're more in line with 2014 variable names
        do RichardOuyang_rename.do
    }
    else {
        * drop standardized amounts, since this data is only available for 2014
        drop *medicare_stnd_amt
    }

    * limit analysis to just the US (for now)
    drop if nppes_provider_country != "US"
    drop if nppes_provider_state == "XX"

    drop if medicare_participation_indicator == "N"

    * drop unneeded variables
    drop nppes_provider_last_org_name nppes_provider_first_name nppes_provider_mi nppes_provider_street1 nppes_provider_street2 nppes_provider_city nppes_provider_zip nppes_provider_country medicare_participation_indicator

    capture confirm var stdev_*
    if _rc == 0 {
        drop stdev_
    }

    local toclean number_of_hcpcs-total_medicare_payment_amt total_drug_services-total_drug_medicare_payment_amt total_med_services-total_med_medicare_payment_amt beneficiary_age_less_65_count-beneficiary_dual_count

    foreach var of varlist `toclean' {
        capture confirm string var `var'
        if _rc == 0 {
            replace `var' = subinstr(`var', ",", "", .)
            replace `var' = subinstr(`var', "$", "", .)
        }
        
    }
    destring `toclean', replace

    local categorical nppes_credentials-nppes_provider_state drug_suppress_indicator med_suppress_indicator

    replace nppes_credentials = subinstr(nppes_credentials, ".", "", .)

    foreach var of varlist `categorical' {
        local newvar = substr("`var'", 1, 31)
        encode `var', generate(`newvar'2)
        drop `var'
        rename `newvar'2 `var'
    }

    compress
    save `i'/aggregate`i', replace
}
