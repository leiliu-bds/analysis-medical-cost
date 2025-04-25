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

*********************************************;

proc sort data=&data;
	by FAMID;
run;

*1. Calculate incremental effect and partial elasticity;
title "Box-Cox transformation on correlated cost data";
proc nlmixed data=&data NOSORTSUB;

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
        
        var2=0.6882 
        
        gamma=0.07388 ;	
  
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

    *for positive-cost;
    v= (TOTEXP17**gamma - 1)/gamma;
    loglik = -0.5*((v-mu)/sigma)**2 - 0.5*log(2*3.1415926*sigma**2) + (gamma-1)*log(TOTEXP17);
    
    *Box-Cox transformation;
    mean = gamma * mu +1;	
    var = gamma**2 * sigma**2; 
    
    *Fit the model above;
    model TOTEXP17~general(loglik);
    
    *Define random effects;
    random random_effect2 ~ normal(0,var2) subject=FAMID; 
    
    *Output parameters;
    predict mean out=box_mean;
    predict var out=box_var;
    predict gamma out=box_gamma;
run;

************************************************************;
************************************************************;

*2. Calculate residuals;
proc sort data=box_mean; by dupersid;run;
proc sort data=box_var; by dupersid;run;
proc sort data=box_gamma; by dupersid;run;

data box_residual;
	merge box_mean(rename=(pred=mean))
 		  box_var(keep=dupersid pred rename=(pred=var))
		  box_gamma(keep=dupersid pred rename=(pred=gamma));
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
 
	meanpred = mean(of predvalue[*]);

	resid=totexp17-meanpred;				
	abs = abs(resid);					
run;

proc univariate data=box_residual;
	var resid abs;
run;

/* Note: Residuals may vary with different runs if the random number seed is altered. */
/* Random Effects Box-Cox Transformations Model results: 
   Mean residual: 161.2						
   Mean absolute residual: 5611.3		*/
