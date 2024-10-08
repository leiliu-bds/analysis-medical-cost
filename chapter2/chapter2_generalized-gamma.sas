libname meps "/.../MEPS"; 	/* Note: You can modify the "..." to specify the desired directory path for MEPS data */
%let data = meps_chapter2;

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

	*Subset for chapter 2;
	if TOTEXP17>0;					
	LOGTOTEXP17 = log(TOTEXP17);
run;

************************************************************;

* Set up a macro function to extract parameters;
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
%let k=k;

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
title "Generalized Gamma distribution on positive-cost data";
proc nlmixed data=&data;

	*Define initial values;
	 parms 	b0=6.8363 b1_hibp=0.1513 b1_chd=0.2744 b1_strk=0.1867
	  	b1_emph=0.1004 b1_chbron=0.1105 b1_chol=0.2377 b1_cancer=0.3390
		b1_diab=0.5711 b1_jtpain=0.2797 b1_arth=0.3185 b1_asth=0.3551
	  	b2=-0.2548 b3_hispanic=-0.1698  b3_black=0 b3_other=0	
	  	b4_18=-0.5406 b4_25=-0.3740 b4_35=-0.2605
	  	b4_45=-0.1793	b4_65=0.1090 b4_75=0.1696
	  	b5_northeast=0.2711 b5_midwest=0.1101 b5_west=0.1129
	    	b6=2.1109
	  		  	
	  	d0=0 d1_hibp=0 d1_chd=0 d1_strk=0
	  	d1_emph=0 d1_chbron=0 d1_chol=0 d1_cancer=0
	  	d1_diab=0 d1_jtpain=0 d1_arth=0 d1_asth=0
	  	d2=0  d3_hispanic=0 d3_black=0 d3_other=0	
	  	d4_18=0 d4_25=0 d4_35=0	
	  	d4_45=0	d4_65=0 d4_75=0
	  	d5_northeast=0 d5_midwest=0 d5_west=0
	  	d6=0
	  	
		k=0.09;

	*Location;
 	mu =   b0 + b1_hibp*HIBP + b1_chd*CHD + b1_strk*STRK + 
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
	loglik =  + value1 + u*sqrt(eta) - eta*exp(abs(k)*u);
	
	*Expected Value;
	E_y=exp(mu+sigma*log(k**2)/k+log(gamma( 1/(k**2)+sigma/k))-log(gamma(1/(k**2))));

	*Fit the model above;
	model TOTEXP17~general(loglik);

	*Output expected value;
	predict E_y out=gamma;
	
	*Marginal Effects;
	estimate "marginal effect-HIBP" 	exp(b0+b1_hibp+exp((d0+d1_hibp)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_hibp)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-CHD" 		exp(b0+b1_chd+exp((d0+d1_chd)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_chd)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-STRK" 	exp(b0+b1_strk+exp((d0+d1_strk)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_strk)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-EMPH" 	exp(b0+b1_emph+exp((d0+d1_emph)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_emph)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-CHBRON" 	exp(b0+b1_chbron+exp((d0+d1_chbron)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_chbron)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-CHOL" 	exp(b0+b1_chol+exp((d0+d1_chol)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_chol)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-CANCER" 	exp(b0+b1_cancer+exp((d0+d1_cancer)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_cancer)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-DIAB" 	exp(b0+b1_diab+exp((d0+d1_diab)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_diab)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-JTPAIN" 	exp(b0+b1_jtpain+exp((d0+d1_jtpain)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_jtpain)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-ARTH" 	exp(b0+b1_arth+exp((d0+d1_arth)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_arth)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-ASTH" 	exp(b0+b1_asth+exp((d0+d1_asth)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_asth)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-MALE" 	exp(b0+b2+exp((d0+d2)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d2)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	
	estimate "marginal effect-HISPANIC" 	exp(b0+b3_hispanic+exp((d0+d3_hispanic)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d3_hispanic)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-BLACK" 	exp(b0+b3_black+exp((d0+d3_black)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d3_black)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-OTHER" 	exp(b0+b3_other+exp((d0+d3_other)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d3_other)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-AGE_18_24" 	exp(b0+b4_18+exp((d0+d4_18)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_18)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-AGE_25_34" 	exp(b0+b4_25+exp((d0+d4_25)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_25)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-AGE_35_44" 	exp(b0+b4_35+exp((d0+d4_35)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_35)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-AGE_45_54" 	exp(b0+b4_45+exp((d0+d4_45)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_45)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-AGE_65_74" 	exp(b0+b4_65+exp((d0+d4_65)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_65)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-AGE_75_85" 	exp(b0+b4_75+exp((d0+d4_75)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_75)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-NORTHEAST" 	exp(b0+b5_northeast+exp((d0+d5_northeast)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d5_northeast)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-MIDWEST" 	exp(b0+b5_midwest+exp((d0+d5_midwest)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d5_midwest)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-WEST" 	exp(b0+b5_west+exp((d0+d5_west)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d5_west)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate "marginal effect-IPDIS"	exp(b0+b6+exp((d0+d6)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d6)/2)/k))-log(gamma(1/(k**2))))-exp(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));

	*Partial Elasticity;
	estimate 'partial elasticity-HIBP' 	(b0+b1_hibp+exp((d0+d1_hibp)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_hibp)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-CHD' 	(b0+b1_chd+exp((d0+d1_chd)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_chd)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-STRK' 	(b0+b1_strk+exp((d0+d1_strk)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_strk)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-EMPH' 	(b0+b1_emph+exp((d0+d1_emph)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_emph)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-CHBRON' 	(b0+b1_chbron+exp((d0+d1_chbron)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_chbron)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-CHOL' 	(b0+b1_chol+exp((d0+d1_chol)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_chol)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-CANCER' 	(b0+b1_cancer+exp((d0+d1_cancer)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_cancer)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-DIAB' 	(b0+b1_diab+exp((d0+d1_diab)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_diab)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-JTPAIN' 	(b0+b1_jtpain+exp((d0+d1_jtpain)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_jtpain)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-ARTH' 	(b0+b1_arth+exp((d0+d1_arth)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_arth)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-ASTH' 	(b0+b1_asth+exp((d0+d1_asth)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d1_asth)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-MALE' 	(b0+b2+exp((d0+d2)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d2)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	
	estimate 'partial elasticity-HISPANIC' 	(b0+b3_hispanic+exp((d0+d3_hispanic)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d3_hispanic)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-BLACK' 	(b0+b3_black+exp((d0+d3_black)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d3_black)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-OTHER' 	(b0+b3_other+exp((d0+d3_other)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d3_other)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-AGE_18_24' (b0+b4_18+exp((d0+d4_18)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_18)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-AGE_25_34' (b0+b4_25+exp((d0+d4_25)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_25)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-AGE_35_44' (b0+b4_35+exp((d0+d4_35)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_35)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-AGE_45_54' (b0+b4_45+exp((d0+d4_45)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_45)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-AGE_65_74' (b0+b4_65+exp((d0+d4_65)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_65)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-AGE_75_85' (b0+b4_75+exp((d0+d4_75)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d4_75)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-NORTHEAST' (b0+b5_northeast+exp((d0+d5_northeast)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d5_northeast)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-MIDWEST' 	(b0+b5_midwest+exp((d0+d5_midwest)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d5_midwest)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-WEST' 	(b0+b5_west+exp((d0+d5_west)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d5_west)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	estimate 'partial elasticity-IPDIS' 	(b0+b6+exp((d0+d6)/2)*log(k**2)/k+log(gamma(1/(k**2)+exp((d0+d6)/2)/k))-log(gamma(1/(k**2))))-(b0+exp(d0/2)*log(k**2)/k+log(gamma(1/(k**2)+exp(d0/2)/k))-log(gamma(1/(k**2))));
	
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

/* Generalized Gamma Model results: 
   Mean residual: -524			
   Mean absolute residual: 6676		*/

************************************************************;
************************************************************;

*3. cross-validation;
*3.A. split TOTEXP17 into 5 groups using quantile;
data cv;
	set &data;
	if TOTEXP17<435.5 then group=1;
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
%stratified_sampling(fold=fold_1, group=1);
%stratified_sampling(fold=fold_2, group=2);
%stratified_sampling(fold=fold_3, group=3);
%stratified_sampling(fold=fold_4, group=4);
%stratified_sampling(fold=fold_5, group=5);

* Combine the 5 folds into one dataset;
data cv_fold;
    merge fold_1 fold_2 fold_3 fold_4 fold_5;
    by dupersid;
run;

************************************************************;

*3.C. Cross-validation process for Generalized Gamma Model (5-fold validation);
%MACRO gamma_model(fold,pred);
    data train;
        set cv_fold;
        where fold ne &fold.;
    run;
    
    data test;
        set cv_fold;
        where fold = &fold.; 
    run;
    
    title "Generalized Gamma distribution on positive-cost data (training data excluding fold &fold.)";
    proc nlmixed data=train;

		*Define initial values;
		parms 	b0=6.8363 b1_hibp=0.1513 b1_chd=0.2744 b1_strk=0.1867
				b1_emph=0.1004 b1_chbron=0.1105 b1_chol=0.2377 b1_cancer=0.3390
				b1_diab=0.5711 b1_jtpain=0.2797 b1_arth=0.3185 b1_asth=0.3551
				b2=-0.2548	 b3_hispanic=-0.1698  b3_black=0 b3_other=0	
				b4_18=-0.5406 b4_25=-0.3740 b4_35=-0.2605
				b4_45=-0.1793	b4_65=0.1090 b4_75=0.1696
				b5_northeast=0.2711 b5_midwest=0.1101	 b5_west=0.1129
				b6=2.1109
				
				d0=0 d1_hibp=0 d1_chd=0 d1_strk=0
				d1_emph=0	d1_chbron=0 d1_chol=0 d1_cancer=0
				d1_diab=0 d1_jtpain=0 d1_arth=0 d1_asth=0
				d2=0  d3_hispanic=0 d3_black=0 d3_other=0	
				d4_18=0 d4_25=0 d4_35=0	
				d4_45=0	d4_65=0 d4_75=0
				d5_northeast=0 d5_midwest=0 d5_west=0
				d6=0
	
				k=0.09;

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
		
		eta = abs(k)**(-2);
		u = sign(k)*(log(TOTEXP17)-mu)/sigma;
		value1 = (eta-0.5)*log(eta) - log(sigma) - log(TOTEXP17) - lgamma(eta);
		loglik = value1 + u*sqrt(eta) - eta*exp(abs(k)*u);
	
		*Fit the model above;
		model TOTEXP17~general(loglik);
		
		*Output parameters;
		ods output ParameterEstimates=est_all; 
  run;
	
	*Store the parameters;
 	%parameter(est_all,b0);
	%parameter(est_all,b1_hibp);
	%parameter(est_all,b1_chd);
	%parameter(est_all,b1_strk);
	%parameter(est_all,b1_emph);
	%parameter(est_all,b1_chbron);
	%parameter(est_all,b1_chol);
	%parameter(est_all,b1_cancer);
	%parameter(est_all,b1_diab);
	%parameter(est_all,b1_jtpain);
	%parameter(est_all,b1_arth);
	%parameter(est_all,b1_asth);
	%parameter(est_all,b2);
	%parameter(est_all,b3_hispanic);
	%parameter(est_all,b3_black);
	%parameter(est_all,b3_other);
	%parameter(est_all,b4_18);
	%parameter(est_all,b4_25);
	%parameter(est_all,b4_35);
	%parameter(est_all,b4_45);
	%parameter(est_all,b4_65);
	%parameter(est_all,b4_75);
	%parameter(est_all,b5_northeast);
	%parameter(est_all,b5_midwest);
	%parameter(est_all,b5_west);
	%parameter(est_all,b6);

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
	%parameter(est_all,k);
	
    	* Make predictions using the fitted model;
    	data pred_&fold.;
        	set test;

		mu = &b0+&b1_hibp*HIBP+&b1_chd*CHD+&b1_strk*STRK + 
		  	&b1_emph*EMPH + &b1_chbron*CHBRON + &b1_chol*CHOL + &b1_cancer*CANCER + 
		  	&b1_diab*DIAB + &b1_jtpain*JTPAIN + &b1_arth*ARTH + &b1_asth*ASTH +
		  	&b2*MALE + &b3_hispanic*RACE_HISPANIC + &b3_black*RACE_BLACK + &b3_other*RACE_OTHER +
		  	&b4_18*AGE_18_24 + &b4_25*AGE_25_34 + &b4_35*AGE_35_44 +
		  	&b4_45*AGE_45_54 + &b4_65*AGE_65_74 + &b4_75*AGE_75_85 +
		  	&b5_northeast*REGION_NORTHEAST + &b5_midwest*REGION_MIDWEST + &b5_west*REGION_WEST +
		  	&b6*IPDIS;

		sigma = exp((&d0 + &d1_hibp*HIBP + &d1_chd*CHD + &d1_strk*STRK + 
				&d1_emph*EMPH + &d1_chbron*CHBRON + &d1_chol*CHOL + &d1_cancer*CANCER + 
				&d1_diab*DIAB + &d1_jtpain*JTPAIN + &d1_arth*ARTH + &d1_asth*ASTH +
				&d2*MALE + &d3_hispanic*RACE_HISPANIC + &d3_black*RACE_BLACK + &d3_other*RACE_OTHER +
				&d4_18*AGE_18_24 + &d4_25*AGE_25_34 + &d4_35*AGE_35_44 +
				&d4_45*AGE_45_54 + &d4_65*AGE_65_74 + &d4_75*AGE_75_85 +
				&d5_northeast*REGION_NORTHEAST + &d5_midwest*REGION_MIDWEST + &d5_west*REGION_WEST +
				&d6*IPDIS)/2);
		  		   
		pred = exp(mu+sigma*log(&k**2)/&k+log(gamma(1/(&k**2)+sigma/&k))-log(gamma(1/(&k**2))));
  
		keep dupersid mu sigma pred TOTEXP17;
	run;
%MEND;

%gamma_model(fold=1);
%gamma_model(fold=2);
%gamma_model(fold=3);
%gamma_model(fold=4);
%gamma_model(fold=5);

************************************************************;

*3.D. Calculate residuals for Cross-validation (5-fold validation);    
* Combine predictions from all folds;
data cv_residual;
    merge pred_1 pred_2 pred_3 pred_4 pred_5;
    by dupersid;
    
    * Calculate residuals and absolute residuals;
    resid = TOTEXP17 - pred;
    absresid = abs(TOTEXP17 - pred);
run;

* Summary statistics of residuals and absolute residuals;
proc univariate data=cv_residual;
    var resid absresid;
run;

/* Generalized Gamma Model results: 
   Mean cross-validation residual: -526	
   Mean cross-validation absolute residual: 6694 */
