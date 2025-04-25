libname meps "/.../MEPS"; 	/* Note: You can modify the "..." to specify the desired directory path for MEPS data */
%let data = meps_chapter4_positive;

data &data; 
	*Accesse for eligibility (N = 31,800);
	set meps.h201;										
	
	*Exclude respondents younger than 18 years old (N = 23,529);
	if AGE17X>= 18;										

	*Exclude respondens without valid values for health condition (N = 22,613);
	if HIBPDX<0 then delete; 						
	if CHDDX<0 then delete; 						
	if STRKDX<0 then delete; 						
	if EMPHDX<0 then delete; 						
	if CHBRON31<0 then delete; 					
	if CHOLDX<0 then delete; 						
	if CANCERDX<0 then delete; 					
	if DIABDX<0 then delete; 						
	if JTPAIN31<0 then delete; 				
	if ARTHDX<0 then delete; 						
	if ASTHDX<0 then delete; 						
	
	*Categorize age variable (reference group: age 55-64);
	if (AGE17X >= 18 and AGE17X < 25) then AGE_18_24 = 1; else AGE_18_24 = 0;
	if (AGE17X >= 25 and AGE17X < 35) then AGE_25_34 = 1; else AGE_25_34 = 0;
	if (AGE17X >= 35 and AGE17X < 45) then AGE_35_44 = 1; else AGE_35_44 = 0;
	if (AGE17X >= 45 and AGE17X < 55) then AGE_45_54 = 1; else AGE_45_54 = 0;
	if (AGE17X >= 55 and AGE17X < 65) then AGE_55_64 = 1; else AGE_55_64 = 0; 							
	if (AGE17X >= 65 and AGE17X < 75) then AGE_65_74 = 1; else AGE_65_74 = 0;
	if (AGE17X >= 75 and AGE17X <= 85) then AGE_75_85 = 1; else AGE_75_85 = 0;
	
	*Categorize sex variable (Sex: 1=MALE 2=FEMALE);
	if SEX=2 then MALE=0; else if SEX = 1 then MALE=1;						

	*Categorize race/ethnicity variable (reference group: RACE_WHITE);
	if RACETHX=1 then RACE_HISPANIC=1; else RACE_HISPANIC=0;	
	if RACETHX=2 then RACE_WHITE=1; else RACE_WHITE=0;								
	if RACETHX=3 then RACE_BLACK=1; else RACE_BLACK=0;
	if RACETHX=4 OR RACETHX=5 then RACE_OTHER=1; else RACE_OTHER=0; 

	*Categorize region variable (reference group: REGION_SOUTH);
    if REGION17=1 then REGION_NORTHEAST=1; else REGION_NORTHEAST=0;
	if REGION17=2 then REGION_MIDWEST=1; else REGION_MIDWEST=0;
	if REGION17=3 then REGION_SOUTH=1; else REGION_SOUTH=0; 							
	if REGION17=4 then REGION_WEST=1; else REGION_WEST=0;

	*Categorize health conditions variable;
	if HIBPDX=2 then HIBP=0; else if HIBPDX=1 then HIBP=1; 
	if CHDDX=2 then CHD=0; else if CHDDX=1 then CHD=1; 
	if STRKDX=2 then STRK=0; else if STRKDX=1 then STRK=1; 
	if EMPHDX=2 then EMPH=0; else if EMPHDX=1 then EMPH=1; 
	if CHBRON31=2 then CHBRON=0; else if CHBRON31=1 then CHBRON=1; 
	if CHOLDX=2 then CHOL=0; else if CHOLDX=1 then CHOL=1; 
	if CANCERDX=2 then CANCER=0; else if CANCERDX=1 then CANCER=1; 
	if DIABDX=2 then DIAB=0; else if DIABDX=1 then DIAB=1; 
	if JTPAIN31=2 then JTPAIN=0; else if JTPAIN31=1 then JTPAIN=1; 
	if ARTHDX=2 then ARTH=0; else if ARTHDX=1 then ARTH=1; 
	if ASTHDX=2 then ASTH=0; else if ASTHDX=1 then ASTH=1; 

	*Categorize hospitalization variable;
	if IPDIS17>=1 then IPDIS=1; else if IPDIS17=0 then IPDIS=0;				

	*Categorize total expense variable;
	if TOTEXP17>0 then BTOTEXP17 = 1; else if TOTEXP17=0 then BTOTEXP17 = 0;
	FAMID=put(duid, z5.)||trim(FAMIDYR);

	*build dataset for 1 random effect in part 2;
	if TOTEXP17 > 0;
run;

************************************************************;
************************************************************;

proc sort data=&data;
	by FAMID;
run;

*1. Calculate incremental effect and partial elasticity;
title "Generalized Gamma distribution on correlated positive-cost data";
proc nlmixed data=&data NOSORTSUB;

    *Define initial values;
    parms   b0=7.3845 b1_hibp=0.1571 b1_chd=0.2345 b1_strk=0.1651
            b1_emph=0.06160 b1_chbron=0.09503 b1_chol=0.2068 b1_cancer=0.3200
            b1_diab=0.5222 b1_jtpain=0.2649 b1_arth=0.2770 b1_asth=0.3114
            b2=-0.2285 b3_hispanic=-0.4518 b3_black=-0.3077 b3_other=-0.2349	
            b4_18=-0.5460 b4_25=-0.3766 b4_35=-0.2502	
            b4_45=-0.1679 b4_65=0.08630 b4_75=0.1320	
            b5_northeast=0.2786 b5_midwest=0.09156 b5_west=0.09873
            b6=2.0357
            
            d0=0.4460 d1_hibp=0.01878 d1_chd=-0.02124 d1_strk=0.2362
            d1_emph=-0.01572 d1_chbron=0.05398 d1_chol=-0.1998 d1_cancer=0.08764
            d1_diab=0.000333 d1_jtpain=0.04861 d1_arth=-0.08135 d1_asth=-0.1162		
            d2=0.1030 d3_hispanic=0.2740 d3_black=0.2409 d3_other=0.08627			
            d4_18=-0.00364 d4_25=0.04833 d4_35=0.08783	
            d4_45=0.1205 d4_65=-0.2556 d4_75=-0.1921	
            d5_northeast=0.02451 d5_midwest=-0.05134 d5_west=-0.04176	
            d6=-0.6133		
            
            k=0.2834  var2=0.2186 ;
  		  
  	bounds var2 >=0;
  	
  	*Location;
  	mu =  random_effect2 + 
	  		   b0 + b1_hibp*HIBP + b1_chd*CHD + b1_strk*STRK + 
	  		   b1_emph*EMPH + b1_chbron*CHBRON + b1_chol*CHOL + b1_cancer*CANCER + 
	  		   b1_diab*DIAB + b1_jtpain*JTPAIN + b1_arth*ARTH + b1_asth*ASTH +
	  		   b2*MALE + b3_hispanic*RACE_HISPANIC + b3_black*RACE_BLACK + b3_other*RACE_OTHER +
	  		   b4_18*AGE_18_24 + b4_25*AGE_25_34 + b4_35*AGE_35_44 +
	  		   b4_45*AGE_45_54 + b4_65*AGE_65_74 + b4_75*AGE_75_85 +
	  		   b5_northeast*REGION_NORTHEAST + b5_midwest*REGION_MIDWEST + b5_west*REGION_WEST +
	  		   b6*IPDIS;  

    *Scale (heteroscedasticity);	 
    sigma = exp((d0 + d1_hibp*HIBP + d1_chd*CHD + d1_strk*STRK + 
		  		   d1_emph*EMPH + d1_chbron*CHBRON + d1_chol*CHOL + d1_cancer*CANCER + 
		  		   d1_diab*DIAB + d1_jtpain*JTPAIN + d1_arth*ARTH + d1_asth*ASTH +
		  		   d2*MALE + d3_hispanic*RACE_HISPANIC + d3_black*RACE_BLACK + d3_other*RACE_OTHER +
		  		   d4_18*AGE_18_24 + d4_25*AGE_25_34 + d4_35*AGE_35_44 +
		  		   d4_45*AGE_45_54 + d4_65*AGE_65_74 + d4_75*AGE_75_85 +
		  		   d5_northeast*REGION_NORTHEAST + d5_midwest*REGION_MIDWEST + d5_west*REGION_WEST +
		  		   d6*IPDIS)/2);	
  	
    eta = abs(k)**(-2);
    u = sign(k)*(log(TOTEXP17)-mu)/sigma;
    value1 = (eta-0.5)*log(eta) - log(sigma) - lgamma(eta) - log(TOTEXP17);
    loglik = value1 + u*sqrt(eta) - eta*exp(abs(k)*u);
	
  	*Expected Value;
  	E_y=exp(mu+sigma*log(k**2)/k+log(gamma(1/(k**2)+sigma/k))-log(gamma(1/(k**2))));
  
  	*Fit the model above;
  	model TOTEXP17~general(loglik);
  
  	*Define random effects;
  	random random_effect2 ~ normal(0,var2) subject=FAMID; 
  	
  	*Output parameters;
  	predict E_y out=gamma;
run;

************************************************************;
************************************************************;

*2. Calculate residuals;
data gamma_residual;
	set gamma;
	resid = TOTEXP17-pred;						
	abs = abs(resid);							
run;

proc univariate data=gamma_residual;
	var resid abs;
run;

/* Random Effect Generalized Gamma Model results: 
   Mean residual: 249.1		
   Mean absolute residual: 5449.7		 */
