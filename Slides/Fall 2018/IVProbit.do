


clear all



use mus14data.dta, clear

* Endogenous probit using inconsistent probit MLE
generate linc = log(hhincome)
global xlist2 female age age2 educyear married hisp white chronic adl hstatusg
probit ins linc $xlist2, vce(robust) nolog
probit ins linc $xlist2


* Endogenous probit using ivprobit ML estimator
global ivlist2 retire sretire
ivprobit ins $xlist2 (linc = $ivlist2), vce(robust) nolog
ivprobit ins $xlist2 (linc = $ivlist2), vce(robust) mle 

* Endogenous probit using ivprobit 2-step estimator
ivprobit ins $xlist2 (linc = $ivlist2), twostep first

* Endogenous probit using ivregress to get 2SLS estimator
ivregress 2sls ins $xlist2 (linc = $ivlist2), vce(robust) noheader
estat overid


* 2SLS estimation
quietly ivregress 2sls ins $xlist (retire= female sretire seprhi adl), robust 
estimates store TSLS_IV4



* biprobit
clear all

use labsup.dta, clear

reg morekids samesex nonmomi educ age agesq black hispan, robust

probit morekids samesex nonmomi educ age agesq black hispan, robust


reg worked morekids nonmomi educ age agesq black hispan, robust

probit worked morekids nonmomi educ age agesq black hispan 
margins, dydx(*)


ivreg worked nonmomi educ age agesq black hispan (morekids = samesex), robust


biprobit (worked = morekids nonmomi educ age agesq black hispan) ///
(morekids = samesex nonmomi educ age agesq black hispan)


biprobit (worked = morekids nonmomi educ age agesq black hispan) ///
(morekids =  nonmomi educ age agesq black hispan)

