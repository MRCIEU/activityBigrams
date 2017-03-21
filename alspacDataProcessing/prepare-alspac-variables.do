

* ethnicity (c804), 
* smoking at 32 wks gestation (c482)
* Social Class - Maternal (c755)
* Social Class - Paternal (c765)
*  Mums highest ed qualification (c645)

use "../../data/original/alspac/c_7d.dta"
keep aln c804 c482 c755 c765 c645
save "../../data/derived/activityBigrams/alspac/vars-32wksgest.dta"

* bmi 11
use "../../data/original/alspac/f11_4b.dta"
keep aln qlet fems026a fe003a
save "../../data/derived/activityBigrams/alspac/bmi11.dta"

* parity (b032)
* mother smoked in preg  - b665 b667
use "../../data/original/alspac/b_4d.dta"
keep aln b032 b681 b663 b659 b653 b654 b655 b656  b665 b667 b670 b671 b700 b701 b702
save "../../data/derived/activityBigrams/alspac/vars-18wksgest.dta"

* sex
use "../../data/original/alspac/kz_5b.dta"
keep aln qlet kz021
save "../../data/derived/activityBigrams/alspac/sex.dta"


** ** ** ** ** ** 
** combine and generate derived variables
use "../../data/derived/activityBigrams/alspac/bmi11.dta"
merge m:1 aln using "../../data/derived/activityBigrams/alspac/vars-32wksgest.dta"
drop if _merge ==2
drop _merge

merge m:1 aln using "../../data/derived/activityBigrams/alspac/vars-18wksgest.dta"
drop if _merge ==2
drop _merge

merge m:1 aln qlet using "../../data/derived/activityBigrams/alspac/sex.dta"
drop if _merge ==2
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

* parity
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

outsheet using  "../../data/derived/activityBigrams/alspac/alspac-variables.csv", comma nolabel replace

