



* ethnicity (c804), 
* smoking at 32 wks gestation (c482)
* Social Class - Maternal (c755)
* Social Class - Paternal (c765)
*  Mums highest ed qualification (c645)
use "/Volumes/data/Current/Quest/Mother/c_7d.dta"
keep aln c804 c482 c755 c765 c645
save "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/vars-32wksgest.dta"

* bmi 11
use "/Volumes/data/Current/Clinic/Child/f11_4b.dta
keep aln qlet fems026a fe003a
save "/Volumes/lm0423/TEMP/bmi11.dta"

* parity (b032)
* mother smoked in preg  - b665 b667
use "/Volumes/data/Current/Quest/Mother/b_4d.dta"
keep aln b032 b681 b663 b659 b653 b654 b655 b656  b665 b667 b670 b671 b700 b701 b702
save "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/vars-18wksgest.dta"


* sex
use "/Volumes/data/Current/Other/Sample Definition/kz_5b.dta"
keep aln qlet kz021
save "/Volumes/lm0423/TEMP/sex.dta"


** ** ** ** ** ** 
** combine and generate derived variables
use "/Volumes/lm0423/TEMP/bmi11.dta"
merge m:1 aln using "/Volumes/lm0423/TEMP/vars-32wksgest.dta"
drop if _merge ==2
*drop if _merge ==1
drop _merge

merge m:1 aln using "/Volumes/lm0423/TEMP/vars-18wksgest.dta"
drop if _merge ==2
*drop if _merge ==1
drop _merge

merge m:1 aln qlet using "/Volumes/lm0423/TEMP/sex.dta"
drop if _merge ==2
*drop if _merge ==1
drop _merge

* age
rename fe003a age11

* sex
rename kz021 sex


* maternal smoking
gen smok16wks = 0 if b665!=. | b667!=.
replace smok16wks = 1 if b665==2 | b665==5 | b667==2 | b667==5

replace c482 = . if c482<0
gen smok32wks = 0 if c482!=.
replace smok32wks = 1 if c482>0 & c482!=.

gen matSmPreg = 0 if smok16wks==0 | smok32wks==0
replace matSmPreg = 1 if smok16wks==1 | smok32wks==1


replace b670=. if b670<0
replace b671=. if b671<0



* household social class - lowest of mother and father
replace c755 =. if c755 == -1
replace c765 =. if c765 == -1
gen hhsoc = c755
replace hhsoc = c765 if c765!=. & c765<c755
* group because lowest (6) has small N
replace hhsoc = 5 if hhsoc == 6
drop c755 c765

* mated
replace c645 = . if c645<0
gen mated = 1 if c645 == 1 | c645 == 2
replace  mated = 2 if  c645 == 3
replace  mated = 3 if  c645 == 4
replace  mated = 4 if  c645 == 5

replace b032 = . if b032 <0
replace b032 = 2 if b032 >2

rename b032 parity
rename fems026a bmi11
rename c804 ethnicity

replace  ethnicity=. if  ethnicity<0
replace bmi11=. if bmi11<0

gen qletF = 1 if qlet == "A"
replace qletF = 2 if qlet == "B"
drop qlet
rename qletF qlet

drop b6* b7* smok16wks smok32wks c482 c645

*outsheet using  "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/myvars-for-bigrams.csv", comma nolabel replace
outsheet using  "/Volumes/lm0423/TEMP/myvars-for-bigramsV2.csv", comma nolabel replace

END

*****

save "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/myvars-for-bigrams.dta", replace


* checking the variables are the same / nearly the same as those used for PA in preg paper
rename ethnicity ethnicityX
rename parity parityX
rename mated matedX
rename bmi11 bmi11X
rename matSmPreg matsmX
rename hhsoc hhsocX

merge 1:1 aln qlet using "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/vars-for-bigrams.dta"

tab matsm2 matsmX
tab hhsocclass hhsocX
tab mated matedX

* mat smoke is wrong










