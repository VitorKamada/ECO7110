

clear all

use wagepan.dta 

sum lwage educ black hisp exper married union

xtset nr year


reg lwage educ black hisp exper expersq married union i.year
estimates store OLS

xtreg lwage educ black hisp exper expersq married union i.year, re
estimates store RE

xtreg lwage educ black hisp exper expersq married union i.year, fe
estimates store FE

estimates table OLS RE FE, b(%7.4f) se

* Traditional Approach
* The traditional Hausman test that incorrectly includes the coefficients
* on "spring" (the time dummy) among those being tested.

hausman FE RE

hausman FE RE, sigmamore


* The Correlated Random Effects - Mundlak (1978)
egen experbar = mean(exper), by(nr)
egen expersqbar = mean(expersq), by(nr)
egen marriedbar = mean(married), by(nr)
egen unionbar = mean(union), by(nr)

list nr year union unionbar exper experbar in 1/10

xtreg lwage educ black hisp exper expersq married union experbar expersqbar marriedbar unionbar i.year , re


test expersqbar marriedbar unionbar

test unionbar


* Fully Efficient
xtreg lwage educ black hisp exper expersq married union  experbar expersqbar marriedbar unionbar i.year, re cluster(nr)

test expersqbar marriedbar unionbar

test unionbar




 
