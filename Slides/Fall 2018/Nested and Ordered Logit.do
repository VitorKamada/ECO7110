
* Changed by Vitor Kamada 7-24-2018


cap log close


********** SETUP **********

set more off
version 11
clear all
set linesize 82
set scheme s1mono  /* Graphics scheme */

********** DATA DESCRIPTION **********

* File mus15data is from 
* J. A. Herriges and C. L. Kling, 
* "Nonlinear Income Effects in Random Utility Models", 
* Review of Economics and Statistics, 81(1999): 62-72
* Also analyzed in Cameron and Trivedi (2005) chapter 15

* File mus18data.dta is from
* Rand Health Insurance Experiment data 
* Essentially same data as in P. Deb and P.K. Trivedi (2002)
* "The Structure of Demand for Medical Care: Latent Class versus
* Two-Part Models", Journal of Health Economics, 21, 601-625
* except that paper used different outcome (counts rather than $)
* Each observation is for an individual over a year.
* Individuals may appear in up to five years.
* All available sample is used except only fee for service plans included.
* If panel data used then clustering is on id (person id)

********** 15.3: MULTINOMIAL EXAMPLE: CHOICE OF FISHING MODE

set more off
version 11
set linesize 82
set scheme s1mono  /* Graphics scheme */

* Read in dataset and describe dependent variable and regressors
use mus15data.dta, clear
describe

* Summarize dependent variable and regressors
summarize, separator(0) 

* Tabulate the dependent variable
tabulate mode

* Table of income by fishing mode
table mode, contents(N income mean income sd income)

* Table of fishing price by fishing mode
table mode, contents(mean pbeach mean ppier mean pprivate mean pcharter) format(%6.0f)

* Table of fishing catch rate by fishing mode
table mode, contents(mean qbeach mean qpier mean qprivate mean qcharter) format(%6.2f)

********** 15.4 MULTINOMIAL LOGIT MODEL

* Multinomial logit with base outcome alternative 1
mlogit mode income, baseoutcome(1) nolog

* Wald test of the joint significance of income
test income

* Relative-risk option reports exp(b) rather than b
mlogit mode income, rr baseoutcome(1) nolog

// Following used below
estimates store MNL

* Predict probabilities of choice of each mode and compare to actual freqs
predict pmlogit1 pmlogit2 pmlogit3 pmlogit4, pr
summarize pmlogit* dbeach dpier dprivate dcharter, separator(4)

* Sample average predicted probability of the third outcome
margins, predict(outcome(3)) noatlegend

* Marginal effect at mean of income change for outcome 3
margins, dydx(*) predict(outcome(3)) atmean noatlegend

* Average marginal effect of income change for outcome 3
margins, dydx(*) predict(outcome(3)) noatlegend
********** 15.5 CONDITIONAL LOGIT 

* Data are in wide form
list mode price pbeach ppier pprivate pcharter in 1, clean

* Convert data from wide form to long form
generate id = _n
reshape long d p q, i(id) j(fishmode beach pier private charter) string
save mus15datalong.dta, replace

* List data for the first case after reshape
list in 1/4, clean noobs

* Conditional logit with alternative-specific and case-specific regressors
asclogit d p q, case(id) alternatives(fishmode) casevars(income) basealternative(beach) nolog 

// Following used below
estimates store CL

* Predicted probabilities of choice of each mode and compare to actual freqs
predict pasclogit, pr
table fishmode, contents(mean d mean pasclogit sd pasclogit) cellwidth(15)

// Following not included in book
estat alternatives

* Marginal effect at mean of change in price
estat mfx, varlist(p)

* Alternative-specific example: AME of beach price change computed manually
preserve
quietly summarize p
generate delta = r(sd)/1000
quietly replace p = p + delta if fishmode == "beach"
predict pnew, pr
generate dpdbeach = (pnew - pasclogit)/delta
tabulate fishmode, summarize(dpdbeach)
restore

********** 15.6 NESTED LOGIT

* Define the Tree for Nested logit
*       with nesting structure 
*             /     \
*           /  \   /  \

* Convert string variable fishmode to integer values and attach labels
* encode fishmode, gen(intmode)
* label list intmode     // Check ordering of intmode

* Define the tree for nested logit
nlogitgen type = fishmode(shore: pier | beach, boat: private | charter)

* Check the tree
nlogittree fishmode type, choice(d)

* Nested logit model estimate
nlogit d p q || type:, base(shore) || fishmode: income, case(id) notree nolog


// Following used below
estimates store NL

* Predict level 1 and level 2 probabilities from NL model
predict plevel1 plevel2, pr
tabulate fishmode, summarize(plevel2)

// Following not included in book
list d plevel1 plevel2 in 1/4, clean
estat alternatives

* AME of beach price change computed manually
preserve
quietly summarize p
generate delta = r(sd)/1000
quietly replace p = p + delta if fishmode == "beach"
predict pnew1 pnew2, pr
generate dpdbeach = (pnew2 - plevel2)/delta
tabulate fishmode, summarize(dpdbeach)
restore

* Summary statistics for the logit models
estimates table MNL CL NL, keep(p q) stats(N ll aic bic) equation(1) b(%7.3f) stfmt(%7.0f)







********** 15.9: ORDERED OUTCOME MODEL

* Create multinomial ordered outcome variables takes values y = 1, 2, 3
use mus18data.dta, clear
quietly keep if year==2
generate hlthpf = hlthp + hlthf
generate hlthe = (1 - hlthpf - hlthg)
quietly generate hlthstat = 1 if hlthpf == 1
quietly replace hlthstat = 2 if hlthg == 1
quietly replace hlthstat = 3 if hlthe == 1
label variable hlthstat "health status"
label define hsvalue 1 poor_or_fair 2 good 3 excellent
label values hlthstat hsvalue
tabulate hlthstat

* Summarize dependent and explanatory variables
summarize hlthstat age linc ndisease

* Ordered logit estimates
ologit hlthstat age linc ndisease, nolog

* Calculate predicted probability that y=1, 2, or 3 for each person
predict p1ologit p2ologit p3ologit, pr
summarize hlthpf hlthg hlthe p1ologit p2ologit p3ologit, separator(0)

* Marginal effect at mean for 3rd outcome (health status excellent)
margins, dydx(*) predict(outcome(3)) atmean noatlegend



********** CLOSE OUTPUT
