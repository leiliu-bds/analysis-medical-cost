libname meps "/.../MEPS"; 	/* Note: You can modify the "..." to specify the desired directory path for MEPS data */
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
title "Log-normal distribution on cost data";
proc nlmixed data=&data;

	*Define initial values;
  	parms a0=2.1106 a1_hibp=0.8931 a1_chd=0.6886 a1_strk=0.1892
  		  a1_emph=-0.1390 a1_chbron=1.1547 a1_chol=0.8400 a1_cancer=0.9821
  	      a1_diab=1.4380 a1_jtpain=0.5824 a1_arth=0.6103 a1_asth=0.7043
  		  a2=-1.0686 a3_hispanic=-1.2170 a3_black=-0.8649 a3_other=-0.6470	
  		  a4_18=-0.3326 a4_25=-0.3150 a4_35=-0.2742	
  		  a4_45=-0.1721	a4_65=0.7017 a4_75=0.6802
  		  a5_northeast=0.4746 a5_midwest=0.4158 a5_west=0.3660
  		  		  
		  b0=7.1741 b1_hibp=0.1668 b1_chd=0.2431 b1_strk=0.1497
  		  b1_emph=0.05849 b1_chbron=0.09882 b1_chol=0.2298 b1_cancer=0.3215
  		  b1_diab=0.5340 b1_jtpain=0.2680 b1_arth=0.2874 b1_asth=0.3302
  		  b2=-0.2522 b3_hispanic=-0.4856 b3_black=-0.3383 b3_other=-0.2462	
  		  b4_18=-0.5576 b4_25=-0.3959 b4_35=-0.2717		
  		  b4_45=-0.1871 b4_65=0.1128 b4_75=0.1509
  		  b5_northeast=0.2863 b5_midwest=0.1043 b5_west=0.1092
  		  b6=2.0945
  		  	
  		  d0=0.4661 d1_hibp=0.03263 d1_chd=-0.02785 d1_strk=0.2268
  		  d1_emph=0.01445 d1_chbron=0.05223 d1_chol=-0.1900 d1_cancer=0.06751	
  		  d1_diab=0.02041 d1_jtpain=0.06502 d1_arth=-0.07810 d1_asth=-0.1109			
  		  d2=0.08788 d3_hispanic=0.2621 d3_black=0.2707 d3_other=0.08584						
  		  d4_18=-0.00924 d4_25=0.05809 d4_35=0.08484		
  		  d4_45=0.1134 d4_65=-0.2658 d4_75=-0.1908			
  		  d5_northeast=0.03333 d5_midwest=-0.03260 d5_west=-0.03967		
  		  d6=-0.6107;	
	
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

  	*for zero-cost;
 	if BTOTEXP17 = 0 then loglik = log(1-p);
	
  	*for positive-cost;
  	if BTOTEXP17 = 1 then do;
		z = (LOG(TOTEXP17) - mu) / sigma;
	    	pdf_normal = pdf('normal', z);
	    	loglik=log(p*pdf_normal/(sigma*TOTEXP17));
	end;
	
 	*Expected Value;
	E_y=exp(mu + sigma**2/2);

	*Fit the model above;
	model TOTEXP17~general(loglik); 
	
	*Output parameters;
	predict p*E_y out=lognormal;	
	
	*Marginal Effects;
	ESTIMATE 'marginal effect-HIBP' 		exp(a0 + a1_hibp)/(1+exp(a0 + a1_hibp))*exp(b0+b1_hibp+(exp((d0 + d1_hibp)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-CHD' 			exp(a0 + a1_chd)/(1+exp(a0 + a1_chd))*exp(b0+b1_chd+(exp((d0 + d1_chd)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-STRK' 		exp(a0 + a1_strk)/(1+exp(a0 + a1_strk))*exp(b0+b1_strk+(exp((d0 + d1_strk)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-EMPH' 		exp(a0 + a1_emph)/(1+exp(a0 + a1_emph))*exp(b0+b1_emph+(exp((d0 + d1_emph)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
    	ESTIMATE 'marginal effect-CHBRON' 		exp(a0 + a1_chbron)/(1+exp(a0 + a1_chbron))*exp(b0+b1_chbron+(exp((d0 + d1_chbron)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-CHOL' 		exp(a0 + a1_chol)/(1+exp(a0 + a1_chol))*exp(b0+b1_chol+(exp((d0 + d1_chol)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-CANCER' 		exp(a0 + a1_cancer)/(1+exp(a0 + a1_cancer))*exp(b0+b1_cancer+(exp((d0 + d1_cancer)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-DIAB' 		exp(a0 + a1_diab)/(1+exp(a0 + a1_diab))*exp(b0+b1_diab+(exp((d0 + d1_diab)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-JTPAIN' 		exp(a0 + a1_jtpain)/(1+exp(a0 + a1_jtpain))*exp(b0+b1_jtpain+(exp((d0 + d1_jtpain)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-ARTH' 		exp(a0 + a1_arth)/(1+exp(a0 + a1_arth))*exp(b0+b1_arth+(exp((d0 + d1_arth)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-ASTH' 		exp(a0 + a1_asth)/(1+exp(a0 + a1_asth))*exp(b0+b1_asth+(exp((d0 + d1_asth)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-MALE' 		exp(a0 + a2)/(1+exp(a0 + a2))*exp(b0+b2+(exp((d0 + d2)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
    	ESTIMATE 'marginal effect-HISPANIC' 		exp(a0 + a3_hispanic)/(1+exp(a0 + a3_hispanic))*exp(b0+b3_hispanic+(exp((d0 + d3_hispanic)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-BLACK'		exp(a0 + a3_black)/(1+exp(a0 + a3_black))*exp(b0+b3_black+(exp((d0 + d3_black)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-OTHER'		exp(a0 + a3_other)/(1+exp(a0 + a3_other))*exp(b0+b3_other+(exp((d0 + d3_other)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-AGE_18_24'		exp(a0 + a4_18)/(1+exp(a0 + a4_18))*exp(b0+b4_18+(exp((d0 + d4_18)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-AGE_25_34'		exp(a0 + a4_25)/(1+exp(a0 + a4_25))*exp(b0+b4_25+(exp((d0 + d4_25)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-AGE_35_44'		exp(a0 + a4_35)/(1+exp(a0 + a4_35))*exp(b0+b4_35+(exp((d0 + d4_35)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-AGE_45_54'		exp(a0 + a4_45)/(1+exp(a0 + a4_45))*exp(b0+b4_45+(exp((d0 + d4_45)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-AGE_65_74'		exp(a0 + a4_65)/(1+exp(a0 + a4_65))*exp(b0+b4_65+(exp((d0 + d4_65)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-AGE_75_85'		exp(a0 + a4_75)/(1+exp(a0 + a4_75))*exp(b0+b4_75+(exp((d0 + d4_75)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-NORTHEAST'		exp(a0 + a5_northeast)/(1+exp(a0 + a5_northeast))*exp(b0+b5_northeast+(exp((d0 + d5_northeast)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-MIDWEST' 		exp(a0 + a5_midwest)/(1+exp(a0 + a5_midwest))*exp(b0+b5_midwest+(exp((d0 + d5_midwest)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-WEST' 		exp(a0 + a5_west)/(1+exp(a0 + a5_west))*exp(b0+b5_west+(exp((d0 + d5_west)/2))**2/2)-exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2);
	ESTIMATE 'marginal effect-IPDIS' 		exp(b0+b6+(exp((d0 + d6)/2))**2/2)-exp(b0+(exp(d0/2))**2/2);
	
	*Partial Elasticity;
	ESTIMATE 'partial elasticity-HIBP' 		log(exp(a0 + a1_hibp)/(1+exp(a0 + a1_hibp))*exp(b0+b1_hibp+(exp((d0 + d1_hibp)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-CHD' 		log(exp(a0 + a1_chd)/(1+exp(a0 + a1_chd))*exp(b0+b1_chd+(exp((d0 + d1_chd)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-STRK' 		log(exp(a0 + a1_strk)/(1+exp(a0 + a1_strk))*exp(b0+b1_strk+(exp((d0 + d1_strk)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-EMPH' 		log(exp(a0 + a1_emph)/(1+exp(a0 + a1_emph))*exp(b0+b1_emph+(exp((d0 + d1_emph)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
    	ESTIMATE 'partial elasticity-CHBRON'		log(exp(a0 + a1_chbron)/(1+exp(a0 + a1_chbron))*exp(b0+b1_chbron+(exp((d0 + d1_chbron)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-CHOL' 		log(exp(a0 + a1_chol)/(1+exp(a0 + a1_chol))*exp(b0+b1_chol+(exp((d0 + d1_chol)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-CANCER'		log(exp(a0 + a1_cancer)/(1+exp(a0 + a1_cancer))*exp(b0+b1_cancer+(exp((d0 + d1_cancer)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-DIAB' 		log(exp(a0 + a1_diab)/(1+exp(a0 + a1_diab))*exp(b0+b1_diab+(exp((d0 + d1_diab)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-JTPAIN'		log(exp(a0 + a1_jtpain)/(1+exp(a0 + a1_jtpain))*exp(b0+b1_jtpain+(exp((d0 + d1_jtpain)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-ARTH' 		log(exp(a0 + a1_arth)/(1+exp(a0 + a1_arth))*exp(b0+b1_arth+(exp((d0 + d1_arth)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-ASTH' 		log(exp(a0 + a1_asth)/(1+exp(a0 + a1_asth))*exp(b0+b1_asth+(exp((d0 + d1_asth)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-MALE' 		log(exp(a0 + a2)/(1+exp(a0 + a2))*exp(b0+b2+(exp((d0 + d2)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
    	ESTIMATE 'partial elasticity-HISPANIC' 		log(exp(a0 + a3_hispanic)/(1+exp(a0 + a3_hispanic))*exp(b0+b3_hispanic+(exp((d0 + d3_hispanic)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-BLACK'		log(exp(a0 + a3_black)/(1+exp(a0 + a3_black))*exp(b0+b3_black+(exp((d0 + d3_black)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-OTHER'		log(exp(a0 + a3_other)/(1+exp(a0 + a3_other))*exp(b0+b3_other+(exp((d0 + d3_other)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-AGE_18_24'		log(exp(a0 + a4_18)/(1+exp(a0 + a4_18))*exp(b0+b4_18+(exp((d0 + d4_18)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-AGE_25_34'		log(exp(a0 + a4_25)/(1+exp(a0 + a4_25))*exp(b0+b4_25+(exp((d0 + d4_25)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-AGE_35_44'		log(exp(a0 + a4_35)/(1+exp(a0 + a4_35))*exp(b0+b4_35+(exp((d0 + d4_35)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-AGE_45_54'		log(exp(a0 + a4_45)/(1+exp(a0 + a4_45))*exp(b0+b4_45+(exp((d0 + d4_45)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-AGE_65_74'		log(exp(a0 + a4_65)/(1+exp(a0 + a4_65))*exp(b0+b4_65+(exp((d0 + d4_65)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-AGE_75_85'		log(exp(a0 + a4_75)/(1+exp(a0 + a4_75))*exp(b0+b4_75+(exp((d0 + d4_75)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-NORTHEAST'		log(exp(a0 + a5_northeast)/(1+exp(a0 + a5_northeast))*exp(b0+b5_northeast+(exp((d0 + d5_northeast)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-MIDWEST' 		log(exp(a0 + a5_midwest)/(1+exp(a0 + a5_midwest))*exp(b0+b5_midwest+(exp((d0 + d5_midwest)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-WEST' 		log(exp(a0 + a5_west)/(1+exp(a0 + a5_west))*exp(b0+b5_west+(exp((d0 + d5_west)/2))**2/2))-log(exp(a0)/(1+exp(a0))*exp(b0+(exp(d0/2))**2/2));
	ESTIMATE 'partial elasticity-IPDIS' 		log(exp(b0+b6+(exp((d0 + d6)/2))**2/2))-log(exp(b0+(exp(d0/2))**2/2));
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

/* Log-Normal Model results: 
   Mean residual: -850	
   Mean absolute residual: 5910*/

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

*3.C. Cross-validation process for Log-Normal (5-fold validation);
%MACRO lognormal_model(fold,pred);
    data train;
        set cv_fold;
        where fold ne &fold.;
    run;
    
    data test;
        set cv_fold;
        where fold = &fold.; 
    run;
    
    title "Log-normal distribution on cost data (training data excluding fold &fold.)";
	proc nlmixed data=train;
	
		*Define initial values;
	  	parms a0=2.1106 a1_hibp=0.8931 a1_chd=0.6886 a1_strk=0.1892
	  		  a1_emph=-0.1390 a1_chbron=1.1547 a1_chol=0.8400 a1_cancer=0.9821
	  	      a1_diab=1.4380 a1_jtpain=0.5824 a1_arth=0.6103 a1_asth=0.7043
	  		  a2=-1.0686 a3_hispanic=-1.2170 a3_black=-0.8649 a3_other=-0.6470	
	  		  a4_18=-0.3326 a4_25=-0.3150 a4_35=-0.2742	
	  		  a4_45=-0.1721	a4_65=0.7017 a4_75=0.6802
	  		  a5_northeast=0.4746 a5_midwest=0.4158 a5_west=0.3660
	  		  		  
			  b0=7.1741 b1_hibp=0.1668 b1_chd=0.2431 b1_strk=0.1497
	  		  b1_emph=0.05849 b1_chbron=0.09882 b1_chol=0.2298 b1_cancer=0.3215
	  		  b1_diab=0.5340 b1_jtpain=0.2680 b1_arth=0.2874 b1_asth=0.3302
	  		  b2=-0.2522 b3_hispanic=-0.4856 b3_black=-0.3383 b3_other=-0.2462	
	  		  b4_18=-0.5576 b4_25=-0.3959 b4_35=-0.2717		
	  		  b4_45=-0.1871 b4_65=0.1128 b4_75=0.1509
	  		  b5_northeast=0.2863 b5_midwest=0.1043 b5_west=0.1092
	  		  b6=2.0945
	  		  	
	  		  d0=0.4661 d1_hibp=0.03263 d1_chd=-0.02785 d1_strk=0.2268
	  		  d1_emph=0.01445 d1_chbron=0.05223 d1_chol=-0.1900 d1_cancer=0.06751	
	  		  d1_diab=0.02041 d1_jtpain=0.06502 d1_arth=-0.07810 d1_asth=-0.1109			
	  		  d2=0.08788 d3_hispanic=0.2621 d3_black=0.2707 d3_other=0.08584						
	  		  d4_18=-0.00924 d4_25=0.05809 d4_35=0.08484		
	  		  d4_45=0.1134 d4_65=-0.2658 d4_75=-0.1908			
	  		  d5_northeast=0.03333 d5_midwest=-0.03260 d5_west=-0.03967		
	  		  d6=-0.6107;	
		
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

	  	*for zero-cost;
	  	if BTOTEXP17 = 0 then loglik = log(1-p);
	  	
	  	*for positive-cost;
	  	if BTOTEXP17 = 1 then do;
		  	z = (LOG(TOTEXP17) - mu) / sigma;
		    	pdf_normal = pdf('normal', z);
		    	loglik=log(p*pdf_normal/(sigma*TOTEXP17));
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

		mu=&b0+&b1_hibp*HIBP+&b1_chd*CHD+&b1_strk*STRK + 
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

		E_y=exp(mu + sigma**2/2);
		pred = p*E_y;
		
		keep dupersid mu sigma pred TOTEXP17;
	run;
%MEND;

%lognormal_model(fold=1);
%lognormal_model(fold=2);
%lognormal_model(fold=3);
%lognormal_model(fold=4);
%lognormal_model(fold=5);

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

/* Log Normal Model results: 
   Mean cross-validation residual: -851.0
   Mean cross-validation absolute residual: 5925.7*/
