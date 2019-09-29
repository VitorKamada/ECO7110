



********** SYSTEMS OF LINEAR REGRESSIONS

* Summary statistics for seemingly unrelated regressions example
clear all
use mus05surdata.dta
summarize ldrugexp ltotothr age age2 educyr actlim totchr medicaid private

// Not included in book
summarize ldrugexp if ldrugexp!=. & ltotothr!=.


reg ldrugexp age age2 actlim totchr medicaid private
reg ltotothr age age2 educyr actlim totchr private

correlate ldrugexp ltotothr

* SUR estimation of a seemingly unrelated regressions model
sureg (ldrugexp age age2 actlim totchr medicaid private) ///
  (ltotothr age age2 educyr actlim totchr private), corr

* Bootstrap to get heteroskedasticity-robust SEs for SUR estimator 
bootstrap, reps(400) seed(10101) nodots: sureg        ///
  (ldrugexp age age2 actlim totchr medicaid private)  ///
  (ltotothr age age2 educyr actlim totchr private) 

* Test of variables in both equations
quietly sureg (ldrugexp age age2 actlim totchr medicaid private) ///
   (ltotothr age age2 educyr actlim totchr private)
test age age2

* Test of variables in just the first equation
test [ldrugexp]age [ldrugexp]age2

* Test of a restriction across the two equations
test [ldrugexp]private = [ltotothr]private

* Specify a restriction across the two equations
constraint 1 [ldrugexp]private = [ltotothr]private

* Estimate subject to the cross-equation constraint
sureg (ldrugexp age age2 actlim totchr medicaid private)        ///
  (ltotothr age age2 educyr actlim totchr private), constraints(1) 

