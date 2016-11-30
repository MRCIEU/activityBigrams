
* module add apps/stata14 

insheet using "../data/datasetWithInSampleForStataV3.csv", clear


*** AGE

replace age11_left = "" if age11_left == "NaN"
destring age11_left, replace
gen age11 = age11_left if insample == 1
replace age11 = age11_right if insample == 0
replace age11 = age11/365

summ age11 if insample == 0
summ age11 if insample == 1
*regress age11 insample 
logistic insample age11

*** GENDER

replace sex_left = "" if sex_left == "NaN"
replace sex_right = "" if sex_right == "NaN"
destring sex_left, replace
destring sex_right, replace
gen sex = sex_left if insample == 1
replace sex = sex_right if insample == 0
drop sex_*

tab sex if insample == 0
tab sex if insample == 1

replace sex = 0 if sex ==1
replace sex = 1 if sex ==2
* 0 male, 1 female
*prtest sex, by(insample)
logistic insample sex

*** BMI 

replace bmi11_left = "" if bmi11_left == "NaN"
replace bmi11_right = "" if bmi11_right == "NaN"
destring bmi11_left, replace
destring bmi11_right, replace
gen bmi11 = bmi11_left if insample == 1
replace bmi11 = bmi11_right if insample == 0
drop bmi11_*

summ bmi11 if insample == 0
summ bmi11 if insample == 1
*regress bmi insample 
logistic insample bmi

*** PARITY

replace parity_left = "" if parity_left == "NaN"
destring parity_left, replace
gen parity = parity_left if insample == 1
replace parity = parity_right if insample == 0
drop parity_*

tab parity if insample == 0
tab parity if insample == 1

*tab parity, gen(parityI)
*prtest parityI1, by(insample)
*prtest parityI2, by(insample)
*prtest parityI3, by(insample)
logistic insample parity

*** household social class

replace hhsoc_left = "" if hhsoc_left == "NaN"
replace hhsoc_right = "" if hhsoc_right == "NaN"
destring hhsoc_left, replace
destring hhsoc_right, replace
gen hhsoc = hhsoc_left if insample == 1
replace hhsoc = hhsoc_right if insample == 0
drop hhsoc_*

tab hhsoc if insample == 0
tab hhsoc if insample == 1
logistic insample hhsoc

*tab hhsoc, gen(hhsocI)
*prtest hhsocI1, by(insample)
*prtest hhsocI2, by(insample)
*prtest hhsocI3, by(insample)
*prtest hhsocI4, by(insample)
*prtest hhsocI5, by(insample)


*** ETHNICITY

replace ethnicity_left = "" if ethnicity_left == "NaN"
replace ethnicity_right = "" if ethnicity_right == "NaN"
destring ethnicity_left, replace
destring ethnicity_right, replace
gen ethnicity = ethnicity_left if insample == 1
replace ethnicity = ethnicity_right if insample == 0
drop ethnicity_*

replace ethnicity = 0 if ethnicity ==1
replace ethnicity = 1 if ethnicity ==2

tab ethnicity if insample == 0
tab ethnicity if insample == 1
* logistic insample i.ethnicity
*prtest ethnicity, by(insample)
logistic insample ethnicity

**** MATERNAL EDUCATION


replace mated_left = "" if mated_left == "NaN"
replace mated_right = "" if mated_right == "NaN"
destring mated_left, replace
destring mated_right, replace
gen mated = mated_left if insample == 1
replace mated = mated_right if insample == 0
drop mated_*

tab mated if insample == 0
tab mated if insample == 1

*tab mated, gen(matedI)
*prtest matedI1, by(insample)
*prtest matedI2, by(insample)
*prtest matedI3, by(insample)
*prtest matedI4, by(insample)
logistic insample mated

**** MATERNAL SMOKING IN PREGNANCY

replace matsmpreg_left = "" if matsmpreg_left == "NaN"
destring matsmpreg_left, replace

replace matsmpreg_right = "" if matsmpreg_right == "NaN"
destring matsmpreg_right, replace

gen matsmpreg = matsmpreg_left if insample == 1
replace matsmpreg = matsmpreg_right if insample == 0
drop matsmpreg_*

tab matsmpreg if insample == 0
tab matsmpreg if insample == 1

*prtest matsmpreg, by(insample)
logistic insample matsmpreg
