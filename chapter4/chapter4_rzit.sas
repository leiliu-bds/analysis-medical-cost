libname meps "/home/u61757012/MEPS";
%let data = meps_chapter4;

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

****************************************;
****************************************;

proc nlmixed data=&data;
  parms a0=1.66 a1_hibp=0.79 a1_chd=0.60 a1_strk=0.20
        a1_emph=-0.19 a1_chbron=1.10 a1_chol=0.79 a1_cancer=0.97 
        a1_diab=1.27 a1_jtpain=0.53 a1_arth=0.59 a1_asth=0.63
        a2=-0.89 a3_hispanic=-1.07 a3_black=-0.76 a3_other=-0.61
        a4_18=-0.25 a4_25=-0.21 a4_35=-0.19
        a4_45=-0.10 a4_65=0.64 a4_75=0.65
        a5_northeast=0.39 a5_midwest=0.35 a5_west=0.30
        
        b0=7.163325 b1_hibp=0.154339 b1_chd=0.273351 b1_strk=0.189154
        b1_emph=0.096773 b1_chbron=0.111243 b1_chol=0.236719 b1_cancer=0.338940
        b1_diab=0.572022 b1_jtpain=0.280115 b1_arth=0.319793 b1_asth=0.354495
        b2=-0.256285 b3_hispanic=-0.491568 b3_black=-0.349058 b3_other=-0.278637	
        b4_18=-0.540029 b4_25=-0.374763 b4_35=-0.262409
        b4_45=-0.181010 b4_65=0.106329 b4_75=0.167482
        b5_northeast=0.266691 b5_midwest=0.106443 b5_west=0.102890
        b6=0
        
        d0=0.4802 d1_hibp=0.03428 d1_chd=-0.02044 d1_strk=0.2263
        d1_emph=0.000761 d1_chbron=0.05155 d1_chol=-0.1924 d1_cancer=0.06504
        d1_diab=0.01560 d1_jtpain=0.06287 d1_arth=-0.07606 d1_asth=-0.1148			
        d2=0.08317 d3_hispanic=0.2616 d3_black=0.2670 d3_other=0.08447					
        d4_18=-0.02268 d4_25=0.04705 d4_35=0.07917
        d4_45=0.1056 d4_65=-0.2723 d4_75=-0.1957		
        d5_northeast=0.03274 d5_midwest=-0.03171 d5_west=-0.04257	
        d6=-0.6160			
        
        var1=1.2 var2=0.2222 cov12=0.3;	

  bounds var1 var2 cov12 >=0;

  *log-likelihood;
  teta = random_effect1 + 
          a0 + a1_hibp*HIBP + a1_chd*CHD + a1_strk*STRK + 
          a1_emph*EMPH + a1_chbron*CHBRON + a1_chol*CHOL + a1_cancer*CANCER + 
          a1_diab*DIAB + a1_jtpain*JTPAIN + a1_arth*ARTH + a1_asth*ASTH +
          a2*MALE + a3_hispanic*RACE_HISPANIC + a3_black*RACE_BLACK + a3_other*RACE_OTHER +
          a4_18*AGE_18_24 + a4_25*AGE_25_34 + a4_35*AGE_35_44 +
          a4_45*AGE_45_54 + a4_65*AGE_65_74 + a4_75*AGE_75_85 +
          a5_northeast*REGION_NORTHEAST + a5_midwest*REGION_MIDWEST + a5_west*REGION_WEST;
  
  expteta = exp(teta);
  p = expteta / (1+expteta);

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

  *for zero-cost;
  if BTOTEXP17 = 0 then loglik = log(1 - p + p*probnorm((-1 - mu) / sigma));
  
  *for positive-cost;
  if BTOTEXP17 = 1 then loglik=log(P)-log(sigma*sqrt(8*ATAN(1)))-.5*((LOG(TOTEXP17) - mu)/sigma)**2;

  *Expected Value;
  E_y=exp(mu + sigma**2/2); 
  
  *Fit the model above;
  model TOTEXP17~general(loglik);
  
  *Define random effects;
  random random_effect1 random_effect2 ~ normal([0,0],[var1,cov12,var2]) subject=FAMID; 

  *Output parameters;
  predict p*E_y out=zit;

run;
	
data zit_residual;
	set zit;
	residual = TOTEXP17 - pred;
	abs = abs(residual);
run;

proc univariate data=zit_residual; 
  var residual abs ;
run;

/* Random Effects Zero-Inflated Model results: 
   Mean residual: 204.5				
   Mean absolute residual: 4718.6*/