
cap log close


********** SETUP **********

set more off
version 11
clear all
set memory 30m
set linesize 90
set scheme s1mono  /* Graphics scheme */

********** DATA DESCRIPTION **********

* mus08psidextract.dta
* PSID. Same as Stata website file psidextract.dta
* Data due to  Baltagi and Khanti-Akom (1990) 
* This is corrected version of data in Cornwell and Rupert (1988).
* 595 individuals for years 1976-82



******* : ARELLANO-BOND ESTIMATOR

* 2SLS or one-step GMM for a pure time-series AR(2) panel model
use mus08psidextract.dta, clear
sum 

xtabond lwage, lags(2) vce(robust)

* Optimal or two-step GMM for a pure time-series AR(2) panel model
xtabond lwage, lags(2) twostep vce(robust)

* Reduce the number of instruments for a pure time-series AR(2) panel model
xtabond lwage, lags(2) vce(robust) maxldep(1)
xtabond lwage, lags(2) vce(robust) maxldep(2)


* Optimal or two-step GMM for a dynamic panel model
xtabond lwage occ south smsa ind, lags(2) maxldep(3)     ///
  pre(wks,lag(1,2)) endogenous(ms,lag(0,2))              ///
  endogenous(union,lag(0,2)) twostep vce(robust) artests(3)

* Test whether error is serially correlated
estat abond

* Test of overidentifying restrictions (first estimate with no vce(robust))
quietly xtabond lwage occ south smsa ind, lags(2) maxldep(3) ///
  pre(wks,lag(1,2)) endogenous(ms,lag(0,2))              ///
  endogenous(union,lag(0,2)) twostep artests(3)
estat sargan

* Arellano/Bover or Blundell/Bond for a dynamic panel model
xtdpdsys lwage occ south smsa ind, lags(2) maxldep(3)    ///
  pre(wks,lag(1,2)) endogenous(ms,lag(0,2))              ///
  endogenous(union,lag(0,2)) twostep vce(robust) artests(3)

// Following not included in book
estat abond

* Use of xtdpd to exactly reproduce the previous xtdpdsys command
xtdpd L(0/2).lwage L(0/1).wks occ south smsa ind ms union, ///
  div(occ south smsa ind) dgmmiv(lwage, lagrange(2 4))          ///
  dgmmiv(ms union, lagrange(2 3)) dgmmiv(L.wks, lagrange(1 2))      ///
  lgmmiv(lwage wks ms union) twostep vce(robust) artests(3)

* Previous command if model error is MA(1)
xtdpd L(0/2).lwage L(0/1).wks occ south smsa ind ms union, ///
  div(occ south smsa ind) dgmmiv(lwage, lagrange(3 4))          ///
  dgmmiv(ms union, lagrange(2 3)) dgmmiv(L.wks, lagrange(1 2))      ///
  lgmmiv(L.lwage wks ms union) twostep vce(robust) artests(3)



********** CLOSE OUTPUT



*********** Replication
*** Wooldridge (2010): Chapter 11

use airfare

xtset id year

reg d(lfare l.lfare concen) y99 y00, vce(cluster id)
 
xtabond lfare concen y99 y00,  lags(1)  vce(robust)

xtabond lfare concen, lags(1) noconsta diffva(y99 y00) vce(robust)




