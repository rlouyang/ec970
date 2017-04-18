* note that gender encompasses organization vs individual
decode nppes_provider_gender, generate(nppes_provider_gender2)
drop nppes_provider_gender
replace nppes_provider_gender2 = "Organization (provider gender)" if missing(nppes_provider_gender2)
replace nppes_provider_gender2 = "Male (provider gender)" if nppes_provider_gender2 == "M"
replace nppes_provider_gender2 = "Female (provider gender)" if nppes_provider_gender2 == "F"
encode nppes_provider_gender2, generate(nppes_provider_gender)
drop nppes_provider_gender2