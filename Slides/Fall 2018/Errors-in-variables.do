


* Inconsistency of OLS in errors-in-variables model (measurement error)
clear
quietly set obs 10000
set seed 10101
matrix mu = (0,0,0)
matrix sigmasq = (9,0,0\0,1,0\0,0,1)
drawnorm xstar u v, means(mu) cov(sigmasq)
generate y = 1*xstar + u   // DGP for y depends on xstar
generate x = xstar + v     // x is mismeasured xstar 
regress y x, noconstant

eivreg y x, r(x .9)


sem (x<-X) (y<-X), reliability(x .9)
