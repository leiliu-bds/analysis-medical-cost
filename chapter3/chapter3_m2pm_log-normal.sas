libname meps "C:\Users\xiaoyi.x\Box\MEPS";
%let data = meps_chapter3;

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
run;

***********************************************************;

* Set up estimate extract macro function;
%let a0=a0;
%let a1_hibp=a1_hibp;
%let a1_chd=a1_chd;
%let a1_strk=a1_strk;
%let a1_emph=a1_emph;
%let a1_chbron=a1_chbron;
%let a1_chol=a1_chol;
%let a1_cancer=a1_cancer;
%let a1_diab=a1_diab;
%let a1_jtpain=a1_jtpain;
%let a1_arth=a1_arth;
%let a1_asth=a1_asth;
%let a2=a2;
%let a3_hispanic=a3_hispanic;
%let a3_black=a3_black;
%let a3_other=a3_other;
%let a4_18=a4_18;
%let a4_25=a4_25;
%let a4_35=a4_35;
%let a4_45=a4_45;
%let a4_65=a4_65;
%let a4_75=a4_75;
%let a5_northeast=a5_northeast;
%let a5_midwest=a5_midwest;
%let a5_west=a5_west;

%let gamma0=gamma0;
%let gamma1_hibp=gamma1_hibp;
%let gamma1_chd=gamma1_chd;
%let gamma1_strk=gamma1_strk;
%let gamma1_emph=gamma1_emph;
%let gamma1_chbron=gamma1_chbron;
%let gamma1_chol=gamma1_chol;
%let gamma1_cancer=gamma1_cancer;
%let gamma1_diab=gamma1_diab;
%let gamma1_jtpain=gamma1_jtpain;
%let gamma1_arth=gamma1_arth;
%let gamma1_asth=gamma1_asth;
%let gamma2=gamma2;
%let gamma3_hispanic=gamma3_hispanic;
%let gamma3_black=gamma3_black;
%let gamma3_other=gamma3_other;
%let gamma4_18=gamma4_18;
%let gamma4_25=gamma4_25;
%let gamma4_35=gamma4_35;
%let gamma4_45=gamma4_45;
%let gamma4_65=gamma4_65;
%let gamma4_75=gamma4_75;
%let gamma5_northeast=gamma5_northeast;
%let gamma5_midwest=gamma5_midwest;
%let gamma5_west=gamma5_west;
%let gamma6=gamma6;

%let d0=d0;
%let d1_hibp=d1_hibp;
%let d1_chd=d1_chd;
%let d1_strk=d1_strk;
%let d1_emph=d1_emph;
%let d1_chbron=d1_chbron;
%let d1_chol=d1_chol;
%let d1_cancer=d1_cancer;
%let d1_diab=d1_diab;
%let d1_jtpain=d1_jtpain;
%let d1_arth=d1_arth;
%let d1_asth=d1_asth;
%let d2=d2;
%let d3_hispanic=d3_hispanic;
%let d3_black=d3_black;
%let d3_other=d3_other;
%let d4_18=d4_18;
%let d4_25=d4_25;
%let d4_35=d4_35;
%let d4_45=d4_45;
%let d4_65=d4_65;
%let d4_75=d4_75;
%let d5_northeast=d5_northeast;
%let d5_midwest=d5_midwest;
%let d5_west=d5_west;
%let d6=d6;

* Save the estimate in a macro variable;
%MACRO parameter (dataset,name);
    data  _null_;
        set &dataset.;
        if parameter="&name";
        call symput("&name", estimate);  
    run;
%MEND;

************************************************************;
************************************************************;

*1. Calculate incremental effect and partial elasticity;
title "Marginalized log-normal model with heteroscedasticity on cost data";
proc nlmixed data=&data;

	*Define initial values;
	parms a0=1.66 a1_hibp=0.79 a1_chd=0.60 a1_strk=0.20
  		  a1_emph=-0.19 a1_chbron=1.10 a1_chol=0.79 a1_cancer=0.97 
  	      a1_diab=1.27 a1_jtpain=0.53 a1_arth=0.59 a1_asth=0.63
  		  a2=-0.89 a3_hispanic=-1.07 a3_black=-0.76 a3_other=-0.61
  		  a4_18=-0.25 a4_25=-0.21 a4_35=-0.19
  		  a4_45=-0.10 a4_65=0.64 a4_75=0.65
  		  a5_northeast=0.39 a5_midwest=0.35 a5_west=0.30
  		  
  		  gamma0=-2.5 gamma1_hibp=1 gamma1_chd=1 gamma1_strk=1
  		  gamma1_emph=-1 gamma1_chbron=1 gamma1_chol=1 gamma1_cancer=1
  	      gamma1_diab=1 gamma1_jtpain=1 gamma1_arth=1 gamma1_asth=1
  		  gamma2=-1 gamma3_hispanic=-1 gamma3_black=-1 gamma3_other=-1
  		  gamma4_18=-1 gamma4_25=-1 gamma4_35=-1
  		  gamma4_45=-1 gamma4_65=1 gamma4_75=1
  		  gamma5_northeast=1 gamma5_midwest=1 gamma5_west=1
  		  gamma6=1

  		  
  		  d0=0.4460 d1_hibp=0.01878 d1_chd=-0.02124 d1_strk=0.2362
  		  d1_emph=-0.01572 d1_chbron=0.05398 d1_chol=-0.1998 d1_cancer=0.08764
  		  d1_diab=0.000333 d1_jtpain=0.04861 d1_arth=-0.08135 d1_asth=-0.1162		
  		  d2=0.1030 d3_hispanic=0.2740 d3_black=0.2409 d3_other=0.08627			
  		  d4_18=-0.00364 d4_25=0.04833 d4_35=0.08783	
  		  d4_45=0.1205 d4_65=-0.2556 d4_75=-0.1921	
  		  d5_northeast=0.02451 d5_midwest=-0.05134 d5_west=-0.04176	
  		  d6=-0.6133
  		  ;  	
	*log-likelihood;
  	teta = a0 + a1_hibp*HIBP + a1_chd*CHD + a1_strk*STRK + 
  		   a1_emph*EMPH + a1_chbron*CHBRON + a1_chol*CHOL + a1_cancer*CANCER + 
  		   a1_diab*DIAB + a1_jtpain*JTPAIN + a1_arth*ARTH + a1_asth*ASTH +
  		   a2*MALE + a3_hispanic*RACE_HISPANIC + a3_black*RACE_BLACK + a3_other*RACE_OTHER +
  		   a4_18*AGE_18_24 + a4_25*AGE_25_34 + a4_35*AGE_35_44 +
  		   a4_45*AGE_45_54 + a4_65*AGE_65_74 + a4_75*AGE_75_85 +
  		   a5_northeast*REGION_NORTHEAST + a5_midwest*REGION_MIDWEST + a5_west*REGION_WEST;

 	p = 1/(1+exp(-teta));
 	
	*for zero-cost;
 	if BTOTEXP17 = 0 then loglik = log(1-p);

	*for positive-cost;
 	if BTOTEXP17 = 1 then do;

		*Scale (heteroscedasticity) from traditional 2PM;
	 	sigma = exp((d0 + d1_hibp*HIBP + d1_chd*CHD + d1_strk*STRK + 
			  		   d1_emph*EMPH + d1_chbron*CHBRON + d1_chol*CHOL + d1_cancer*CANCER + 
			  		   d1_diab*DIAB + d1_jtpain*JTPAIN + d1_arth*ARTH + d1_asth*ASTH +
			  		   d2*MALE + d3_hispanic*RACE_HISPANIC + d3_black*RACE_BLACK + d3_other*RACE_OTHER +
			  		   d4_18*AGE_18_24 + d4_25*AGE_25_34 + d4_35*AGE_35_44 +
			  		   d4_45*AGE_45_54 + d4_65*AGE_65_74 + d4_75*AGE_75_85 +
			  		   d5_northeast*REGION_NORTHEAST + d5_midwest*REGION_MIDWEST + d5_west*REGION_WEST +
			  		   d6*IPDIS)/2);   		   	

		*Location from traditional 2PM;
	 	mu = gamma0 + gamma1_hibp*HIBP + gamma1_chd*CHD + gamma1_strk*STRK + 
	  		   gamma1_emph*EMPH + gamma1_chbron*CHBRON + gamma1_chol*CHOL + gamma1_cancer*CANCER + 
	  		   gamma1_diab*DIAB + gamma1_jtpain*JTPAIN + gamma1_arth*ARTH + gamma1_asth*ASTH +
	  		   gamma2*MALE + gamma3_hispanic*RACE_HISPANIC + gamma3_black*RACE_BLACK + gamma3_other*RACE_OTHER +
	  		   gamma4_18*AGE_18_24 + gamma4_25*AGE_25_34 + gamma4_35*AGE_35_44 +
	  		   gamma4_45*AGE_45_54 + gamma4_65*AGE_65_74 + gamma4_75*AGE_75_85 +
	  		   gamma5_northeast*REGION_NORTHEAST + gamma5_midwest*REGION_MIDWEST + gamma5_west*REGION_WEST+
	  		   gamma6*IPDIS - log(p)-sigma**2/2;
  		
   		loglik = log(p)-log(TOTEXP17)-.5*log(2*constant("pi"))-log(sigma)-(1/(2*sigma**2))*(log(TOTEXP17)-mu)**2;
 	end;

	*Fit the model above;
	model TOTEXP17~general(loglik);
	
	*Output parameters;
	ods output ParameterEstimates=m2pm_est; 
	
	*Marginal Effects;
 	estimate 'marginal effect-hibp' 	exp(gamma0+gamma1_hibp)-exp(gamma0);		
	estimate 'marginal effect-chd' 		exp(gamma0+gamma1_chd)-exp(gamma0);
	estimate 'marginal effect-strk' 	exp(gamma0+gamma1_strk)-exp(gamma0);	
	estimate 'marginal effect-emph' 	exp(gamma0+gamma1_emph)-exp(gamma0);	
	estimate 'marginal effect-chbron' 	exp(gamma0+gamma1_chbron)-exp(gamma0);	
	estimate 'marginal effect-chol' 	exp(gamma0+gamma1_chol)-exp(gamma0);	
	estimate 'marginal effect-cancer' 	exp(gamma0+gamma1_cancer)-exp(gamma0);	
	estimate 'marginal effect-diab' 	exp(gamma0+gamma1_diab)-exp(gamma0);	
	estimate 'marginal effect-jtpain' 	exp(gamma0+gamma1_jtpain)-exp(gamma0);	
	estimate 'marginal effect-arth' 	exp(gamma0+gamma1_arth)-exp(gamma0);	
	estimate 'marginal effect-asth' 	exp(gamma0+gamma1_asth)-exp(gamma0);	
	estimate 'marginal effect-male' 	exp(gamma0+gamma2)-exp(gamma0);	
	estimate 'marginal effect-hispanic' exp(gamma0+gamma3_hispanic)-exp(gamma0);	
	estimate 'marginal effect-black' 	exp(gamma0+gamma3_black)-exp(gamma0);	
	estimate 'marginal effect-other' 	exp(gamma0+gamma3_other)-exp(gamma0);	
	estimate 'marginal effect-AGE_18_24'exp(gamma0+gamma4_18)-exp(gamma0);	
	estimate 'marginal effect-AGE_25_34'exp(gamma0+gamma4_25)-exp(gamma0);	
	estimate 'marginal effect-AGE_35_44'exp(gamma0+gamma4_35)-exp(gamma0);	
	estimate 'marginal effect-AGE_45_54'exp(gamma0+gamma4_45)-exp(gamma0);	
	estimate 'marginal effect-AGE_65_74'exp(gamma0+gamma4_65)-exp(gamma0);	
	estimate 'marginal effect-AGE_75_85'exp(gamma0+gamma4_75)-exp(gamma0);	
	estimate 'marginal effect-NORTHEAST'exp(gamma0+gamma5_northeast)-exp(gamma0);	
	estimate 'marginal effect-MIDWEST'	exp(gamma0+gamma5_midwest)-exp(gamma0);	
	estimate 'marginal effect-WEST' 	exp(gamma0+gamma5_west)-exp(gamma0);		
	estimate 'marginal effect-IPDIS' 	exp(gamma0+gamma6)-exp(gamma0);		

	*Partial Elasticity;
	estimate 'partial elasticity-hibp' 		gamma1_hibp;		
	estimate 'partial elasticity-chd' 		gamma1_chd;
	estimate 'partial elasticity-strk' 		gamma1_strk;	
	estimate 'partial elasticity-emph' 		gamma1_emph;	
	estimate 'partial elasticity-chbron' 	gamma1_chbron;	
	estimate 'partial elasticity-chol' 		gamma1_chol;	
	estimate 'partial elasticity-cancer' 	gamma1_cancer;	
	estimate 'partial elasticity-diab' 		gamma1_diab;	
	estimate 'partial elasticity-jtpain' 	gamma1_jtpain;	
	estimate 'partial elasticity-arth' 		gamma1_arth;	
	estimate 'partial elasticity-asth' 		gamma1_asth;	
	estimate 'partial elasticity-male' 		gamma2;	
	estimate 'partial elasticity-hispanic' 	gamma3_hispanic;	
	estimate 'partial elasticity-black' 	gamma3_black;	
	estimate 'partial elasticity-other' 	gamma3_other;	
	estimate 'partial elasticity-AGE_18_24'	gamma4_18;	
	estimate 'partial elasticity-AGE_25_34'	gamma4_25;	
	estimate 'partial elasticity-AGE_35_44'	gamma4_35;	
	estimate 'partial elasticity-AGE_45_54'	gamma4_45;	
	estimate 'partial elasticity-AGE_65_74'	gamma4_65;	
	estimate 'partial elasticity-AGE_75_85'	gamma4_75;	
	estimate 'partial elasticity-NORTHEAST'	gamma5_northeast;	
	estimate 'partial elasticity-MIDWEST'	gamma5_midwest;	
	estimate 'partial elasticity-WEST' 		gamma5_west;		
	estimate 'partial elasticity-IPDIS' 	gamma6;		
run;

************************************************************;
************************************************************;

*2. Calculate residuals;
*2.A. Store the parameters;
%parameter(m2pm_est,a0);
%parameter(m2pm_est,a1_hibp);
%parameter(m2pm_est,a1_chd);
%parameter(m2pm_est,a1_strk);
%parameter(m2pm_est,a1_emph);
%parameter(m2pm_est,a1_chbron);
%parameter(m2pm_est,a1_chol);
%parameter(m2pm_est,a1_cancer);
%parameter(m2pm_est,a1_diab);
%parameter(m2pm_est,a1_jtpain);
%parameter(m2pm_est,a1_arth);
%parameter(m2pm_est,a1_asth);
%parameter(m2pm_est,a2);
%parameter(m2pm_est,a3_hispanic);
%parameter(m2pm_est,a3_black);
%parameter(m2pm_est,a3_other);
%parameter(m2pm_est,a4_18);
%parameter(m2pm_est,a4_25);
%parameter(m2pm_est,a4_35);
%parameter(m2pm_est,a4_45);
%parameter(m2pm_est,a4_65);
%parameter(m2pm_est,a4_75);
%parameter(m2pm_est,a5_northeast);
%parameter(m2pm_est,a5_midwest);
%parameter(m2pm_est,a5_west);

%parameter(m2pm_est,gamma0);
%parameter(m2pm_est,gamma1_hibp);
%parameter(m2pm_est,gamma1_chd);
%parameter(m2pm_est,gamma1_strk);
%parameter(m2pm_est,gamma1_emph);
%parameter(m2pm_est,gamma1_chbron);
%parameter(m2pm_est,gamma1_chol);
%parameter(m2pm_est,gamma1_cancer);
%parameter(m2pm_est,gamma1_diab);
%parameter(m2pm_est,gamma1_jtpain);
%parameter(m2pm_est,gamma1_arth);
%parameter(m2pm_est,gamma1_asth);
%parameter(m2pm_est,gamma2);
%parameter(m2pm_est,gamma3_hispanic);
%parameter(m2pm_est,gamma3_black);
%parameter(m2pm_est,gamma3_other);
%parameter(m2pm_est,gamma4_18);
%parameter(m2pm_est,gamma4_25);
%parameter(m2pm_est,gamma4_35);
%parameter(m2pm_est,gamma4_45);
%parameter(m2pm_est,gamma4_65);
%parameter(m2pm_est,gamma4_75);
%parameter(m2pm_est,gamma5_northeast);
%parameter(m2pm_est,gamma5_midwest);
%parameter(m2pm_est,gamma5_west);
%parameter(m2pm_est,gamma6);

%parameter(m2pm_est,d0);
%parameter(m2pm_est,d1_hibp);
%parameter(m2pm_est,d1_chd);
%parameter(m2pm_est,d1_strk);
%parameter(m2pm_est,d1_emph);
%parameter(m2pm_est,d1_chbron);
%parameter(m2pm_est,d1_chol);
%parameter(m2pm_est,d1_cancer);
%parameter(m2pm_est,d1_diab);
%parameter(m2pm_est,d1_jtpain);
%parameter(m2pm_est,d1_arth);
%parameter(m2pm_est,d1_asth);
%parameter(m2pm_est,d2);
%parameter(m2pm_est,d3_hispanic);
%parameter(m2pm_est,d3_black);
%parameter(m2pm_est,d3_other);
%parameter(m2pm_est,d4_18);
%parameter(m2pm_est,d4_25);
%parameter(m2pm_est,d4_35);
%parameter(m2pm_est,d4_45);
%parameter(m2pm_est,d4_65);
%parameter(m2pm_est,d4_75);
%parameter(m2pm_est,d5_northeast);
%parameter(m2pm_est,d5_midwest);
%parameter(m2pm_est,d5_west);
%parameter(m2pm_est,d6);

************************************************************;

*2.B. Make predictions using the fitted model;
data m2pm_pred;
    set &data;

 	teta = &a0 + &a1_hibp*HIBP + &a1_chd*CHD + &a1_strk*STRK + 
  		   &a1_emph*EMPH + &a1_chbron*CHBRON + &a1_chol*CHOL + &a1_cancer*CANCER + 
  		   &a1_diab*DIAB + &a1_jtpain*JTPAIN + &a1_arth*ARTH + &a1_asth*ASTH +
  		   &a2*MALE + &a3_hispanic*RACE_HISPANIC + &a3_black*RACE_BLACK + &a3_other*RACE_OTHER +
  		   &a4_18*AGE_18_24 + &a4_25*AGE_25_34 + &a4_35*AGE_35_44 +
  		   &a4_45*AGE_45_54 + &a4_65*AGE_65_74 + &a4_75*AGE_75_85 +
  		   &a5_northeast*REGION_NORTHEAST + &a5_midwest*REGION_MIDWEST + &a5_west*REGION_WEST;

  	expteta = exp(teta);
  	p = expteta / (1+expteta);

	sigma = exp((&d0 + &d1_hibp*HIBP + &d1_chd*CHD + &d1_strk*STRK + 
		&d1_emph*EMPH + &d1_chbron*CHBRON + &d1_chol*CHOL + &d1_cancer*CANCER + 
		&d1_diab*DIAB + &d1_jtpain*JTPAIN + &d1_arth*ARTH + &d1_asth*ASTH +
		&d2*MALE + &d3_hispanic*RACE_HISPANIC + &d3_black*RACE_BLACK + &d3_other*RACE_OTHER +
		&d4_18*AGE_18_24 + &d4_25*AGE_25_34 + &d4_35*AGE_35_44 +
		&d4_45*AGE_45_54 + &d4_65*AGE_65_74 + &d4_75*AGE_75_85 +
		&d5_northeast*REGION_NORTHEAST + &d5_midwest*REGION_MIDWEST + &d5_west*REGION_WEST +
		&d6*IPDIS)/2);

	*Location from traditional 2PM;
 	mu = &gamma0 + &gamma1_hibp*HIBP + &gamma1_chd*CHD + &gamma1_strk*STRK + 
  		   &gamma1_emph*EMPH + &gamma1_chbron*CHBRON + &gamma1_chol*CHOL + &gamma1_cancer*CANCER + 
  		   &gamma1_diab*DIAB + &gamma1_jtpain*JTPAIN + &gamma1_arth*ARTH + &gamma1_asth*ASTH +
  		   &gamma2*MALE + &gamma3_hispanic*RACE_HISPANIC + &gamma3_black*RACE_BLACK + &gamma3_other*RACE_OTHER +
  		   &gamma4_18*AGE_18_24 + &gamma4_25*AGE_25_34 + &gamma4_35*AGE_35_44 +
  		   &gamma4_45*AGE_45_54 + &gamma4_65*AGE_65_74 + &gamma4_75*AGE_75_85 +
  		   &gamma5_northeast*REGION_NORTHEAST + &gamma5_midwest*REGION_MIDWEST + &gamma5_west*REGION_WEST+
  		   &gamma6*IPDIS - log(p)-sigma**2/2;
	  		   
	E_y = exp(mu+sigma**2/2);
	pred = p*E_y;

	keep dupersid mu sigma pred TOTEXP17;
run;

************************************************************;

*2.C. Calculate residuals;
data m2pm_residual;
	set m2pm_pred;
	resid = TOTEXP17 - pred;
	abs = abs(resid);
run;

proc univariate data=m2pm_residual; 
	var resid abs ;
run;

/* Marginalized two-part model with log normal distribution results: 
   Mean residual: -464.3	
   Mean absolute residual: 5663.8*/

************************************************************;
************************************************************;

*3. cross-validation;
*3.A. split TOTEXP17 into 5 groups using quantile;
data cv;
	set &data;
	if TOTEXP17 = 0 then group =0;
		else if TOTEXP17<435.5 then group=1;
		else if TOTEXP17<1317 then group=2;
		else if TOTEXP17<3279.5 then group=3;		
		else if TOTEXP17<8727 then group=4;
		else group=5;		
run;

************************************************************;
	
*3.B Stratified sampling macro to split data into 5 folds by spending group;
%MACRO stratified_sampling(fold=, group=);
    proc surveyselect data=cv
                      out=shuffled
                      method=SRS  	/* Simple random sampling */
                      rate=1  		/* Sampling all recortrain (100%) */
                      seed=1234;  	/* Ensure reproducibility */
        where group = &group; 
    run;

    data &fold;
        set shuffled;
        fold = mod(_N_, 5) + 1;  	/* Assign fold folds 1 to 5 */
    run;

    proc sort data=&fold;
        by dupersid;
    run;
%MEND;

* Perform stratified sampling for each spending group;
%stratified_sampling(fold=fold_0, group=0);
%stratified_sampling(fold=fold_1, group=1);
%stratified_sampling(fold=fold_2, group=2);
%stratified_sampling(fold=fold_3, group=3);
%stratified_sampling(fold=fold_4, group=4);
%stratified_sampling(fold=fold_5, group=5);

* Combine the 5 folds into one dataset;
data cv_fold;
    merge fold_0 fold_1 fold_2 fold_3 fold_4 fold_5;
    by dupersid;
run;

************************************************************;

*3.C. Cross-validation process for Marginalized 2PM (5-fold validation);
%MACRO m2pm_model(fold,pred);
    data train;
        set cv_fold;
        where fold ne &fold.;
    run;
    
    data test;
        set cv_fold;
        where fold = &fold.; 
    run;

	title "Marginalized log-normal model with heteroscedasticity on cost data (training data excluding fold &fold.)";
	proc nlmixed data=train;

		*Define initial values;
		parms a0=1.66 a1_hibp=0.79 a1_chd=0.60 a1_strk=0.20
	  		  a1_emph=-0.19 a1_chbron=1.10 a1_chol=0.79 a1_cancer=0.97 
	  	      a1_diab=1.27 a1_jtpain=0.53 a1_arth=0.59 a1_asth=0.63
	  		  a2=-0.89 a3_hispanic=-1.07 a3_black=-0.76 a3_other=-0.61
	  		  a4_18=-0.25 a4_25=-0.21 a4_35=-0.19
	  		  a4_45=-0.10 a4_65=0.64 a4_75=0.65
	  		  a5_northeast=0.39 a5_midwest=0.35 a5_west=0.30
	  		  
	  		  gamma0=-2.5 gamma1_hibp=1 gamma1_chd=1 gamma1_strk=1
	  		  gamma1_emph=-1 gamma1_chbron=1 gamma1_chol=1 gamma1_cancer=1
	  	      gamma1_diab=1 gamma1_jtpain=1 gamma1_arth=1 gamma1_asth=1
	  		  gamma2=-1 gamma3_hispanic=-1 gamma3_black=-1 gamma3_other=-1
	  		  gamma4_18=-1 gamma4_25=-1 gamma4_35=-1
	  		  gamma4_45=-1 gamma4_65=1 gamma4_75=1
	  		  gamma5_northeast=1 gamma5_midwest=1 gamma5_west=1
	  		  gamma6=1

	  		  d0=0.4460 d1_hibp=0.01878 d1_chd=-0.02124 d1_strk=0.2362
	  		  d1_emph=-0.01572 d1_chbron=0.05398 d1_chol=-0.1998 d1_cancer=0.08764
	  		  d1_diab=0.000333 d1_jtpain=0.04861 d1_arth=-0.08135 d1_asth=-0.1162		
	  		  d2=0.1030 d3_hispanic=0.2740 d3_black=0.2409 d3_other=0.08627			
	  		  d4_18=-0.00364 d4_25=0.04833 d4_35=0.08783	
	  		  d4_45=0.1205 d4_65=-0.2556 d4_75=-0.1921	
	  		  d5_northeast=0.02451 d5_midwest=-0.05134 d5_west=-0.04176	
	  		  d6=-0.6133
	  		  ;
	  	
		*log-likelihood;
	  	teta = a0 + a1_hibp*HIBP + a1_chd*CHD + a1_strk*STRK + 
	  		   a1_emph*EMPH + a1_chbron*CHBRON + a1_chol*CHOL + a1_cancer*CANCER + 
	  		   a1_diab*DIAB + a1_jtpain*JTPAIN + a1_arth*ARTH + a1_asth*ASTH +
	  		   a2*MALE + a3_hispanic*RACE_HISPANIC + a3_black*RACE_BLACK + a3_other*RACE_OTHER +
	  		   a4_18*AGE_18_24 + a4_25*AGE_25_34 + a4_35*AGE_35_44 +
	  		   a4_45*AGE_45_54 + a4_65*AGE_65_74 + a4_75*AGE_75_85 +
	  		   a5_northeast*REGION_NORTHEAST + a5_midwest*REGION_MIDWEST + a5_west*REGION_WEST;

	  	expteta = exp(teta);
	  	p = expteta / (1+expteta);
	 	
		*for zero-cost;
	 	if BTOTEXP17 = 0 then loglik = log(1-p);

		*for positive-cost;
	 	if BTOTEXP17 = 1 then do;

			*Scale (heteroscedasticity) from traditional 2PM;
		 	sigma = exp((d0 + d1_hibp*HIBP + d1_chd*CHD + d1_strk*STRK + 
				  		   d1_emph*EMPH + d1_chbron*CHBRON + d1_chol*CHOL + d1_cancer*CANCER + 
				  		   d1_diab*DIAB + d1_jtpain*JTPAIN + d1_arth*ARTH + d1_asth*ASTH +
				  		   d2*MALE + d3_hispanic*RACE_HISPANIC + d3_black*RACE_BLACK + d3_other*RACE_OTHER +
				  		   d4_18*AGE_18_24 + d4_25*AGE_25_34 + d4_35*AGE_35_44 +
				  		   d4_45*AGE_45_54 + d4_65*AGE_65_74 + d4_75*AGE_75_85 +
				  		   d5_northeast*REGION_NORTHEAST + d5_midwest*REGION_MIDWEST + d5_west*REGION_WEST +
				  		   d6*IPDIS)/2);   		   	

			*Location from traditional 2PM;
		 	mu = gamma0 + gamma1_hibp*HIBP + gamma1_chd*CHD + gamma1_strk*STRK + 
		  		   gamma1_emph*EMPH + gamma1_chbron*CHBRON + gamma1_chol*CHOL + gamma1_cancer*CANCER + 
		  		   gamma1_diab*DIAB + gamma1_jtpain*JTPAIN + gamma1_arth*ARTH + gamma1_asth*ASTH +
		  		   gamma2*MALE + gamma3_hispanic*RACE_HISPANIC + gamma3_black*RACE_BLACK + gamma3_other*RACE_OTHER +
		  		   gamma4_18*AGE_18_24 + gamma4_25*AGE_25_34 + gamma4_35*AGE_35_44 +
		  		   gamma4_45*AGE_45_54 + gamma4_65*AGE_65_74 + gamma4_75*AGE_75_85 +
		  		   gamma5_northeast*REGION_NORTHEAST + gamma5_midwest*REGION_MIDWEST + gamma5_west*REGION_WEST+
		  		   gamma6*IPDIS - log(p)-sigma**2/2;
	  		
	   		loglik = log(p)-log(TOTEXP17)-.5*log(2*constant("pi"))-log(sigma)-(1/(2*sigma**2))*(log(TOTEXP17)-mu)**2;
	 	end;

		*Fit the model above;
		model TOTEXP17~general(loglik);
		
		*Output parameters;
		ods output ParameterEstimates=est_all;
	run; 

	*Store the parameters;
	%parameter(est_all,a0);
	%parameter(est_all,a1_hibp);
	%parameter(est_all,a1_chd);
	%parameter(est_all,a1_strk);
	%parameter(est_all,a1_emph);
	%parameter(est_all,a1_chbron);
	%parameter(est_all,a1_chol);
	%parameter(est_all,a1_cancer);
	%parameter(est_all,a1_diab);
	%parameter(est_all,a1_jtpain);
	%parameter(est_all,a1_arth);
	%parameter(est_all,a1_asth);
	%parameter(est_all,a2);
	%parameter(est_all,a3_hispanic);
	%parameter(est_all,a3_black);
	%parameter(est_all,a3_other);
	%parameter(est_all,a4_18);
	%parameter(est_all,a4_25);
	%parameter(est_all,a4_35);
	%parameter(est_all,a4_45);
	%parameter(est_all,a4_65);
	%parameter(est_all,a4_75);
	%parameter(est_all,a5_northeast);
	%parameter(est_all,a5_midwest);
	%parameter(est_all,a5_west);

	%parameter(est_all,gamma0);
	%parameter(est_all,gamma1_hibp);
	%parameter(est_all,gamma1_chd);
	%parameter(est_all,gamma1_strk);
	%parameter(est_all,gamma1_emph);
	%parameter(est_all,gamma1_chbron);
	%parameter(est_all,gamma1_chol);
	%parameter(est_all,gamma1_cancer);
	%parameter(est_all,gamma1_diab);
	%parameter(est_all,gamma1_jtpain);
	%parameter(est_all,gamma1_arth);
	%parameter(est_all,gamma1_asth);
	%parameter(est_all,gamma2);
	%parameter(est_all,gamma3_hispanic);
	%parameter(est_all,gamma3_black);
	%parameter(est_all,gamma3_other);
	%parameter(est_all,gamma4_18);
	%parameter(est_all,gamma4_25);
	%parameter(est_all,gamma4_35);
	%parameter(est_all,gamma4_45);
	%parameter(est_all,gamma4_65);
	%parameter(est_all,gamma4_75);
	%parameter(est_all,gamma5_northeast);
	%parameter(est_all,gamma5_midwest);
	%parameter(est_all,gamma5_west);
	%parameter(est_all,gamma6);

	%parameter(est_all,d0);
	%parameter(est_all,d1_hibp);
	%parameter(est_all,d1_chd);
	%parameter(est_all,d1_strk);
	%parameter(est_all,d1_emph);
	%parameter(est_all,d1_chbron);
	%parameter(est_all,d1_chol);
	%parameter(est_all,d1_cancer);
	%parameter(est_all,d1_diab);
	%parameter(est_all,d1_jtpain);
	%parameter(est_all,d1_arth);
	%parameter(est_all,d1_asth);
	%parameter(est_all,d2);
	%parameter(est_all,d3_hispanic);
	%parameter(est_all,d3_black);
	%parameter(est_all,d3_other);
	%parameter(est_all,d4_18);
	%parameter(est_all,d4_25);
	%parameter(est_all,d4_35);
	%parameter(est_all,d4_45);
	%parameter(est_all,d4_65);
	%parameter(est_all,d4_75);
	%parameter(est_all,d5_northeast);
	%parameter(est_all,d5_midwest);
	%parameter(est_all,d5_west);
	%parameter(est_all,d6);

	* Make predictions using the fitted model;
 	data pred_&fold.;
	    set test;

	 	teta = &a0 + &a1_hibp*HIBP + &a1_chd*CHD + &a1_strk*STRK + 
	  		   &a1_emph*EMPH + &a1_chbron*CHBRON + &a1_chol*CHOL + &a1_cancer*CANCER + 
	  		   &a1_diab*DIAB + &a1_jtpain*JTPAIN + &a1_arth*ARTH + &a1_asth*ASTH +
	  		   &a2*MALE + &a3_hispanic*RACE_HISPANIC + &a3_black*RACE_BLACK + &a3_other*RACE_OTHER +
	  		   &a4_18*AGE_18_24 + &a4_25*AGE_25_34 + &a4_35*AGE_35_44 +
	  		   &a4_45*AGE_45_54 + &a4_65*AGE_65_74 + &a4_75*AGE_75_85 +
	  		   &a5_northeast*REGION_NORTHEAST + &a5_midwest*REGION_MIDWEST + &a5_west*REGION_WEST;

	  	expteta = exp(teta);
	  	p = expteta / (1+expteta);

		sigma = exp((&d0 + &d1_hibp*HIBP + &d1_chd*CHD + &d1_strk*STRK + 
			&d1_emph*EMPH + &d1_chbron*CHBRON + &d1_chol*CHOL + &d1_cancer*CANCER + 
			&d1_diab*DIAB + &d1_jtpain*JTPAIN + &d1_arth*ARTH + &d1_asth*ASTH +
			&d2*MALE + &d3_hispanic*RACE_HISPANIC + &d3_black*RACE_BLACK + &d3_other*RACE_OTHER +
			&d4_18*AGE_18_24 + &d4_25*AGE_25_34 + &d4_35*AGE_35_44 +
			&d4_45*AGE_45_54 + &d4_65*AGE_65_74 + &d4_75*AGE_75_85 +
			&d5_northeast*REGION_NORTHEAST + &d5_midwest*REGION_MIDWEST + &d5_west*REGION_WEST +
			&d6*IPDIS)/2);

		*Location from traditional 2PM;
	 	mu = &gamma0 + &gamma1_hibp*HIBP + &gamma1_chd*CHD + &gamma1_strk*STRK + 
	  		   &gamma1_emph*EMPH + &gamma1_chbron*CHBRON + &gamma1_chol*CHOL + &gamma1_cancer*CANCER + 
	  		   &gamma1_diab*DIAB + &gamma1_jtpain*JTPAIN + &gamma1_arth*ARTH + &gamma1_asth*ASTH +
	  		   &gamma2*MALE + &gamma3_hispanic*RACE_HISPANIC + &gamma3_black*RACE_BLACK + &gamma3_other*RACE_OTHER +
	  		   &gamma4_18*AGE_18_24 + &gamma4_25*AGE_25_34 + &gamma4_35*AGE_35_44 +
	  		   &gamma4_45*AGE_45_54 + &gamma4_65*AGE_65_74 + &gamma4_75*AGE_75_85 +
	  		   &gamma5_northeast*REGION_NORTHEAST + &gamma5_midwest*REGION_MIDWEST + &gamma5_west*REGION_WEST+
	  		   &gamma6*IPDIS - log(p)-sigma**2/2;
		  		   
		E_y = exp(mu+sigma**2/2);
		pred = p*E_y;

		keep dupersid mu sigma pred TOTEXP17;
	run;
%MEND;

%m2pm_model(fold=1);
%m2pm_model(fold=2);
%m2pm_model(fold=3);
%m2pm_model(fold=4);
%m2pm_model(fold=5);

************************************************************;

*3.E. Calculate residuals for Cross-validation (5-fold validation);    
* Combine predictions from all folds;
data cv_pred;
    merge pred_1 pred_2 pred_3 pred_4 pred_5;
    by dupersid;
run;

* Calculate residuals and absolute residuals;
data cv_residual;
    set cv_pred;
    resid = TOTEXP17 - pred;
    absresid = abs(TOTEXP17 - pred);
run;

* Summary statistics of residuals and absolute residuals;
proc univariate data=cv_residual;
    var resid absresid;
run;

/* Marginalized two-part model with log normal distribution results: 
   Mean cross-validation residual: -465.3
   Mean cross-validation absolute residual: 5680.0*/
