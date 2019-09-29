


use qreg0902
describe
summarize


* drop zero observations for medical expenditures
drop if lhhex12m == .

* lhhexp1 is natural logarithm of household total expenditure
* lhhex12m is natural logarithm of household medical expenditure
gen lntotal = lhhexp1
gen lnmed = lhhex12m
label variable lntotal "Log Total Expenditure"
label variable lnmed "Log Medical Expenditure"
describe 
summarize




global Xlist sex age farm hhsize
sum lnmed lntotal $Xlist



qplot lnmed, recast(line) 
quietly graph export 1.eps, replace




* (1) Quantile and median regression for quantiles 0.1, 0.5 and 0.9
*     Save prediction to construct Figure 4.2. 
qreg lnmed lntotal, quant(.10)
predict pqreg10
qreg lnmed lntotal, quant(.5)
predict pqreg50
qreg lnmed lntotal, quant(.90)
predict pqreg90

* (2) Create Figure 4.2 on page 90 first as this is easy
graph twoway (scatter lnmed lntotal, msize(vsmall)) (lfit pqreg90 lntotal, clstyle(p2)) /*
  */ (lfit pqreg50 lntotal, clstyle(p1)) (lfit pqreg10 lntotal, clstyle(p3)), /*
  */ scale (1.2) plotregion(style(none)) /*
  */ title("Regression Lines as Quantile Varies") /*
  */ xtitle("Log Household Medical Expenditure", size(medlarge)) xscale(titlegap(*5)) /* 
  */ ytitle("Log Household Total Expenditure", size(medlarge)) yscale(titlegap(*5)) /*
  */ legend(pos(11) ring(0) col(1)) legend(size(small)) /*
  */ legend( label(1 "Actual Data") label(2 "90th percentile") /*
  */         label(3 "Median") label(4 "10th percentile"))
graph export 7.eps, replace








* Basic quantile regression for q = 0.5
qreg lnmed lntotal $Xlist


* Compare (1) OLS; (2-4) coeffs across quantiles; (5) bootstrap SEs
quietly regress lnmed lntotal $Xlist   
estimates store OLS
quietly qreg lnmed lntotal $Xlist, quantile(.25)  
estimates store QR_25
quietly qreg lnmed lntotal $Xlist, quantile(.50) 
estimates store QR_50
quietly qreg lnmed lntotal $Xlist, quantile(.75) 
estimates store QR_75
set seed 2 
quietly bsqreg lnmed lntotal $Xlist, quant(.50) reps(400) 
estimates store BSQR_50 
estimates table OLS QR_25 QR_50 QR_75 BSQR_50, b(%7.3f) se  




* Plots of each regressor's coefficients as quantile q varies
quietly bsqreg lnmed lntotal $Xlist, quantile(.50) reps(400)
grqreg lntotal, ci ols olsci scale(1.1)

quietly graph export 4.eps, replace




* Test of coefficient equality across QR with different q
sqreg lnmed lntotal $Xlist, q(.25 .50 .75) reps(400)

test [q25=q50=q75]: lntotal


test [q25=q75]: lntotal






