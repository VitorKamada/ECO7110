

**************************************
*** Taking Design Effects into account
**************************************

clear all
set more off
set scheme sj
set linesize 79



*** Setup

use http://www.stata-press.com/data/heus/heus_mepssample

egen clusterid=group(varpsu varstr)
codebook clusterid
list wtdper varstr varpsu clusterid race_bl eth_hisp in 4/11 

svyset [pweight=wtdper], strata(varstr) psu(varpsu)




*** Weighted sample means
generate race_bl_pct = race_bl*100
quietly mean exp_tot race_bl_pct
estimates store noadjust
quietly mean exp_tot race_bl_pct, vce(cluster clusterid)
estimates store cluster
quietly mean exp_tot race_bl_pct [pw=wtdper]
estimates store weights
quietly mean exp_tot race_bl_pct [pw=wtdper], vce(cluster clusterid)
estimates store clust_wgt
quietly svy: mean exp_tot race_bl_pct
estimates store survey
estimates table *, b(%7.1f) modelwidth(9) ///
	title(Alternative cluster and weight options: Sample means)

estimates drop *

*** Sample mean and simple t tests
mean exp_tot, over(race_bl)
test [exp_tot]_subpop_1 = [exp_tot]_subpop_2

*** Sample mean and simple t tests incorporating survey features
svy: mean exp_tot, over(race_bl)
test [exp_tot]_subpop_1 = [exp_tot]_subpop_2


*** Linear regression
quietly regress exp_tot age i.female i.race_bl i.reg_south, vce(robust)
estimates store robust
quietly regress exp_tot age i.female i.race_bl i.reg_south, ///
	vce(cluster clusterid)
estimates store cluster
quietly regress exp_tot age i.female i.race_bl i.reg_south [pw=wtdper]
estimates store weights
quietly regress exp_tot age i.female i.race_bl i.reg_south [pw=wtdper], ///
	vce(cluster clusterid)
estimates store clust_wgt
quietly svy: regress exp_tot age i.female i.race_bl i.reg_south
estimates store survey
estimates table *, b(%7.2f) se(%7.2f) p(%7.4f) modelwidth(9) drop(_cons) ///
	title(Alternative cluster and weight options: Linear regression estimates)


*** Poisson
quietly poisson use_off age i.female i.race_bl i.reg_south, vce(robust)
quietly margins, dydx(*) post
estimates store robust
quietly poisson use_off age i.female i.race_bl i.reg_south, ///
	vce(cluster clusterid)
quietly margins, dydx(*) post
estimates store cluster
quietly poisson use_off age i.female i.race_bl i.reg_south [pw=wtdper]
quietly margins, dydx(*) post
estimates store weights
quietly poisson use_off age i.female i.race_bl i.reg_south [pw=wtdper], ///
	vce(cluster clusterid)
quietly margins, dydx(*) post
estimates store clust_wgt
quietly svy: poisson use_off age i.female i.race_bl i.reg_south
quietly margins, dydx(*) post
estimates store survey
estimates table *, b(%7.4f) se(%7.4f) p(%7.4f) modelwidth(9) ///
	title(Alternative cluster and weight options: Poisson effects)

exit





*** 
use http://www.stata-press.com/data/r15/nhanes2f, clear
svyset psuid [pweight=finalwgt], strata(stratid)

sum finalwgt stratid psuid

logistic highbp height weight age female black

svy: logistic highbp height weight age female black 

svy, subpop(female): logistic highbp height weight age black











