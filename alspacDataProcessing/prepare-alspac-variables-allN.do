aln             double  %10.0g                
qlet            float   %9.0g                 
ethnicity       byte    %8.0g      ETHNICIT   Child ethnic background - derived
c804            byte    %8.0g      C804       Child ethnic background
bmi11           float   %9.0g      fems026a   BMI at 11y
b032            byte    %8.0g                 parity
hhsocclass      float   %9.0g      soclass    head of household social class
matsm2          float   %9.0g      binary     maternal smoking in pregnancy
mated           float   %17.0g     mated      Mother's highest ed qualification


*****
***** this version doesn't drop people after the merge and we use this for the
***** confounder table (comparing those in and not in our sample)

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
keep aln qlet fems026a
save "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/bmi11.dta"

* parity (b032)
* mother smoked in preg  - b665 b667
use "/Volumes/data/Current/Quest/Mother/b_4d.dta"
keep aln b032 b681 b663 b659 b653 b654 b655 b656  b665 b667 b670 b671 b700 b701 b702
save "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/vars-18wksgest.dta"





** ** ** ** ** ** 
** combine and generate derived variables
use "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/bmi11.dta"
merge m:1 aln using "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/vars-32wksgest.dta"
drop _merge

merge m:1 aln using "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/vars-18wksgest.dta"
drop _merge


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

replace bmi11=. if bmi11<0

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

rename b032 parity
rename fems026a bmi11
rename c804 ethnicity

replace  ethnicity=. if  ethnicity<0


gen qletF = 1 if qlet == "A"
replace qletF = 2 if qlet == "B"
drop qlet
rename qletF qlet

drop b6* b7* smok16wks smok32wks c482 c645

outsheet using  "/Volumes/Filestore/My Files/Student Filestore/lm0423/TEMP/myvars-for-bigrams-allN.csv", comma nolabel replace

