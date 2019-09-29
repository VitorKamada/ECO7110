


clear all 

* MROZ dataset 
use mroz.dta 

sum

reg educ exper expersq motheduc fatheduc huseduc
test (motheduc=0) (fatheduc=0) (huseduc=0)

// 2SLS
ivregress 2sls lwage exper expersq (educ = motheduc fatheduc huseduc) if inlf==1

ivregress 2sls lwage exper expersq (educ = motheduc fatheduc huseduc) if inlf==1, first



// Testing for Endogeneity
// Control Function Approach

quietly reg educ exper expersq motheduc fatheduc huseduc if inlf==1
predict vhat, residuals
reg lwage educ exper expersq vhat if inlf==1



// Bootstrap 

quietly reg educ exper expersq motheduc fatheduc huseduc if inlf==1, ///
  vce(boot, reps(400) seed(7) nodots)
predict vhat, residuals
reg lwage educ exper expersq vhat if inlf==1, vce(boot, reps(400) seed(7) nodots)

// First Stage
reg educ exper expersq motheduc fatheduc huseduc if inlf==1, ///
  vce(boot, reps(400) seed(7) nodots)

test (motheduc=0) (fatheduc=0) (huseduc=0)
  
  
* Card dataset 

clear all
use card.dta 

gen blackeduc = educ*black
gen blacknearc4 = black*nearc4


reg lwage educ blackeduc black exper expersq  south smsa reg662-reg669 smsa66


// 2SLS
ivregress 2sls lwage black  exper expersq  south smsa reg662-reg669 ///
  smsa66 (educ blackeduc = nearc4 blacknearc4), vce(robust)


// CF
quietly reg educ black exper expersq  south smsa reg662-reg669 ///
  smsa66 nearc4 blacknearc4,  vce(boot, reps(400) seed(7) nodots)
predict vhat1, residuals

quietly reg blackeduc black exper expersq  south smsa reg662-reg669 ///
  smsa66 nearc4 blacknearc4,  vce(boot, reps(400) seed(7) nodots)
predict vhat2, residuals

reg lwage educ blackeduc black vhat1 vhat2 exper expersq  south smsa ///
reg662-reg669 smsa66, vce(boot, reps(400) seed(7) nodots)

test (vhat1=0) (vhat2=0)


// First Stage
reg educ nearc4 blacknearc4 black exper expersq  south smsa reg662-reg669 ///
  smsa66 ,  vce(boot, reps(400) seed(7) nodots)


reg blackeduc nearc4 blacknearc4 black exper expersq  south smsa reg662-reg669 ///
  smsa66,  vce(boot, reps(400) seed(7) nodots)




