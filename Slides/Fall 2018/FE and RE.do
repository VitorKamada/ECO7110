

clear all

use fatality.dta 


xtset state year

gen vfrall=10000*mrall
replace vmiles = vmiles/1000
replace perinc = perinc/1000

sum vfrall beertax unrate vmiles jaild perinc




reg vfrall beertax, vce(cluster state)
estimates store OLS

reg vfrall beertax unrate vmiles jaild perinc i.year, vce(cluster state)
estimates store OLS1

xtreg vfrall beertax unrate vmiles jaild perinc i.year, re vce(cluster state)
estimates store RE


xtreg vfrall beertax, fe vce(cluster state)
estimates store FE1

xtreg vfrall beertax unrate vmiles jaild perinc i.year, fe vce(cluster state)
estimates store FE2

reg vfrall beertax unrate vmiles jaild perinc i.state i.year, vce(cluster state)
estimates store Dummies

estimates table OLS OLS1 RE FE1 FE2 Dummies, b(%7.4f) se


xtreg vfrall beertax unrate vmiles jaild perinc i.year, re vce(cluster state) theta

