#Package loading
#install.packages("Rtools")
#install.packages("remotes")
#remotes::install_github("yimshi/fql")
library(dplyr)
library(fql)

###############################################################################

#Data input
meps_chapter2 = read.csv("/Users/lexy/Library/CloudStorage/OneDrive-WashingtonUniversityinSt.Louis/Desktop/202409_MEPS/05_GitHub/chapter2/meps_chapter2.csv")

variable=c("HIBP","CHD","STRK","EMPH","CHBRON","CHOL",
           "CANCER","DIAB","JTPAIN","ARTH","ASTH",
           "MALE","RACE_HISPANIC","RACE_BLACK","RACE_OTHER",
           "AGE_18_24","AGE_25_34","AGE_35_44","AGE_45_54","AGE_65_74","AGE_75_85",
           "REGION_NORTHEAST","REGION_MIDWEST","REGION_WEST","IPDIS","TOTEXP17")


#Keep related variables
data = meps_chapter2[,variable] #18575 26


#FQL function
fqlresult = fql(TOTEXP17~., data)

fqlresult[[1]] #coefficient

data_pred = data%>%
  mutate(pred = as.numeric(fqlresult$muest),
         resid = TOTEXP17-pred)


#mean residual: -676.8933
mean(data_pred$resid)     

#mean absolute residual: 6734.699
mean(abs(data_pred$resid))

###############################################################################

#Cross-Validation for FQL
cv_fold = read.csv("/Users/lexy/Library/CloudStorage/OneDrive-WashingtonUniversityinSt.Louis/Desktop/202409_MEPS/05_GitHub/chapter2/cv_fold.csv")


#Calculate CV residual  
for (j in 1:5){
  train = cv_fold[cv_fold$fold!=j,]
  
  test = cv_fold[cv_fold$fold==j,]
  
  fqlresult = fql(TOTEXP17~., data = train[,variable])
  
  for (i in 1:nrow(test)){
    test$pred[i] =  exp(fqlresult[[1]]$coefficients[1]+
                        fqlresult[[1]]$coefficients[2]*test$HIBP[i] + 
                        fqlresult[[1]]$coefficients[3]*test$CHD[i] + 
                        fqlresult[[1]]$coefficients[4]*test$STRK[i] + 
                        fqlresult[[1]]$coefficients[5]*test$EMPH[i] + 
                        fqlresult[[1]]$coefficients[6]*test$CHBRON[i] + 
                        fqlresult[[1]]$coefficients[7]*test$CHOL[i] + 
                        fqlresult[[1]]$coefficients[8]*test$CANCER[i] + 
                        fqlresult[[1]]$coefficients[9]*test$DIAB[i] + 
                        fqlresult[[1]]$coefficients[10]*test$JTPAIN[i] + 
                        fqlresult[[1]]$coefficients[11]*test$ARTH[i] + 
                        fqlresult[[1]]$coefficients[12]*test$ASTH[i] +
                        fqlresult[[1]]$coefficients[13]*test$MALE[i] + 
                        fqlresult[[1]]$coefficients[14]*test$RACE_HISPANIC[i] + 
                        fqlresult[[1]]$coefficients[15]*test$RACE_BLACK[i] +
                        fqlresult[[1]]$coefficients[16]*test$RACE_OTHER[i]+
                        fqlresult[[1]]$coefficients[17]*test$AGE_18_24[i] + 
                        fqlresult[[1]]$coefficients[18]*test$AGE_25_34[i] + 
                        fqlresult[[1]]$coefficients[19]*test$AGE_35_44[i] +
                        fqlresult[[1]]$coefficients[20]*test$AGE_45_54[i] + 
                        fqlresult[[1]]$coefficients[21]*test$AGE_65_74[i] + 
                        fqlresult[[1]]$coefficients[22]*test$AGE_75_85[i] +
                        fqlresult[[1]]$coefficients[23]*test$REGION_NORTHEAST[i] +
                        fqlresult[[1]]$coefficients[24]*test$REGION_MIDWEST[i] + 
                        fqlresult[[1]]$coefficients[25]*test$REGION_WEST[i]+
                        fqlresult[[1]]$coefficients[26]*test$IPDIS[i])
                        }
  if (j==1){
    fql_cv = test
  }
  else{
    fql_cv = rbind(fql_cv,test)
  }
}

fql_cv$resid = fql_cv$TOTEXP17-fql_cv$pred

#mean residual: -703.0333
mean(fql_cv$resid)

#mean absolute residual: 6767.882
mean(abs(fql_cv$resid))

###############################################################################

#Incremental Effect for FQL
beta.0 = 8.086
beta.1 = c(0.118,0.323,0.291,0.041,0.053,0.088,0.494,0.495,0.273,0.222,0.241,
           -0.163,-0.198,-0.144,-0.156,
           -0.490,-0.334,-0.150,-0.031,-0.043,0.031,
           0.320,0.025,0.075,1.654)

se.0 = 0.061
se.1 = c(0.043,0.061,0.066,0.074,0.082,0.044,0.072,0.047,0.042,0.047,0.052,
         0.037,0.059,0.050,0.060,
         0.097,0.068,0.070,0.058,0.053,0.061,
         0.054,0.044,0.053,0.044)


#Set up incremental effect function
int_fql = function(beta_0,beta){
  eqn = exp(beta)-exp(beta_0)
  return(eqn)
}


#Set up variance of marginal effect function by using delta method
n=length(beta.1)
effect_bi_fql_part2=matrix(0,nrow=2,ncol=n)

int_fql_var = function(beta,se_beta){
  derivative_beta = exp(2*beta)
  var_beta = se_beta^2
  variance = derivative_beta*var_beta
  se = sqrt(variance)
  return(se)
}


#Calculate
for (i in 1:n) 
{
  result = int_fql(beta_0 =  beta.0,
                   beta = beta.0 + beta.1[i])
  
  result_var = int_fql_var(beta = beta.0 + beta.1[i],
                           se_beta = se.1[i])
  effect_bi_fql_part2[1,i]=as.numeric(result) #incremental effect
  effect_bi_fql_part2[2,i]=as.numeric(result_var) #SE
}


#Examine
colnames(effect_bi_fql_part2) = variable[!variable %in% "TOTEXP17"]
row.names(effect_bi_fql_part2) = c("Estimate","SE")
effect_bi_fql_part2
#         HIBP       CHD      STRK     EMPH    CHBRON     CHOL    CANCER
#Estimate 406.8764 1238.6041 1097.2846 135.9635 176.8238 298.8388 2075.4386
#SE       157.1884  273.7235  286.8328 250.4627 280.8902 156.0902  383.3356

#         DIAB    JTPAIN     ARTH     ASTH      MALE RACE_HISPANIC RACE_BLACK
#Estimate 2080.7654 1019.7573 807.5256 885.3301 -488.6281     -583.5585   -435.686
#SE        250.4833  179.2738 190.6410 214.9678  102.1214      157.2414    140.649

#           RACE_OTHER  AGE_18_24 AGE_25_34 AGE_35_44 AGE_45_54 AGE_65_74 AGE_75_85
#Estimate  -469.2401 -1258.4478 -922.4467 -452.5134 -99.16369 -136.7319  102.2859
#SE         166.7656   193.0513  158.1830  195.7307 182.67118  164.9326  204.4081

#         REGION_NORTHEAST REGION_MIDWEST REGION_WEST      IPDIS
#Estimate        1225.1625       82.24039    253.0197 13734.8745
#SE               241.5868      146.55992    185.5894   747.2758

p_value = function(mean, se) {
  z_stat = mean / se
  p_value = 2 * (1 - pnorm(abs(z_stat)))
  return(p_value)
}

mean = effect_bi_fql_part2[1,]
se = effect_bi_fql_part2[2,]

p_value_fql = p_value(mean, se)
as.numeric(print(p_value_fql))
#[1] 9.640505e-03 6.039014e-06 1.304963e-04 5.872334e-01 5.290139e-01
#[6] 5.555304e-02 6.157854e-08 0.000000e+00 1.283351e-08 2.276955e-05
#[11] 3.814620e-05 1.711786e-06 2.062570e-04 1.950405e-03 4.896424e-03
#[16] 7.090795e-11 5.492578e-09 2.078222e-02 5.872307e-01 4.070949e-01
#[21] 6.167931e-01 3.950780e-07 5.747032e-01 1.727784e-01 0.000000e+00

###############################################################################           

#Partial Elasticity for FQL
n=length(beta.1)
effect_bi_fql_part2_pe=matrix(0,nrow=2,ncol=n)


#Set up marginal effect function
beta.1


#Set up variance of marginal effect function by using delta method
se.1


#Calculate
for (i in 1:n) 
{
  effect_bi_fql_part2_pe[1,i]=as.numeric(beta.1[i]) #Incremental effect
  effect_bi_fql_part2_pe[2,i]=as.numeric(se.1[i]) #SE
}

p_value = function(mean, se) {
  z_stat = mean / se
  p_value = 2 * (1 - pnorm(abs(z_stat)))
  return(p_value)
}

mean = effect_bi_fql_part2_pe[1,]
se = effect_bi_fql_part2_pe[2,]

p_value_fql_pe = p_value(mean, se)
as.numeric(print(p_value_fql_pe))
#[1] 6.066115e-03 1.189630e-07 1.038054e-05 5.795419e-01 5.180582e-01
#[6] 4.550026e-02 6.832757e-12 0.000000e+00 8.031997e-11 2.319292e-06
#[11] 3.576017e-06 1.055862e-05 7.909796e-04 3.976752e-03 9.322376e-03
#[16] 4.382475e-07 9.026033e-07 3.212457e-02 5.930076e-01 4.171815e-01
#[21] 6.113154e-01 3.105425e-09 5.699115e-01 1.570408e-01 0.000000e+00

