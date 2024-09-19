libname meps "/home/u61757012/MEPS";
%let data = meps_chapter3_4pm;

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

	*4-Part Model for chapter 3;
	*Part1: the indicator of cost being positive;	
	if TOTEXP17 >0 then U=1 ;else U=0;
	
	*Part2: the indicator of any inpatient cost;		
	if IPDIS>0 then V = 1; else V=0;
	
	*Part3: the magnitude of outpatient (U=1, V=0);
	
	*Part4: the inpatient cost (U=1, V=1);
run;

************************************************************;
************************************************************;

* Set up estimate extract macro function;
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

*1. Part I from a 4-Part Model;
*1.A. Create a subset of covariate in Part I;
data covariate;
	set &data.;
	keep HIBP CHD STRK EMPH CHBRON CHOL CANCER DIAB JTPAIN ARTH ASTH 
				MALE RACE_HISPANIC RACE_BLACK RACE_OTHER
				AGE_18_24 AGE_25_34 AGE_35_44 AGE_45_54 AGE_65_74 AGE_75_85
				REGION_NORTHEAST REGION_MIDWEST REGION_WEST U V dupersid TOTEXP17;
run;

************************************************************;

*1.B. Run Part I: Logistic regression model to predict U (22613 obs);
title "Log-normal distribution on cost data (Part I from a 4-Part Model)";
proc logistic data=&data descending;
	model U = HIBP CHD STRK EMPH CHBRON CHOL CANCER DIAB JTPAIN ARTH ASTH 
				MALE RACE_HISPANIC RACE_BLACK RACE_OTHER
				AGE_18_24 AGE_25_34 AGE_35_44 AGE_45_54 AGE_65_74 AGE_75_85
				REGION_NORTHEAST REGION_MIDWEST REGION_WEST ;
	ods output ParameterEstimates=result_logistic_u;
	score data=covariate out=part1(rename=(p_1=prob_u));
run;

************************************************************;

*1.C. Display summary statistics of the calculated probability (prob_u);
proc means data=part1;
    var prob_u;
run; 

/* Log-Normal Model (part I from a 4-Part Model): 
   Mean probability: 0.8214288 */
  
************************************************************;
************************************************************;

*2. Part II from a 4-Part Model;
*2.A. Run Part II: Logistic regression model to predict V conditional on U=1;
title "Log-normal distribution on cost data (part II from a 4-Part Model)";
proc logistic data=&data descending;
	model V =  HIBP CHD STRK EMPH CHBRON CHOL CANCER DIAB JTPAIN ARTH ASTH 
				MALE RACE_HISPANIC RACE_BLACK RACE_OTHER
				AGE_18_24 AGE_25_34 AGE_35_44 AGE_45_54 AGE_65_74 AGE_75_85
				REGION_NORTHEAST REGION_MIDWEST REGION_WEST ;
	where U=1; * Only consider observations where U=1;
	score data=covariate out=part2(rename=(p_1=prob_v));
run;

************************************************************;

*2.C. Display summary statistics of the calculated probability (prob_v);
proc means data=part2;
    var prob_v;
    where U = 1;
run; 

/* Log-Normal Model (part II from a 4-Part Model): 
   Mean probability: 0.0972813 */

************************************************************; 
************************************************************;

*3. Part III from a 4-Part Model(16768 obs);
*3.A. Part III: Generalized linear model to predict outpatient conditional on U=1 and V=0;
title "Log-normal distribution on cost data (part III from a 4-Part Model)";
proc nlmixed data=&data;
	where U=1 and V=0;
	
	*Define initial values;
  	parms 	b0=0 b1_hibp=0 b1_chd=0 b1_strk=0
  			b1_emph=0 b1_chbron=0 b1_chol=0 b1_cancer=0
  			b1_diab=0 b1_jtpain=0 b1_arth=0 b1_asth=0
  		  	b2=0 b3_hispanic=0 b3_black=0 b3_other=0
  		  	b4_18=0 b4_25=0 b4_35=0
  		  	b4_45=0	b4_65=0 b4_75=0
  		  	b5_northeast=0 b5_midwest=0 b5_west=0
  		  	
  		  	d0=1 d1_hibp=1 d1_chd=1 d1_strk=1
  			d1_emph=1	d1_chbron=12 d1_chol=1 d1_cancer=1
  			d1_diab=1 d1_jtpain=1 d1_arth=1 d1_asth=1
  		  	d2=1 d3_hispanic=1 d3_black=0 d3_other=0
  		  	d4_18=1 d4_25=1 d4_35=1	
  		  	d4_45=1	d4_65=1 d4_75=1
  		  	d5_northeast=1 d5_midwest=1 d5_west=1;
  		  	
  	*Location;
  	mu =  b0 + b1_hibp*HIBP + b1_chd*CHD + b1_strk*STRK + 
  		   b1_emph*EMPH + b1_chbron*CHBRON + b1_chol*CHOL + b1_cancer*CANCER + 
  		   b1_diab*DIAB + b1_jtpain*JTPAIN + b1_arth*ARTH + b1_asth*ASTH +
  		   b2*MALE + b3_hispanic*RACE_HISPANIC + b3_black*RACE_BLACK + b3_other*RACE_OTHER +
  		   b4_18*AGE_18_24 + b4_25*AGE_25_34 + b4_35*AGE_35_44 +
  		   b4_45*AGE_45_54 + b4_65*AGE_65_74 + b4_75*AGE_75_85 +
  		   b5_northeast*REGION_NORTHEAST + b5_midwest*REGION_MIDWEST + b5_west*REGION_WEST ;
		  		  
	*Scale (heteroscedasticity);
	sigma = exp((d0 + d1_hibp*HIBP + d1_chd*CHD + d1_strk*STRK + 
		  		   d1_emph*EMPH + d1_chbron*CHBRON + d1_chol*CHOL + d1_cancer*CANCER + 
		  		   d1_diab*DIAB + d1_jtpain*JTPAIN + d1_arth*ARTH + d1_asth*ASTH +
		  		   d2*MALE + d3_hispanic*RACE_HISPANIC + d3_black*RACE_BLACK + d3_other*RACE_OTHER +
		  		   d4_18*AGE_18_24 + d4_25*AGE_25_34 + d4_35*AGE_35_44 +
		  		   d4_45*AGE_45_54 + d4_65*AGE_65_74 + d4_75*AGE_75_85 +
		  		   d5_northeast*REGION_NORTHEAST + d5_midwest*REGION_MIDWEST + d5_west*REGION_WEST)/2);
  	  	
	z = (LOG(TOTEXP17) - mu) / sigma;
    pdf_normal = pdf('normal', z);
    loglik=log((pdf_normal/(sigma*TOTEXP17)));
    	
	*Fit the model above;
	model TOTEXP17~general(loglik); 
	
	*Output parameters;
	ods output ParameterEstimates=est_all;
run;

************************************************************;

*3.B. Upload parameters into macro variables;
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
	
************************************************************;

*3.C. Make predictions;
data part3;
	set covariate;
	
	mu_outpatient = &b0+&b1_hibp*HIBP+&b1_chd*CHD+&b1_strk*STRK + 
  		   &b1_emph*EMPH + &b1_chbron*CHBRON + &b1_chol*CHOL + &b1_cancer*CANCER + 
  		   &b1_diab*DIAB + &b1_jtpain*JTPAIN + &b1_arth*ARTH + &b1_asth*ASTH +
  		   &b2*MALE + &b3_hispanic*RACE_HISPANIC + &b3_black*RACE_BLACK + &b3_other*RACE_OTHER +
  		   &b4_18*AGE_18_24 + &b4_25*AGE_25_34 + &b4_35*AGE_35_44 +
  		   &b4_45*AGE_45_54 + &b4_65*AGE_65_74 + &b4_75*AGE_75_85 +
  		   &b5_northeast*REGION_NORTHEAST + &b5_midwest*REGION_MIDWEST + &b5_west*REGION_WEST;
  	
  	sigma_outpatient = exp((&d0 + &d1_hibp*HIBP + &d1_chd*CHD + &d1_strk*STRK + 
				  		   &d1_emph*EMPH + &d1_chbron*CHBRON + &d1_chol*CHOL + &d1_cancer*CANCER + 
				  		   &d1_diab*DIAB + &d1_jtpain*JTPAIN + &d1_arth*ARTH + &d1_asth*ASTH +
				  		   &d2*MALE + &d3_hispanic*RACE_HISPANIC + &d3_black*RACE_BLACK + &d3_other*RACE_OTHER +
				  		   &d4_18*AGE_18_24 + &d4_25*AGE_25_34 + &d4_35*AGE_35_44 +
				  		   &d4_45*AGE_45_54 + &d4_65*AGE_65_74 + &d4_75*AGE_75_85 +
				  		   &d5_northeast*REGION_NORTHEAST + &d5_midwest*REGION_MIDWEST + &d5_west*REGION_WEST)/2);
  		   
	pred_outpatient=exp(mu_outpatient + sigma_outpatient**2/2);
	
	resid = TOTEXP17-pred_outpatient;
	abs = abs(resid);
run;

************************************************************;

*3.D. Display residuals;

proc univariate data=part3;
	var resid abs;
	where U=1 and V=0;
run;

/* Log-Normal Model (part III from a 4-Part Model): 
   Mean residual: -529.52956	
   Mean absolute residual: 4794.71839 */
  
************************************************************;
************************************************************;

*4. Part IV from a 4-Part Model(1807 obs);
*4.A. Part IV: Generalized linear model to predict inpatient conditional on U=1 and V=1;
title "Log-normal distribution on cost data (part IV from a 4-Part Model)";
proc nlmixed data=&data;
	where U=1 and V=1;
	
	*Define initial values;
   	parms 	b0=0 b1_hibp=0 b1_chd=0 b1_strk=0
  			b1_emph=0 b1_chbron=0 b1_chol=0 b1_cancer=0
  			b1_diab=0 b1_jtpain=0 b1_arth=0 b1_asth=0
  		  	b2=0 b3_hispanic=0 b3_black=0 b3_other=0
  		  	b4_18=0 b4_25=0 b4_35=0
  		  	b4_45=0	b4_65=0 b4_75=0
  		  	b5_northeast=0 b5_midwest=0 b5_west=0
  		  	
  		  	d0=1 d1_hibp=1 d1_chd=1 d1_strk=1
  			d1_emph=1	d1_chbron=12 d1_chol=1 d1_cancer=1
  			d1_diab=1 d1_jtpain=1 d1_arth=1 d1_asth=1
  		  	d2=1 d3_hispanic=1 d3_black=0 d3_other=0
  		  	d4_18=1 d4_25=1 d4_35=1	
  		  	d4_45=1	d4_65=1 d4_75=1
  		  	d5_northeast=1 d5_midwest=1 d5_west=1;
  		
  	*Location;
  	mu =  b0 + b1_hibp*HIBP + b1_chd*CHD + b1_strk*STRK + 
  		   b1_emph*EMPH + b1_chbron*CHBRON + b1_chol*CHOL + b1_cancer*CANCER + 
  		   b1_diab*DIAB + b1_jtpain*JTPAIN + b1_arth*ARTH + b1_asth*ASTH +
  		   b2*MALE + b3_hispanic*RACE_HISPANIC + b3_black*RACE_BLACK + b3_other*RACE_OTHER +
  		   b4_18*AGE_18_24 + b4_25*AGE_25_34 + b4_35*AGE_35_44 +
  		   b4_45*AGE_45_54 + b4_65*AGE_65_74 + b4_75*AGE_75_85 +
  		   b5_northeast*REGION_NORTHEAST + b5_midwest*REGION_MIDWEST + b5_west*REGION_WEST ;
	
	*Scale (heteroscedasticity);
	sigma = exp((d0 + d1_hibp*HIBP + d1_chd*CHD + d1_strk*STRK + 
		  		   d1_emph*EMPH + d1_chbron*CHBRON + d1_chol*CHOL + d1_cancer*CANCER + 
		  		   d1_diab*DIAB + d1_jtpain*JTPAIN + d1_arth*ARTH + d1_asth*ASTH +
		  		   d2*MALE + d3_hispanic*RACE_HISPANIC + d3_black*RACE_BLACK + d3_other*RACE_OTHER +
		  		   d4_18*AGE_18_24 + d4_25*AGE_25_34 + d4_35*AGE_35_44 +
		  		   d4_45*AGE_45_54 + d4_65*AGE_65_74 + d4_75*AGE_75_85 +
		  		   d5_northeast*REGION_NORTHEAST + d5_midwest*REGION_MIDWEST + d5_west*REGION_WEST)/2);
  	  	
	z = (LOG(TOTEXP17) - mu) / sigma;
    pdf_normal = pdf('normal', z);
    loglik=log((pdf_normal/(sigma*TOTEXP17)));

    	
	*Fit the model above;
	model TOTEXP17~general(loglik); 
	
	*Output parameters;
	ods output ParameterEstimates=est_all;
run; 

************************************************************;

*4.B. Upload parameters into macro variables;
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

************************************************************;

*4.C. Make predictions;
data part4;
	set covariate;
	
	mu_inpatient = &b0+&b1_hibp*HIBP+&b1_chd*CHD+&b1_strk*STRK + 
  		   &b1_emph*EMPH + &b1_chbron*CHBRON + &b1_chol*CHOL + &b1_cancer*CANCER + 
  		   &b1_diab*DIAB + &b1_jtpain*JTPAIN + &b1_arth*ARTH + &b1_asth*ASTH +
  		   &b2*MALE + &b3_hispanic*RACE_HISPANIC + &b3_black*RACE_BLACK + &b3_other*RACE_OTHER +
  		   &b4_18*AGE_18_24 + &b4_25*AGE_25_34 + &b4_35*AGE_35_44 +
  		   &b4_45*AGE_45_54 + &b4_65*AGE_65_74 + &b4_75*AGE_75_85 +
  		   &b5_northeast*REGION_NORTHEAST + &b5_midwest*REGION_MIDWEST + &b5_west*REGION_WEST;
  	
  	sigma_inpatient = exp((&d0 + &d1_hibp*HIBP + &d1_chd*CHD + &d1_strk*STRK + 
				  		   &d1_emph*EMPH + &d1_chbron*CHBRON + &d1_chol*CHOL + &d1_cancer*CANCER + 
				  		   &d1_diab*DIAB + &d1_jtpain*JTPAIN + &d1_arth*ARTH + &d1_asth*ASTH +
				  		   &d2*MALE + &d3_hispanic*RACE_HISPANIC + &d3_black*RACE_BLACK + &d3_other*RACE_OTHER +
				  		   &d4_18*AGE_18_24 + &d4_25*AGE_25_34 + &d4_35*AGE_35_44 +
				  		   &d4_45*AGE_45_54 + &d4_65*AGE_65_74 + &d4_75*AGE_75_85 +
				  		   &d5_northeast*REGION_NORTHEAST + &d5_midwest*REGION_MIDWEST + &d5_west*REGION_WEST)/2);
  		   
	pred_inpatient=exp(mu_inpatient+sigma_inpatient**2/2);
	
	resid = TOTEXP17-pred_inpatient;
	abs = abs(resid);
run;

************************************************************;

*4.D. Display residuals;

proc univariate data=part4;
	var resid abs;
	where U=1 and V=1;
run;

/* Log-Normal Model (part IV from a 4-Part Model): 
   Mean residual: -1384.6473
   Mean absolute residual: 22150.1286 */
	
************************************************************;
************************************************************;

*5. Merge predictions from each part;
*5.A. Sort and merge dataset;
proc sort data=part1;by dupersid;run;
proc sort data=part2;by dupersid;run;
proc sort data=part3;by dupersid;run;
proc sort data=part4;by dupersid;run;

data fourpart;
	merge part1(keep=dupersid prob_u TOTEXP17) 
		  part2(keep=dupersid prob_v)  
		  part3(keep=dupersid pred_outpatient)  
		  part4(keep=dupersid pred_inpatient);
	by dupersid;
	
	pred=prob_u*(prob_v*pred_inpatient+(1-prob_v)*pred_outpatient);
	
	resid = TOTEXP17 - pred;
	abs = abs(resid);
run;

************************************************************;

*5.B. Examine residuals;	
proc univariate	data=fourpart;
	var resid abs;
run;

/* Log-Normal Model (4-Part Model) results: 
   Mean residual: -466.21773
   Mean absolute residual: 6577.02643	*/
