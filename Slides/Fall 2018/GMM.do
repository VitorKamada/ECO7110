


clear all
use mus06data.dta



* Read data, define global x2list, and summarize data
global x2list totchr age female blhisp linc 
summarize ldrugexp hi_empunion $x2list ssiratio multlc

* Summarize available instruments 
summarize ssiratio lowincome multlc firmsz if linc!=.

* Obtain OLS estimates to compare with preceding IV estimates
regress ldrugexp hi_empunion $x2list, vce(robust) 


* IV estimation of a just-identified model with single endog regressor
ivregress 2sls ldrugexp (hi_empunion = ssiratio) $x2list, vce(robust) first

* Comparison Table
ivregress 2sls ldrugexp (hi_empunion = ssiratio) $x2list, vce(robust) 
estimates store IV

ivregress gmm ldrugexp (hi_empunion = ssiratio) $x2list, wmatrix(robust) 
estimates store OGMM

ivregress liml ldrugexp (hi_empunion = ssiratio) $x2list, vce(robust) 
estimates store LIML

estimates table IV OGMM LIML, b(%9.4f) se 



* Compare 5 estimators and variance estimates for overidentified models
global ivmodel "ldrugexp (hi_empunion = ssiratio multlc) $x2list"

quietly ivregress 2sls $ivmodel 
estimates store TwoSLS
quietly ivregress 2sls $ivmodel, vce(robust)
estimates store Rob_2SLS
quietly ivregress gmm  $ivmodel, wmatrix(unadjusted) 
estimates store GMM
quietly ivregress gmm  $ivmodel, wmatrix(robust) 
estimates store Rob_GMM
quietly ivregress liml $ivmodel, vce(robust)
estimates store Rob_LIML

estimates table TwoSLS Rob_2SLS GMM Rob_GMM Rob_LIML, b(%9.4f) se 


* Test of overidentifying restrictions following ivregress gmm
quietly ivregress gmm ldrugexp (hi_empunion = ssiratio multlc) ///
  $x2list, wmatrix(robust) 
estat overid

* Test of overidentifying restrictions following ivregress gmm
ivregress gmm ldrugexp (hi_empunion = ssiratio lowincome multlc firmsz) ///
  $x2list, wmatrix(robust) 
estat overid


* Manual Implementation of Test of overidentifying restrictions
* based on Wooldridge
predict uhat, residuals

reg uhat ssiratio lowincome multlc firmsz $x2list

display e(r2)*e(N) 
display 1-chi2(3,e(r2)*e(N))



