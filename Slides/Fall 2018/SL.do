


clear  all
use MROZ.DTA



global xlist educ exper expersq
global slist nwifeinc age kidslt6 kidsge6

sum lwage $xlist $slist inlf motheduc fatheduc

reg lwage $xlist


heckman lwage $xlist, select(inlf = $xlist $slist) twostep 

heckman lwage $xlist, select(inlf = $xlist $slist)


/* Heckman Manually

probit inlf $xlist $slist
predict xd3h, xb
gen phi3 = normalden(xd3h)
gen PHI3 = normal(xd3h)
gen lambda3 = phi3/PHI3

reg lwage $xlist lambda3 
sum lambda3

*/


probit inlf $xlist $slist motheduc fatheduc

predict xd3h, xb
gen phi3 = normalden(xd3h)
gen PHI3 = normal(xd3h)
gen lambda3 = phi3/PHI3

ivreg lwage exper expersq lambda3 (educ = nwifeinc age kidslt6 kidsge6 motheduc fatheduc)

