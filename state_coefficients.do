maptile_install using "http://files.michaelstepner.com/geo_state.zip"

* average_medicare_allowed_amt
xtset nppes_provider_state
xtreg average_medicare_allowed_amt `x_vars', fe
predict nppes_provider_state_effect, u
keep nppes_provider_state nppes_provider_state_effect
duplicates drop
drop if missing(nppes_provider_state_effect)
decode nppes_provider_state, generate(state)
maptile nppes_provider_state_effect, geo(state) twopt(title("Average Medicare Allowed Amount Fixed Effects Coefficients by State", size(medium)) ) fcolor(Blues) savegraph("allowed_state_coefficients.pdf") replace
drop nppes_provider_state_effect

* average_submitted_chrg_amt
xtset nppes_provider_state
xtreg average_submitted_chrg_amt `x_vars', fe
predict nppes_provider_state_effect, u
keep nppes_provider_state nppes_provider_state_effect
duplicates drop
drop if missing(nppes_provider_state_effect)
decode nppes_provider_state, generate(state)
maptile nppes_provider_state_effect, geo(state) twopt(title("Average Submitted Charge Amount Fixed Effects Coefficients by State", size(medium)) ) fcolor(Blues) savegraph("submitted_state_coefficients.pdf") replace