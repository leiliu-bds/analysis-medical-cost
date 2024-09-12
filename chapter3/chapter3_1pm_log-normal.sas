libname meps "/.../MEPS"; 	/* Note: You can modify the "..." to specify the desired directory path for MEPS data */
%let data = meps_chapter3_1pm;

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
	
	*1-Part Model for chapter 3: taking log(cost+1) as outcome;
	TOTEXP = TOTEXP17 + 1;
	LOGTOTEXP = log(TOTEXP);
run;

************************************************************;

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

%let b0=b0;
%let b1_hibp=b1_hibp;
%let b1_chd=b1_chd;
%let b1_strk=b1_strk;
%let b1_emph=b1_emph;
%let b1_chbron=b1_chbron;
%let b1_chol=b1_chol;
%let b1_cancer=b1_cancer;
%let b1_diab=b1_diab;
%let b1_jtpain=b1_jtpain;
%let b1_arth=b1_arth;
%let b1_asth=b1_asth;
%let b2=b2;
%let b3_hispanic=b3_hispanic;
%let b3_black=b3_black;
%let b3_other=b3_other;
%let b4_18=b4_18;
%let b4_25=b4_25;
%let b4_35=b4_35;
%let b4_45=b4_45;
%let b4_65=b4_65;
%let b4_75=b4_75;
%let b5_northeast=b5_northeast;
%let b5_midwest=b5_midwest;
%let b5_west=b5_west;
%let b6=b6;

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

*1. Calculate marginal effect and partial elasticity;
title "Log-normal distribution on cost data (1-Part Model)";
proc nlmixed data=&data;

	*Define initial values;
  	parms 	b0=6.8363 b1_hibp=0.1513 b1_chd=0.2744 b1_strk=0.1867
  			b1_emph=0.1004 b1_chbron=0.1105 b1_chol=0.2377 b1_cancer=0.3390
  			b1_diab=0.5711 b1_jtpain=0.2797 b1_arth=0.3185 b1_asth=0.3551
  		  	b2=-0.2548 b3_hispanic=0 b3_black=0 b3_other=0
  		  	b4_18=-0.5406 b4_25=-0.3740 b4_35=-0.2605
  		  	b4_45=-0.1793 b4_65=0.1090 b4_75=0.1696
  		  	b5_northeast=0.2711 b5_midwest=0.1101 b5_west=0.1129
  		  	b6=2.1109
  		  	
  		  	d0=0 d1_hibp=0 d1_chd=0 d1_strk=0
  			d1_emph=0 d1_chbron=0 d1_chol=0 d1_cancer=0
  			d1_diab=0 d1_jtpain=0 d1_arth=0 d1_asth=0
  		  	d2=0 d3_hispanic=1 d3_black=0 d3_other=0
  		  	d4_18=0 d4_25=0 d4_35=0	
  		  	d4_45=0	d4_65=0 d4_75=0
  		  	d5_northeast=0 d5_midwest=0 d5_west=0
  		  	d6=0;
  		  	
  	 *Location;
	 mu =  b0 + b1_hibp*HIBP + b1_chd*CHD + b1_strk*STRK + 
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
		  		   
	z = (LOGTOTEXP - mu) / sigma;
    	pdf_normal = pdf('normal', z);
    	loglik=log((pdf_normal/(sigma*TOTEXP)));
    
    	*Expected Value;
    	E_y=exp(mu + sigma**2/2);
	
	*Fit the model above;
	model TOTEXP~general(loglik);

	*Output expected value;
	predict E_y out=lognormal;
run;

************************************************************;
************************************************************;

*2. Calculate residuals;
data lognormal_residual;
	set lognormal;
	resid = TOTEXP17-pred;						
	abs = abs(resid);							
run;

proc univariate data=lognormal_residual;
	var resid abs;
run;

/* Log Normal Model (1-Part model) results : 
   Mean residual: -25610	
   Mean absolute residual: 28813 */
