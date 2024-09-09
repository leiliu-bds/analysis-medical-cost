libname meps "/home/u61757012/MEPS";
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
************************************************************;

*1. Calculate coefficient;
 * (Note: Codes for incremental effect and partial elasticity can be found on the R file "chapter2_box-cox_rate_of_change.R");

title "Box-Cox distribution on positive-cost data";
proc nlmixed data=&data;
		
	*Define initial values;
  	parms 	b0=0 b1_hibp=0 b1_chd=0 b1_strk=0
  			b1_emph=0 b1_chbron=0 b1_chol=0 b1_cancer=0
  			b1_diab=0 b1_jtpain=0 b1_arth=0 b1_asth=0
  		  	b2=0 b3_hispanic=0 b3_black=0 b3_other=0
  		  	b4_18=0 b4_25=0 b4_35=0
  		  	b4_45=0	b4_65=0 b4_75=0
  		  	b5_northeast=0 b5_midwest=0 b5_west=0
  		  	b6=0
  		  	
  		  	d0=1 d1_hibp=1 d1_chd=1 d1_strk=1
  			d1_emph=1	d1_chbron=12 d1_chol=1 d1_cancer=1
  			d1_diab=1 d1_jtpain=1 d1_arth=1 d1_asth=1
  		  	d2=1 d3_hispanic=1 d3_black=0 d3_other=0
  		  	d4_18=1 d4_25=1 d4_35=1	
  		  	d4_45=1	d4_65=1 d4_75=1
  		  	d5_northeast=1 d5_midwest=1 d5_west=1
  		  	d6=1
  			
  			gamma=1;
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
		  				 
	v= (TOTEXP17**gamma - 1)/gamma;
	loglik = -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);
	
	*Fitting the above model;
	model TOTEXP17~general(loglik);
	ods output ParameterEstimates=est_box FitStatistics=fit_box;
	predict mu out=mu;
	predict sigma out=sigma;
run;

************************************************************;
************************************************************;

*2. Calculate residuals;
data est;
	set est_box;
	if parameter="gamma";
	call symputx('gamma', estimate);
run;*0.07403;

data output;
	merge mu (rename=(pred=mu_pred))
		sigma (rename=(pred=sigma_pred));
	by dupersid;
	mean=&gamma * mu_pred +1;
	var=&gamma**2 * sigma_pred**2; 	
run;

data box;
	set output;
	array normalvalue [1000] nv1-nv1000;
	array predvalue[1000] pred1-pred1000;
	
		* Generate normal random number to approximate the expectation of \mu ^ (1/gamma);
		do i=1 to 1000;
			NormalValue[i] = rand("Normal", mean, sqrt(var));
			predvalue[i]= normalvalue[i]**(1/&gamma);
		end;
		
		meanpred= mean(of predvalue[*]);
		resid=totexp17-meanpred;				*mean of residual: -726.55176;
run;

data box_residual;
	set box;
	abs = abs(resid);						*mean of abs: 6045.69966;
run;

proc univariate data=box_residual;
	var resid abs;
run;

/* Box-Cox Model results: 
   Mean residual: -322					
   Mean absolute residual: 6492		*/

************************************************************;
************************************************************;

*3. Cross-validation Residuals;
*3.A. split TOTEXP17 into 5 group using quantile;
data cv;
	set &data;
	if TOTEXP17<435.5 then group=1;
		else if TOTEXP17<1317 then group=2;
		else if TOTEXP17<3279.5 then group=3;		
		else if TOTEXP17<8727 then group=4;
		else group=5;		
run;
	
************************************************************;

*3.B Stratified sampling macro to split data into 5 foltrain by spending group;
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

* Combine the 5 foltrain into one dataset;
data cv_fold;
    merge fold_1 fold_2 fold_3 fold_4 fold_5;
    by dupersid;
run;

************************************************************;

*3.C. Capture parameter estimates;
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
%let gamma=gamma;

%MACRO parameter (name=);
    data  _null_;
        set est_all;
        if parameter="&name";
        call symput("&name", estimate);  /* Save the estimate in a macro variable */
    run;
%MEND;

************************************************************;

*3.D. Cross-validation process for Box-Cox (5-fold validation);
%MACRO boxcox_model(fold,pred);
    data train;
        set cv_fold;
        where fold ne &fold.;
    run;
    
    data test;
        set cv_fold;
        where fold = &fold.; 
    run;

    title "Box-cox on positive-cost data (training data excluding fold &fold.)";
    proc nlmixed data=train;
	  	parms 	b0=0 b1_hibp=0 b1_chd=0 b1_strk=0
	  			b1_emph=0 b1_chbron=0 b1_chol=0 b1_cancer=0
	  			b1_diab=0 b1_jtpain=0 b1_arth=0 b1_asth=0
	  		  	b2=0 b3_hispanic=0 b3_black=0 b3_other=0
	  		  	b4_18=0 b4_25=0 b4_35=0
	  		  	b4_45=0	b4_65=0 b4_75=0
	  		  	b5_northeast=0 b5_midwest=0 b5_west=0
	  		  	b6=0
	  		  	
	  		  	d0=1 d1_hibp=1 d1_chd=1 d1_strk=1
	  			d1_emph=1	d1_chbron=12 d1_chol=1 d1_cancer=1
	  			d1_diab=1 d1_jtpain=1 d1_arth=1 d1_asth=1
	  		  	d2=1 d3_hispanic=1 d3_black=0 d3_other=0
	  		  	d4_18=1 d4_25=1 d4_35=1	
	  		  	d4_45=1	d4_65=1 d4_75=1
	  		  	d5_northeast=1 d5_midwest=1 d5_west=1
	  		  	d6=1 gamma=1;   
	  		  	
		mu =  b0 + b1_hibp*HIBP + b1_chd*CHD + b1_strk*STRK + 
	  		   b1_emph*EMPH + b1_chbron*CHBRON + b1_chol*CHOL + b1_cancer*CANCER + 
	  		   b1_diab*DIAB + b1_jtpain*JTPAIN + b1_arth*ARTH + b1_asth*ASTH +
	  		   b2*MALE + b3_hispanic*RACE_HISPANIC + b3_black*RACE_BLACK + b3_other*RACE_OTHER +
	  		   b4_18*AGE_18_24 + b4_25*AGE_25_34 + b4_35*AGE_35_44 +
	  		   b4_45*AGE_45_54 + b4_65*AGE_65_74 + b4_75*AGE_75_85 +
	  		   b5_northeast*REGION_NORTHEAST + b5_midwest*REGION_MIDWEST + b5_west*REGION_WEST +
	  		   b6*IPDIS;
			  		  
		sigma = exp((d0 + d1_hibp*HIBP + d1_chd*CHD + d1_strk*STRK + 
			  		   d1_emph*EMPH + d1_chbron*CHBRON + d1_chol*CHOL + d1_cancer*CANCER + 
			  		   d1_diab*DIAB + d1_jtpain*JTPAIN + d1_arth*ARTH + d1_asth*ASTH +
			  		   d2*MALE + d3_hispanic*RACE_HISPANIC + d3_black*RACE_BLACK + d3_other*RACE_OTHER +
			  		   d4_18*AGE_18_24 + d4_25*AGE_25_34 + d4_35*AGE_35_44 +
			  		   d4_45*AGE_45_54 + d4_65*AGE_65_74 + d4_75*AGE_75_85 +
			  		   d5_northeast*REGION_NORTHEAST + d5_midwest*REGION_MIDWEST + d5_west*REGION_WEST +
			  		   d6*IPDIS)/2);
	  	  	
		v= (TOTEXP17**gamma - 1)/gamma;
		loglik = -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);

		ods output ParameterEstimates=est_all; 
		model TOTEXP17~general(loglik);
	run;
	
	%parameter(name=b0);
	%parameter(name=b1_hibp);
	%parameter(name=b1_chd);
	%parameter(name=b1_strk);
	%parameter(name=b1_emph);
	%parameter(name=b1_chbron);
	%parameter(name=b1_chol);
	%parameter(name=b1_cancer);
	%parameter(name=b1_diab);
	%parameter(name=b1_jtpain);
	%parameter(name=b1_arth);
	%parameter(name=b1_asth);
	%parameter(name=b2);
	%parameter(name=b3_hispanic);
	%parameter(name=b3_black);
	%parameter(name=b3_other);
	%parameter(name=b4_18);
	%parameter(name=b4_25);
	%parameter(name=b4_35);
	%parameter(name=b4_45);
	%parameter(name=b4_65);
	%parameter(name=b4_75);
	%parameter(name=b5_northeast);
	%parameter(name=b5_midwest);
	%parameter(name=b5_west);
	%parameter(name=b6);

	%parameter(name=d0);
	%parameter(name=d1_hibp);
	%parameter(name=d1_chd);
	%parameter(name=d1_strk);
	%parameter(name=d1_emph);
	%parameter(name=d1_chbron);
	%parameter(name=d1_chol);
	%parameter(name=d1_cancer);
	%parameter(name=d1_diab);
	%parameter(name=d1_jtpain);
	%parameter(name=d1_arth);
	%parameter(name=d1_asth);
	%parameter(name=d2);
	%parameter(name=d3_hispanic);
	%parameter(name=d3_black);
	%parameter(name=d3_other);
	%parameter(name=d4_18);
	%parameter(name=d4_25);
	%parameter(name=d4_35);
	%parameter(name=d4_45);
	%parameter(name=d4_65);
	%parameter(name=d4_75);
	%parameter(name=d5_northeast);
	%parameter(name=d5_midwest);
	%parameter(name=d5_west);
	%parameter(name=d6);
	%parameter(name=gamma);
	
	
    /* Make predictions using the fitted model */
    data test_&fold.;
        set test;
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
		mean=&gamma * mu +1;
		var=&gamma**2 * sigma**2;
		keep dupersid mean var TOTEXP17;
	run;

	data pred_&fold.;
		set test_&fold.;
		array normalvalue [1000] nv1-nv1000;
		array predvalue[1000] pred1-pred1000;
		call streaminit(123);
		
		* Generate normal random number to approximate the expectation of \mu ^ (1/gamma);
		do i=1 to 1000;
			NormalValue[i] = rand("Normal", mean, sqrt(var));
			predvalue[i]= normalvalue[i]**(1/&gamma);
		end;
		meanpred=mean(of predvalue[*]);
		resid=totexp17-meanpred;
	run;
%MEND;

%boxcox_model(fold=1);
%boxcox_model(fold=2);
%boxcox_model(fold=3);
%boxcox_model(fold=4);
%boxcox_model(fold=5);
    
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
	resid=TOTEXP17-meanpred;
	absresid=abs(TOTEXP17-meanpred);
run;

* Summary statistics of residuals and absolute residuals;
proc univariate data=cv_residual;
    var resid absresid;
run;

/* Box-Cox Model results: 
   Mean cross-validation residual: -310		
   Mean cross-validation absolute residual: 6495		 */

************************************************************;
************************************************************;

*4. Bootstrap dataset for calculating the standard error for incremental effect and partial elasticity;
*4.A. Setting up Bootstrap Parameters;
%let n_bootstrap = 100;
*%let seed = 123;

************************************************************;

*4.B. Creating Empty Datasets for Storing Bootstrap Results;
data bootstrap_stats_part2;
    length bootstrap_mean bootstrap_std 8;
    iteration = .;
run;

data bootstrap_parameter_part2;
    length b0 b1_hibp b1_chd b1_strk b1_emph b1_chbron b1_chol b1_cancer
  	   b1_diab b1_jtpain b1_arth b1_asth b2 b3_hispanic b3_black b3_other	
  	   b4_18 b4_25 b4_35 b4_45 b4_65 b4_75 b5_northeast b5_midwest b5_west b6
		  		  	
  	   d0 d1_hibp d1_chd d1_strk d1_emph d1_chbron d1_chol d1_cancer
  	   d1_diab d1_jtpain d1_arth d1_asth	d2 d3_hispanic d3_black d3_other			
           d4_18 d4_25 d4_35 d4_45 d4_65 d4_75 d5_northeast d5_midwest d5_west d6 gamma 8;
    *iteration = .;
run;

************************************************************;

*4.C. Bootstrap loop;
%macro bootstrap;
    %do i = 1 %to &n_bootstrap;
    
	*Resampling Data Using proc surveyselect;
        proc surveyselect data=&data  
			  out=outboot noprint
			  method=urs
			  samprate=1
			  outhits
			  rep=1; 
	run;
   
        **************************************************;
        
        *Storing Bootstrap Mean and Standard Deviation;
        proc means data=outboot mean STD noprint;
            var TOTEXP17;
            output 	out=bootstrap_stats_temp_&i 
            		mean=bootstrap_mean 
			std=bootstrap_std;
        run;
        

        *Appending the statistic to the bootstrap_stats dataset;
        data bootstrap_stats_temp_&i ;
            set bootstrap_stats_temp_&i ;
            iteration = &i;
            output;
        run;
        

        * Appending the bootstrap_stats_temp dataset to bootstrap_stats;
        proc append base=bootstrap_stats_part2 
        	     data=bootstrap_stats_temp_&i force;
        run;
        
        **************************************************;
        
	*Fitting the Box-Cox Distribution Model;
        proc nlmixed data=outboot NOSORTSUB maxiter=50000;

		*Define initial values;
	  	parms b0=9.6103 b1_hibp=0.2690 b1_chd=0.4872 b1_strk=0.3450
	  	      b1_emph=0.1746 b1_chbron=0.2166 b1_chol=0.3831 b1_cancer=0.6097
		      b1_diab=1.0021 b1_jtpain=0.4690 b1_arth=0.5264 b1_asth=0.5768
		      b2=-0.4256 b3_hispanic=-0.8220 b3_black=-0.5817 b3_other=-0.4422	
	  	      b4_18=-0.9116 b4_25=-0.6504 b4_35=-0.4475	
	  	      b4_45=-0.3120 b4_65=0.1614 b4_75=0.2681	
	  	      b5_northeast=0.4931 b5_midwest=0.1612 b5_west=0.1792
	  	      b6=3.9966
		  		  	
	  	      d0=1.5251 d1_hibp=0.04841 d1_chd=0.007239 d1_strk=0.2521
	  	      d1_emph=-0.02116 d1_chbron=0.06284 d1_chol=-0.1531 d1_cancer=0.1420
	  	      d1_diab=0.08751 d1_jtpain=0.09788 d1_arth=-0.03765 d1_asth=-0.05170			
	  	      d2=0.05159 d3_hispanic=0.2021 d3_black=0.1978 d3_other=0.04476				
	  	      d4_18=-0.1136 d4_25=-0.01581 d4_35=0.03804
	  	      d4_45=0.08853 d4_65=-0.2495 d4_75=-0.1693	
	  	      d5_northeast=0.06382 d5_midwest=-0.02944 d5_west=-0.02921	
	  	      d6=-0.3131		
		  			
	  	      gamma=0.07388;	
	
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
	   	
		v= (TOTEXP17**gamma - 1)/gamma;
		loglik = -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);
			
		*Fitting the above model;
		model TOTEXP17~general(loglik);
		ods output ParameterEstimates=est_box;
	run;

       **************************************************;

	*Storing Parameter Estimates
	proc transpose data=est_box(keep=parameter estimate) 
			out=est_box_&i(drop=_name_);
			id parameter;
			var estimate;
	run;
		
	proc append base=bootstrap_parameter_part2
        	data=est_box_&i force;
       run;

    %end;

%mend;

************************************************************;

*4.D. Execution bootstrap;
%bootstrap;

************************************************************;

*4.E. Output bootstrap;
proc export data=bootstrap_stats_part2
	     outfile="/Users/lexy/Library/CloudStorage/OneDrive-WashingtonUniversityinSt.Louis/Desktop/202404_MEPS/04_Code/03_Marginal Effect_R/03_incremental_Basu/B. Modified_Lexy/20240415_bootstrap/part2_bootstrap_stats.csv"
	     dbms=csv replace;
run;

proc export data=bootstrap_parameter_part2
	     outfile="/Users/lexy/Library/CloudStorage/OneDrive-WashingtonUniversityinSt.Louis/Desktop/202404_MEPS/04_Code/03_Marginal Effect_R/03_incremental_Basu/B. Modified_Lexy/20240415_bootstrap/part2_bootstrap_parameter.csv"
	     dbms=csv replace;
run;
 * The file "part2_bootstrap_parameter.csv" can be used to calculate se for incremental effect and partial elasticity using the R file "chapter2_box-cox_rate_of_change.R");

