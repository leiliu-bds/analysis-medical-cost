#Package loading
#install.packages("Rtools")
#install.packages("remotes")
#remotes::install_github("yimshi/fql")
library(dplyr)
library(fql)

###############################################################################

#1. Residuals for FQL

#1.A. Data input
 #MEPS_CHAPTER2.csv file can be created and downloaded by using the SAS code "chapter2_data.sas"
  meps_chapter2 = read.csv("/Users/lexy/Library/CloudStorage/OneDrive-WashingtonUniversityinSt.Louis/Desktop/202409_MEPS/05_GitHub/chapter2/MEPS_CHAPTER2.csv")
  
  variable=c("HIBP","CHD","STRK","EMPH","CHBRON","CHOL",
             "CANCER","DIAB","JTPAIN","ARTH","ASTH",
             "MALE","RACE_HISPANIC","RACE_BLACK","RACE_OTHER",
             "AGE_18_24","AGE_25_34","AGE_35_44","AGE_45_54","AGE_65_74","AGE_75_85",
             "REGION_NORTHEAST","REGION_MIDWEST","REGION_WEST","IPDIS",
             "TOTEXP17")


#1.B. Keeping related variables
  data = meps_chapter2[,variable] #18575 26


#1.C. Applying FQL function
  fqlresult = fql(TOTEXP17~., data)

  fqlresult[[1]] #coefficient

  data_pred = data%>%
    mutate(pred = as.numeric(fqlresult$muest),
           resid = TOTEXP17-pred)


#1.D. Calculating mean residuals and mean absolute residuals 
  #mean residual: -676.8933
  mean(data_pred$resid)     
  
  #mean absolute residual: 6734.699
  mean(abs(data_pred$resid))

###############################################################################

#2. Cross-Validation Residuals for FQL

#2.A. Data input
 #CV_FOLD.csv file can be created and downloaded by using the SAS code "chapter2_data.sas"
  cv_fold = read.csv("/Users/lexy/Library/CloudStorage/OneDrive-WashingtonUniversityinSt.Louis/Desktop/202409_MEPS/05_GitHub/chapter2/CV_FOLD.csv")


#2.B. Setting up Cross-Validation and Residuals functions  
  for (j in 1:5){
    train = cv_fold[cv_fold$fold!=j,]
    
    test = cv_fold[cv_fold$fold==j,]
    
    fql_train = fql(TOTEXP17~., train[,variable])
    
    for (i in 1:nrow(test)){
      test$pred[i] =  exp(fql_train[[1]]$coefficients[1]+
                          fql_train[[1]]$coefficients[2]*test$HIBP[i] + 
                          fql_train[[1]]$coefficients[3]*test$CHD[i] + 
                          fql_train[[1]]$coefficients[4]*test$STRK[i] + 
                          fql_train[[1]]$coefficients[5]*test$EMPH[i] + 
                          fql_train[[1]]$coefficients[6]*test$CHBRON[i] + 
                          fql_train[[1]]$coefficients[7]*test$CHOL[i] + 
                          fql_train[[1]]$coefficients[8]*test$CANCER[i] + 
                          fql_train[[1]]$coefficients[9]*test$DIAB[i] + 
                          fql_train[[1]]$coefficients[10]*test$JTPAIN[i] + 
                          fql_train[[1]]$coefficients[11]*test$ARTH[i] + 
                          fql_train[[1]]$coefficients[12]*test$ASTH[i] +
                          fql_train[[1]]$coefficients[13]*test$MALE[i] + 
                          fql_train[[1]]$coefficients[14]*test$RACE_HISPANIC[i] + 
                          fql_train[[1]]$coefficients[15]*test$RACE_BLACK[i] +
                          fql_train[[1]]$coefficients[16]*test$RACE_OTHER[i]+
                          fql_train[[1]]$coefficients[17]*test$AGE_18_24[i] + 
                          fql_train[[1]]$coefficients[18]*test$AGE_25_34[i] + 
                          fql_train[[1]]$coefficients[19]*test$AGE_35_44[i] +
                          fql_train[[1]]$coefficients[20]*test$AGE_45_54[i] + 
                          fql_train[[1]]$coefficients[21]*test$AGE_65_74[i] + 
                          fql_train[[1]]$coefficients[22]*test$AGE_75_85[i] +
                          fql_train[[1]]$coefficients[23]*test$REGION_NORTHEAST[i] +
                          fql_train[[1]]$coefficients[24]*test$REGION_MIDWEST[i] + 
                          fql_train[[1]]$coefficients[25]*test$REGION_WEST[i]+
                          fql_train[[1]]$coefficients[26]*test$IPDIS[i])
                          }
    if (j==1){
      fql_cv = test
    }
    else{
      fql_cv = rbind(fql_cv,test)
    }
  }


#2.C. Calculating CV residuals
  fql_cv$resid = fql_cv$TOTEXP17-fql_cv$pred


#2.D. Calculating mean CV residuals and mean absolute CV residuals 
  #mean CV residual: -703.0333
  mean(fql_cv$resid)
  
  #mean absolute CV residual: 6767.882
  mean(abs(fql_cv$resid))

###############################################################################

#3. Incremental Effect for FQL

#3.A. Extracting FQL results
  fqlresult[[1]] #coefficient
  
  beta.0 = 8.048
  beta.1 = c(0.123,0.266,0.350,0.013,0.152,0.096,0.476,0.487,0.285,0.232,0.236,
             -0.129,-0.200,-0.153,-0.197,
             -0.451,-0.324,-0.145,-0.031,-0.025,0.056,
             0.304,0.028,0.098,1.660)
  
  se.0 = 0.054
  se.1 = c(0.038,0.055,0.070,0.067,0.079,0.038,0.063,0.041,0.038,0.042,0.045,
           0.033,0.053,0.047,0.054,
           0.088,0.060,0.062,0.052,0.047,0.054,
           0.048,0.040,0.048,0.040)


#3.B. Set up incremental effect function
  int_fql = function(beta_0,beta){
    eqn = exp(beta)-exp(beta_0)
    return(eqn)
  }


#3.C. Set up variance of marginal effect function by using delta method
  n=length(beta.1)
  effect_bi_fql_part2=matrix(0,nrow=2,ncol=n)
  
  int_fql_var = function(beta,se_beta){
    derivative_beta = exp(2*beta)
    var_beta = se_beta^2
    variance = derivative_beta*var_beta
    se = sqrt(variance)
    return(se)
  }


#3.D. Calculate incremental effect and SE
  for (i in 1:n) 
  {
    result = int_fql(beta_0 =  beta.0,
                     beta = beta.0 + beta.1[i])
    
    result_var = int_fql_var(beta = beta.0 + beta.1[i],
                             se_beta = se.1[i])
    effect_bi_fql_part2[1,i]=as.numeric(result) #incremental effect
    effect_bi_fql_part2[2,i]=as.numeric(result_var) #SE
  }


#3.E. Examine results
  colnames(effect_bi_fql_part2) = variable[!variable %in% "TOTEXP17"]
  row.names(effect_bi_fql_part2) = c("Estimate","SE")
  effect_bi_fql_part2
  #HIBP      CHD      STRK      EMPH   CHBRON     CHOL
  #Estimate 409.3454 953.0691 1310.6479  40.92336 513.4167 315.1274
  #SE       134.4014 224.4332  310.6727 212.28662 287.6351 130.8211
  
  #CANCER      DIAB    JTPAIN     ARTH     ASTH       MALE
  #Estimate 1906.6165 1962.2978 1031.3418 816.6607 832.4691 -378.51299
  #SE        317.1515  208.6831  158.0373 165.6562 178.2001   90.71768
  
  #RACE_HISPANIC RACE_BLACK RACE_OTHER  AGE_18_24 AGE_25_34
  #Estimate     -566.9257  -443.7041  -559.2323 -1135.3234 -865.5442
  #SE            135.7122   126.1400   138.6883   175.3145  135.7194
  
  #AGE_35_44 AGE_45_54 AGE_65_74 AGE_75_85 REGION_NORTHEAST
  #Estimate -422.1473 -95.46617 -77.21908  180.1387        1111.1159
  #SE        167.7340 157.66751 143.36478  178.6143         203.4552
  
  #REGION_MIDWEST REGION_WEST      IPDIS
  #Estimate       88.80846    322.0196 13321.1380
  #SE            128.65368    165.5786   657.946
  

#3.F. Calculate P value
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_fql_part2[1,]
  se = effect_bi_fql_part2[2,]
  
  p_value_fql = p_value(mean, se)
  as.numeric((p_value_fql))
  #[1] 2.321447e-03 2.170764e-05 2.456697e-05 8.471359e-01 7.426805e-02
  #[6] 1.600324e-02 1.835983e-09 0.000000e+00 6.757617e-11 8.229101e-07
  #[11] 2.989490e-06 3.013708e-05 2.948466e-05 4.355458e-04 5.523431e-05
  #[16] 9.423373e-11 1.800549e-10 1.184370e-02 5.448532e-01 5.901494e-01
  #[21] 3.131979e-01 4.728418e-08 4.900113e-01 5.179731e-02 0.000000e+00
  
###############################################################################           

#4. Partial Elasticity for FQL
  n=length(beta.1)
  effect_bi_fql_part2_pe=matrix(0,nrow=2,ncol=n)


#4.A. Set up marginal effect function
  beta.1


#4.B. Set up variance of marginal effect function by using delta method
  se.1


#4.C. Calculate partial elasticity
  for (i in 1:n) 
  {
    effect_bi_fql_part2_pe[1,i]=as.numeric(beta.1[i]) #partial elasticity
    effect_bi_fql_part2_pe[2,i]=as.numeric(se.1[i]) #SE
  }
  
  
#4.D. Calculate p value
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_fql_part2_pe[1,]
  se = effect_bi_fql_part2_pe[2,]

  p_value_fql_pe = p_value(mean, se)
  as.numeric((p_value_fql_pe))
  #[1] 1.208603e-03 1.322359e-06 5.733031e-07 8.461525e-01 5.434824e-02
  #[6] 1.152658e-02 4.174439e-14 0.000000e+00 6.372680e-14 3.317271e-08
  #[11] 1.567539e-07 9.264410e-05 1.609184e-04 1.132650e-03 2.641373e-04
  #[16] 2.975377e-07 6.664090e-08 1.935046e-02 5.510725e-01 5.947849e-01
  #[21] 2.997186e-01 2.399205e-10 4.839273e-01 4.118461e-02 0.000000e+00
