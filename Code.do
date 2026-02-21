xtset id year

* Requires user-written commands: reghdfe, winsor2, xtivreg2, xtabond2, xthreg, sgmediation2, pwcorr_a, asdoc, center, matplot

*-Remove outliers
winsor2 CEBO Aging Urb Den Ope lnGDP Cl IV1 IV2,replace cuts(1 99)

************Table 1*****************

tabstat CEBO Aging Urb Den Ope lnGDP Cl,s(N mean sd min max) f(%12.3f) c(s) 


************Table 2*****************

reg CEBO Aging Urb Den Ope lnGDP Cl, r
reghdfe CEBO Aging Urb Den Ope lnGDP Cl,absorb(id ) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl,absorb(year) vce(r)

reghdfe CEBO Aging Urb Den Ope lnGDP Cl,absorb(year id) vce(r)

reghdfe CEBO l.Aging Urb Den Ope lnGDP Cl,absorb(year id) vce(r)
reghdfe CEBO l.Aging l.Urb l.Den l.Ope l.lnGDP l.Cl,absorb(year id) vce(r)

foreach v of varlist CEBO Aging Urb Den Ope lnGDP Cl {
    egen z_`v' = std(`v')
}
reghdfe z_CEBO z_Aging z_Urb z_Den z_Ope z_lnGDP z_Cl, absorb(year id) vce(r)


*************Table 3****************
 
xi: xtivreg2 CEBO Aging Urb Den Ope lnGDP Cl i.year (Aging=IV1),fe r gmm first small
xi: xtivreg2 CEBO Aging Urb Den Ope lnGDP Cl i.year (Aging=IV2),fe r gmm first small


*************Table 4****************

reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Income_Group == 0,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Income_Group == 1,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Income_Group == 2,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Income_Group == 3,absorb(year id) vce(r)


*************Table 5****************

reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Location_Group == 4,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Location_Group ==5,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Location_Group == 6,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Location_Group == 7,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Location_Group == 8,absorb(year id) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl if Location_Group == 9,absorb(year id) vce(r)


*************Table 6 and Table 7****************

set seed 123
xthreg CEBO Aging Urb Den Ope lnGDP Cl rx(Aging) qx(Aging) thnum(1) grid(300) bs(300) trim (0.01) 

_matplot e(LR),yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("First Threshold") recast(line) name(TU1)


*************Table 8****************

gen TAU = Aging*Urb     
gen TAD = Aging*Den     
gen TAO = Aging*Ope     

reghdfe CEBO Aging Urb Den Ope lnGDP Cl TAU,absorb(year id ) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl TAD,absorb(year id ) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl TAO,absorb(year id ) vce(r)

center Aging Urb Den Ope 
gen TAU_c = c_Aging*c_Urb     
gen TAD_c = c_Aging*c_Den    
gen TAO_c = c_Aging*c_Ope    

reghdfe CEBO Aging Urb Den Ope lnGDP Cl TAU_c,absorb(year id ) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl TAD_c,absorb(year id ) vce(r)
reghdfe CEBO Aging Urb Den Ope lnGDP Cl TAO_c,absorb(year id ) vce(r)


*************Table 9****************

reghdfe Cl Aging Urb Den Ope lnGDP,absorb(year id ) vce(r)
reghdfe CEBO Aging Cl Urb Den Ope lnGDP,absorb(year id ) vce(r)

reghdfe Cl l.Aging Urb Den Ope lnGDP,absorb(year id ) vce(r)
reghdfe CEBO l.Aging Cl Urb Den Ope lnGDP,absorb(year id ) vce(r)

sgmediation2 CEBO ,mv( Cl ) iv( Aging ) cv(Urb Den Ope lnGDP)

bootstrap  r(ind_eff) r(dir_eff),reps(1000) : sgmediation2 CEBO ,mv( Cl ) iv( Aging ) cv(Urb Den Ope lnGDP)

asdoc estat bootstrap, percentile bc


*************TableS1****************

pwcorr_a CEBO Aging Urb Den Ope lnGDP Cl, star1(0.01) star5(0.05) star10(0.1)


*************TableS2****************

reg  CEBO Aging Urb Den Ope lnGDP Cl
estat vif


*************TableS3****************

gen IV1_L10 = L10.IV1
gen IV1_L20 = L20.IV1
gen IV2_L10 = L10.IV2
gen IV2_L20 = L20.IV2


xi: xtivreg2 CEBO Urb Den Ope lnGDP Cl i.year (Aging=IV1_L10),fe r gmm first small
xi: xtivreg2 CEBO Urb Den Ope lnGDP Cl i.year (Aging=IV1_L20),fe r gmm first small
xi: xtivreg2 CEBO Urb Den Ope lnGDP Cl i.year (Aging=IV2_L10),fe r gmm first small
xi: xtivreg2 CEBO Urb Den Ope lnGDP Cl i.year (Aging=IV2_L20),fe r gmm first small


*************TableS6****************

reghdfe Cl Aging Urb Den Ope lnGDP if Income_Group == 0,absorb(year id ) vce(r)
reghdfe CEBO Aging Cl Urb Den Ope lnGDP if Income_Group == 0,absorb(year id ) vce(r)
reghdfe Cl Aging Urb Den Ope lnGDP if Income_Group == 1,absorb(year id ) vce(r)
reghdfe CEBO Aging Cl Urb Den Ope lnGDP if Income_Group == 1,absorb(year id ) vce(r)
reghdfe Cl Aging Urb Den Ope lnGDP if Income_Group == 2,absorb(year id ) vce(r)
reghdfe CEBO Aging Cl Urb Den Ope lnGDP if Income_Group == 2,absorb(year id ) vce(r)
reghdfe Cl Aging Urb Den Ope lnGDP if Income_Group == 3,absorb(year id ) vce(r)
reghdfe CEBO Aging Cl Urb Den Ope lnGDP if Income_Group == 3,absorb(year id ) vce(r)
