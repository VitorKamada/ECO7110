

clear all

* Poisson (mu=1) generated data
quietly set obs 10000
set seed 7              // set the seed !
generate Y = rpoisson(1) // draw from Poisson(mu=1)    
summarize Y 
tabulate Y 

histogram Y, discrete 
graph save Y, replace



********** RAND Health Insurance Experiment **********

use randdata.dta, clear

* educdec is missing for some observations
drop if educdec==.

* rename variables
rename mdvis MDU
rename meddol MED
rename binexp DMED
rename lnmeddol LNMED
rename linc LINC
rename lfam LFAM
rename educdec EDUCDEC
rename xage AGE
rename female FEMALE
rename child CHILD 
rename fchild FEMCHILD
rename black BLACK
rename disea NDISEASE
rename physlm PHYSLIM
rename hlthg HLTHG
rename hlthf HLTHF
rename hlthp HLTHP
rename idp IDP
rename logc LC
rename lpi LPI
rename fmde FMDE

global XLIST LC IDP LPI FMDE PHYSLIM NDISEASE HLTHG HLTHF HLTHP /* 
     */ LINC LFAM EDUCDEC AGE FEMALE CHILD FEMCHILD BLACK

sum MDU $XLIST

* Histogram with kernel density estimate
hist MDU, discrete kdensity
graph save MDU, replace

* Default standard errors assume variance = mean (ignoring overdispersion)
poisson MDU $XLIST
estimates store poisml

* Should always control for possible overdispersion 
poisson MDU $XLIST, robust
estimates store poisrobust

margins, dydx(*)





* Negative binomial (mu=1 var=2) generated data
generate G = rgamma(1,1)
generate Z = rpoisson(G)  // NB generated as a Poisson-gamma mixture 
summarize Z
tabulate Z


histogram Z, discrete xtitle("Negative binomial")
graph save mus17negbin, replace



* Default standard errors assume variance = mean (ignoring overdispersion)
nbreg MDU $XLIST
estimates store nbml

* Should always control for possible overdispersion 
nbreg MDU $XLIST, robust
estimates store nbrobust

margins, dydx(*)

* Install this command
* help countfit
countfit MDU $XLIST









