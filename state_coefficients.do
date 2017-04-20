maptile_install using "http://files.michaelstepner.com/geo_state.zip"

* average_medicare_allowed_amt
xtset nppes_provider_state
xtreg average_medicare_allowed_amt `x_vars', fe
predict state_effect_allowed, u

* average_submitted_chrg_amt
xtset nppes_provider_state
xtreg average_submitted_chrg_amt `x_vars', fe
predict state_effect_submitted, u

gen diff = (average_submitted_chrg_amt - average_medicare_allowed_amt) / average_medicare_allowed_amt
xtset nppes_provider_state
xtreg diff `x_vars', fe
predict state_effect_diff, u

keep nppes_provider_state state_effect_allowed state_effect_submitted state_effect_diff
duplicates drop
drop if missing(state_effect_allowed)
decode nppes_provider_state, generate(state)
maptile state_effect_allowed, geo(state) twopt(title("Average Medicare Allowed Amount, Fixed Effects Coefficients by State", size(medium)) ) fcolor(Blues) savegraph("allowed_state_coefficients.pdf") replace

maptile state_effect_submitted, geo(state) twopt(title("Average Submitted Charge Amount, Fixed Effects Coefficients by State", size(medium)) ) fcolor(Blues) savegraph("submitted_state_coefficients.pdf") replace

maptile state_effect_diff, geo(state) twopt(title("Difference Between Submitted and Allowed Amounts, Fixed Effects Coefficients by State", size(medium)) ) fcolor(Blues) savegraph("diff_state_coefficients.pdf") replace
