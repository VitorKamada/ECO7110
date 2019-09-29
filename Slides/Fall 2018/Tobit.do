

clear all 
use MROZ.DTA

sum hours nwifeinc educ exper expersq age kidslt6 kidsge6

histogram hours, frequency title(Hours worked by married women)


reg hours nwifeinc educ exper expersq age kidslt6 kidsge6, vce(robust)

tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6, ll(0)

margins, dydx(*) predict(ystar(0,.))

margins, dydx(*) predict(e(0,.))


* Same of Tobit Slope (special case, when the CDF=1)
margins, dydx(*) 


* IV Tobit
reg nwifeinc huseduc educ exper expersq age kidslt6 kidsge6

predict vhat, resid

tobit hours nwifeinc vhat educ exper expersq age kidslt6 kidsge6, ll(0)
