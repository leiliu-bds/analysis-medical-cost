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
%let gamma=gamma;

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

*1. Calculate coefficient;
 * (Note: Codes for incremental effect and partial elasticity can be found on the R file "chapter3_box-cox_rate_of_change.R");

title "Box-Cox transformation on cost data";
proc nlmixed data=&data;

	*Define initial values;
  	parms a0=2.1073 a1_hibp=0.9031 a1_chd=0.7072 a1_strk=0.2085 
  		  a1_emph=-0.1208 a1_chbron=1.1689 a1_chol=0.8573 a1_cancer=1.0304 
  	      	  a1_diab=1.4906 a1_jtpain=0.5904 a1_arth=0.6471 a1_asth=0.7268
  		  a2=-1.0777 a3_hispanic=-1.2316 a3_black=-0.8807 a3_other=-0.6731	
  		  a4_18=-0.3408 a4_25=-0.3204 a4_35=-0.2818	
  		  a4_45=-0.1783	a4_65=0.7202 a4_75=0.7106
  		  a5_northeast=0.4702 a5_midwest=0.4196 a5_west=0.3709
  		  		  
		  b0=9.6103 b1_hibp=0.2690 b1_chd=0.4872 b1_strk=0.3450
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
		v= (TOTEXP17**gamma - 1)/gamma;
		loglik = log(p) -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);
	end;

 	*Box-Cox transformation;
 	mean = gamma * mu +1;	
	var = gamma**2 * sigma**2; 
 		
	*Fit the model above;
	model TOTEXP17~general(loglik);

	*Output parameters;
  	predict mean out=box_mean;
    	predict var out=box_var;
    	predict gamma out=box_gamma;
 	predict p out=box_p;
run;

************************************************************;
************************************************************;

*2. Calculate residuals;
data box_residual;
	merge box_mean(rename=(pred=mean))
 		box_var(rename=(pred=var))
		box_gamma(rename=(pred=gamma))
 		box_p(rename=(pred=p));
	by dupersid;

	* Generate normal random number to approximate the expectation of \mu ^ (1/gamma);
	array normalvalue [1000] nv1-nv1000;
	array predvalue[1000] pred1-pred1000;

	* Initialize the random number seed;
	call streaminit(12345);  
	do i=1 to 1000;
		NormalValue[i] = rand("Normal", mean, sqrt(var));
		predvalue[i] = normalvalue[i]**(1/gamma);
	end;	
 
	meanpred = p* mean(of predvalue[*]);

	resid=totexp17-meanpred;				
	abs = abs(resid);					
run;

proc univariate data=box_residual;
	var resid abs;
run;

/* Note: Residuals may vary with different runs if the random number seed is altered. */
/* Box-Cox Transformations Model results: 
   Mean residual: -169.1				
   Mean absolute residual: 5489.7*/
   
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

*3.C. Cross-validation process for Box-Cox (5-fold validation);
%MACRO boxcox_model(fold,pred);
    data train;
        set cv_fold;
        where fold ne &fold.;
    run;
    
    data test;
        set cv_fold;
        where fold = &fold.; 
    run;
    
    title "Box-Cox transformation on cost data (training data excluding fold &fold.)";
	proc nlmixed data = train;
	
		*Define initial values;
	  	parms a0=2.1073 a1_hibp=0.9031 a1_chd=0.7072 a1_strk=0.2085 
	  		  a1_emph=-0.1208 a1_chbron=1.1689 a1_chol=0.8573 a1_cancer=1.0304 
	  	      	  a1_diab=1.4906 a1_jtpain=0.5904 a1_arth=0.6471 a1_asth=0.7268
	  		  a2=-1.0777 a3_hispanic=-1.2316 a3_black=-0.8807 a3_other=-0.6731	
	  		  a4_18=-0.3408 a4_25=-0.3204 a4_35=-0.2818	
	  		  a4_45=-0.1783	a4_65=0.7202 a4_75=0.7106
	  		  a5_northeast=0.4702 a5_midwest=0.4196 a5_west=0.3709
	  		  		  
			  b0=9.6103 b1_hibp=0.2690 b1_chd=0.4872 b1_strk=0.3450
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
			v= (TOTEXP17**gamma - 1)/gamma;
			loglik = log(p) -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);
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
	%parameter(est_all,gamma);
	
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

		mean = &gamma * mu +1;
		var = &gamma**2 * sigma**2;

		* Generate normal random number to approximate the expectation of \mu ^ (1/gamma);
		array normalvalue [1000] nv1-nv1000;
		array predvalue[1000] pred1-pred1000;


		* Initialize the random number seed;
		call streaminit(12345);  
		do i=1 to 1000;
			NormalValue[i] = rand("Normal", mean, sqrt(var));
			predvalue[i] = normalvalue[i]**(1/&gamma);
		end;
		
		meanpred = p*mean(of predvalue[*]);

	run;
 
 %MEND;

%boxcox_model(fold=1);
%boxcox_model(fold=2);
%boxcox_model(fold=3);
%boxcox_model(fold=4);
%boxcox_model(fold=5);
    
************************************************************;
************************************************************;

*3.D. Calculate residuals for Cross-validation (5-fold validation);    
* Combine predictions from all folds;
data cv_residual;
    merge pred_1 pred_2 pred_3 pred_4 pred_5;
    by dupersid;
    
    * Calculate residuals and absolute residuals;
    resid=TOTEXP17-meanpred;
    absresid=abs(TOTEXP17-meanpred);
run;

* Summary statistics of residuals and absolute residuals;
proc univariate data=cv_residual;
    var resid absresid;
run;

/* Note: Residuals may vary with different runs if the random number seed is altered. */
/* Box-Cox Model results: 
   Mean cross-validation residual: -172.8	
   Mean cross-validation absolute residual: 5500.2 */

************************************************************;
************************************************************;

*4. Bootstrap dataset for calculating the standard error for incremental effect and partial elasticity;

*4.A. Creating Empty Datasets for Storing Bootstrap Results;
data bootstrap_parameter;
    length a0 a1_hibp a1_chd a1_strk a1_emph a1_chbron a1_chol a1_cancer 
		  a1_diab a1_jtpain a1_arth a1_asth a2 a3_hispanic a3_black a3_other
		  a4_18 a4_25 a4_35 a4_45 a4_65 a4_75 a5_northeast a5_midwest a5_west
		  		  		  
		  b0 b1_hibp b1_chd b1_strk b1_emph b1_chbron b1_chol b1_cancer
  		  b1_diab b1_jtpain b1_arth b1_asth b2 b3_hispanic b3_black b3_other	
  		  b4_18 b4_25 b4_35 b4_45 b4_65 b4_75 b5_northeast b5_midwest b5_west b6
		  		  	
  		  d0 d1_hibp d1_chd d1_strk d1_emph d1_chbron d1_chol d1_cancer
  		  d1_diab d1_jtpain d1_arth d1_asth	d2 d3_hispanic d3_black d3_other			
  		  d4_18 d4_25 d4_35 d4_45 d4_65 d4_75 d5_northeast d5_midwest d5_west d6 gamma 8;
    *iteration = .;
run;

/*Note: this step is used to check the basic statistics for bootstrap data*/
/*data bootstrap_stats;
    length bootstrap_mean bootstrap_std 8;
    iteration = .;
run;*/

************************************************************;

*4.B. Bootstrap loop;
*Setting up Bootstrap Parameters;
%let n_bootstrap = 100;
%let seed = 12345;

%macro bootstrap;
	%do i = 1 %to &n_bootstrap;
		* Resampling Data Using proc surveyselect with a specific seed for each iteration;
		proc surveyselect data=&data
			out=outboot
			noprint
			method=urs
			samprate=1
			outhits
			rep=1
			seed=%eval(&seed. + &i);  * Incrementing the seed with the loop index to ensure unique but reproducible results;
		run;
	   
        	**************************************************;
	    
		/*Note: this step is used to check the basic statistics for bootstrap data*/
		/*
		*Storing Bootstrap Mean and Standard Deviation;
		proc means data=outboot mean STD noprint;
		    var TOTEXP17;
		    output out=bootstrap_stats_temp_&i 
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
		proc append base=bootstrap_stats 
				data=bootstrap_stats_temp_&i force;
		run;
		*/
	   
	    	**************************************************;
	    
	   	*Fitting the Box-Cox Distribution Model;
	    	proc nlmixed data=outboot;
	
			*Define initial values;
		  	parms a0=2.1073 a1_hibp=0.9031 a1_chd=0.7072 a1_strk=0.2085 
		  		  a1_emph=-0.1208 a1_chbron=1.1689 a1_chol=0.8573 a1_cancer=1.0304 
		  	      a1_diab=1.4906 a1_jtpain=0.5904 a1_arth=0.6471 a1_asth=0.7268
		  		  a2=-1.0777 a3_hispanic=-1.2316 a3_black=-0.8807 a3_other=-0.6731	
		  		  a4_18=-0.3408 a4_25=-0.3204 a4_35=-0.2818	
		  		  a4_45=-0.1783	a4_65=0.7202 a4_75=0.7106
		  		  a5_northeast=0.4702 a5_midwest=0.4196 a5_west=0.3709
		  		  		  
				  b0=9.6103 b1_hibp=0.2690 b1_chd=0.4872 b1_strk=0.3450
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
				loglik = log(p) -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);
			end;
			
			*Fitting the above model;
			model TOTEXP17~general(loglik);
			ods output ParameterEstimates=box_est;
		run;
	
	    	**************************************************;
		
		*Storing Parameter Estimates;
		proc transpose data=box_est(keep=parameter estimate) 
						out=box_est_&i(drop=_name_);
					id parameter;
					var estimate;
		run;
		
		proc append base=bootstrap_parameter
	    			data=box_est_&i force;
		run;

	%end;
    
%mend;

************************************************************;

*4.D. Execution bootstrap;
%bootstrap;

************************************************************;

*4.E. Output bootstrap;
/* Note: The content of "bootstrap_parameter.csv" may vary between runs due to the randomness in the SAS bootstrap process. */
/* Note: The file "bootstrap_parameter.csv" can be used to calculate the standard errors for incremental effect and partial elasticity in the R script "chapter3_box-cox_rate_of_change.R". */
proc export data=bootstrap_parameter
	     outfile="/.../bootstrap_parameter.csv"
	     dbms=csv replace;
run;

/*Note: this step is used to check the basic statistics for bootstrap data*/
/*proc export data=bootstrap_stats
	     outfile="/.../bootstrap_stats.csv"
	     dbms=csv replace;
run;*/
