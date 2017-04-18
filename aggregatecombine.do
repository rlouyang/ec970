use 2012/aggregate2012, clear
append using 2013/aggregate2013 2014/aggregate2014, generate(year)

encode provider_type, generate(provider_type2)
drop provider_type
rename provider_type2 provider_type

drop npi number_of_hcpcs number_of_drug_hcpcs number_of_med_hcpcs

* make year into a categorical variable
generate year2 = string(year + 2012)
drop year
encode year2, generate(year)
drop year2

label variable year "Year"

compress

save aggregate, replace