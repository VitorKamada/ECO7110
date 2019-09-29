


clear all 

use klein2.dta
sum  
describe 

* homoskedasticity
reg3 (c p L.p w) (i p L.p L.k) (wp y L.y yr), endog(w p y) exog(t wg g)

*  GMM 3SLS 
gmm (eq1: c - {c: p L.p w _cons})  ///
    (eq2: i - {i: p L.p L.k _cons}) ///
    (eq3: wp - {wp: y L.y yr _cons}), ///
  instruments(eq1: L.p L.k L.y yr t wg g) ///
  instruments(eq2: L.p L.k L.y yr t wg g) ///
  instruments(eq3: L.p L.k L.y yr t wg g) ///
  winitial(unadjusted, independent)  twostep


* 3SLS like reg3. 

gmm (eq1: c - {c: p L.p w _cons})  ///
    (eq2: i - {i: p L.p L.k _cons}) ///
    (eq3: wp - {wp: y L.y yr _cons}), ///
  instruments(eq1: L.p L.k L.y yr t wg g) ///
  instruments(eq2: L.p L.k L.y yr t wg g) ///
  instruments(eq3: L.p L.k L.y yr t wg g) ///
  winitial(unadjusted, independent)  wmatrix(unadjusted) twostep
  
  
  
  
  