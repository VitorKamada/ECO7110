

clear all 
use mroz.dta
summarize wage exper educ motheduc fatheduc husedu if inlf==1

reg lwage exper expersq educ if inlf==1


reg educ exper expersq motheduc fatheduc huseduc if inlf==1

predict educhat, xb

test motheduc fatheduc huseduc

reg lwage exper expersq educhat if inlf==1



ivregress 2sls lwage exper expersq (educ = motheduc fatheduc husedu) if inlf==1

