

clear all
use nls80.dta 


summarize 

reg lwage exper tenure married south urban black educ 
estimates store OLS

reg lwage exper tenure married south urban black educ iq 
estimates store Proxy

ivregress 2sls lwage exper tenure married south urban black (educ = iq )
estimates store IV_IQ

ivregress 2sls lwage exper tenure married south urban black (educ = iq kww)
estimates store IV_IQ_KWW

estimates table OLS Proxy IV_IQ IV_IQ_KWW, b(%9.4f) se 




ivregress 2sls lwage exper tenure married south urban black educ (iq = kww)

ivregress 2sls lwage exper tenure married south urban black educ (kww = iq)




