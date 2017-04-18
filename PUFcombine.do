use 2012/PUF2012, clear
append using 2013/PUF2013 2014/PUF2014, generate(year)

encode provider_type, generate(provider_type2)
drop provider_type
rename provider_type2 provider_type

drop npi

* make year into a categorical variable
generate year2 = string(year + 2012)
drop year
encode year2, generate(year)
drop year2

* doesn't work:
* egen year2 = group(year)

* hcpcs_code is too much. first 3/4 characters might be better
* taking first 3 gives too many to use as a factor variable.
* if we only take the first two characters of the HCPCS code, we get 124 different codes.
decode hcpcs_code, generate(hcpcs_code2)
replace hcpcs_code2 = substr(hcpcs_code2, 1, 2)
encode hcpcs_code2, generate(hcpcs_code3)

drop hcpcs_code hcpcs_code2
rename hcpcs_code3 hcpcs_code

do RichardOuyang_label.do

compress

save PUF, clear