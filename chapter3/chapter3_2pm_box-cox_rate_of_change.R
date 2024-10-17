library(dplyr)
library(haven)
library(janitor)

#Incremental effect and partial elasticity for Box-Cox distribution

################################################################################

#1. Calculate the SE for incremental effect and partial elasticity using bootstrap


#1.A. Input data
# This file can be created and downloaded by using the SAS code "chapter3_box-cox.sas"
  box_parameter=read.csv("/.../bootstrap_parameter.csv",
                         header=T)[-1,]
  
  alpha = box_parameter[,colnames(box_parameter)[startsWith(colnames(box_parameter),"a")]]
  alpha.0=alpha$a0
  alpha.1=as.data.frame(c(alpha[,-1],a6=0))

  beta = box_parameter[,colnames(box_parameter)[startsWith(colnames(box_parameter),"b")]]
  beta.0=beta$b0
  beta.1=beta[,-1]
  
  delta = box_parameter[,colnames(box_parameter)[startsWith(colnames(box_parameter),"d")]]
  delta.0=delta$d0
  delta.1=delta[,-1]
  
  gamma=box_parameter[,colnames(box_parameter)[startsWith(colnames(box_parameter),"g")]]
  n=length(alpha.1)  

  list=c("HIBP","CHD","STRK","EMPH","CHBRON","CHOL",
         "CANCER","DIAB","JTPAIN","ARTH","ASTH",
         "MALE","RACE_HISPANIC","RACE_BLACK","RACE_OTHER",
         "AGE_18_24","AGE_25_34","AGE_35_44","AGE_45_54","AGE_65_74","AGE_75_85",
         "REGION_NORTHEAST","REGION_MIDWEST","REGION_WEST","IPDIS")

  
#1.B. Set up integral function
  int_box = function(v,alpha,beta,delta,gamma) 
  {
    density =1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
    eqn =  exp(alpha)/(1+exp(alpha))*(gamma*v+1)^(1/gamma)
    Eqn = density*eqn
    return(Eqn)
  }
  
  int_ipdis = function(v,beta,delta,gamma) 
  {
    density = 1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
    eqn = (gamma*v+1)^(1/gamma)
    Eqn = density*eqn
    return(Eqn)
  }
  
  
#1.C. Store integral results as 100*50 table
  #first 25 columns are the E_1-E_0
  #second 25 columns are log(E_1/E_0)
  effect_bi_box_2pm_boot=matrix(0,ncol = n*2,nrow = 100)
  
  for (j in 1:100){
    for (i in 1:n)  {
      result_1 = integrate(int_box,-10,Inf,
                           alpha = alpha.0[j] + alpha.1[j,i],
                           beta = beta.0[j] + beta.1[j,i],
                           delta = delta.0[j] + delta.1[j,i], 
                           gamma = gamma[j])
      
      result_0 = integrate(int_box,-10,Inf,
                           alpha = alpha.0[j],
                           beta = beta.0[j] ,
                           delta = delta.0[j], 
                           gamma = gamma[j])
      
      result_ipdis_1 = integrate(int_ipdis,-10,Inf,
                               beta = beta.0[j] + beta.1[j,25],
                               delta = delta.0[j] + delta.1[j,25], 
                               gamma = gamma[j])
      
      result_ipdis_0 = integrate(int_ipdis,-10,Inf,
                                 beta = beta.0[j],
                                 delta = delta.0[j], 
                                 gamma = gamma[j])
      
      #first 25 columns are incremental effect: E_1-E_0
      effect_bi_box_2pm_boot[j,i]=ifelse(i!=25,
                                          (as.numeric(result_1$value))-(as.numeric(result_0$value)),
                                          (as.numeric(result_ipdis_1$value))-(as.numeric(result_ipdis_0$value)))
 
      #second 25 columns are the partial elasticity: log(E_1/E_0)
      effect_bi_box_2pm_boot[j,i+25]=ifelse(i!=25,
                                             log(as.numeric(result_1$value))-log(as.numeric(result_0$value)),
                                             log(as.numeric(result_ipdis_1$value))-log(as.numeric(result_ipdis_0$value)))
    }
  }
  
  colnames(effect_bi_box_2pm_boot) = c(paste0(list,rep(c("_difference","_logratio"),each=n)))
  
  
#1.D. Calculate std for incremental effect and partial elasticity
  effect_bi_box_2pm_std = rep(0,2*n)
  
  for (i in 1:(2*n)) 
  {
    effect_bi_box_2pm_std[i]=sd(effect_bi_box_2pm_boot[,i])
  }
  
  #SD for incremental effect
  effect_bi_box_2pm_std[1:25]
  #[1]  99.53019 223.81786 239.18362 205.24957 276.97991  85.17090 164.32690
  #[8] 190.48935  98.98255 114.29922 128.21252  57.78406  71.50234  79.97374
  #[15] 105.92639 114.02177  96.20275 111.37867 104.17649 100.08962 133.01847
  #[22] 130.22420  93.64067  97.28064 681.04336
  
  #SD for partial elasticity
  effect_bi_box_2pm_std[26:50]
  #[1] 0.03068147 0.06434157 0.06659614 0.08049009 0.08649318 0.02834180
  #[7] 0.04022670 0.03465747 0.02749707 0.03486838 0.03579459 0.02934172
  #[13] 0.04178134 0.04010546 0.05404706 0.06007824 0.04442180 0.04929362
  #[19] 0.04389394 0.03960707 0.04776764 0.03633064 0.03464770 0.03500843
  #[25] 0.03210317
  
###############################################################################     

  #2. Calculate incremental effect
  
  #2.A. input parameters from SAS output
  # These parameter can be collected using SAS code
  alpha.0 = 1.6673
  alpha.1 = c(0.7858,0.6146,0.1941,-0.1778,1.1163,0.7837,0.9674,1.2739,0.5256,0.5926, 0.6283,
              -0.8864,-1.0715,-0.7647,-0.6110,
              -0.2496,-0.2145,-0.1906,-0.1053,0.6245,0.6345,
              0.3887,0.3523,0.2967,0)
  
  beta.0 = 9.6013
  beta.1 = c(0.2718,0.4658,0.3305,0.1675,0.2067,0.4013,0.6107,0.9930,0.4716,0.5383,0.5863,
             -0.4150,-0.8247,-0.5859,-0.4592,
             -0.9205,-0.6464,-0.4363,-0.3102,0.1615,0.2765,
             0.4874,0.1673,0.1759,3.9632) 
  
  delta.0 = 1.6552
  delta.1 = c(0.04188,0.01112,0.2148,-0.01714,0.05934,-0.1318,0.1133,0.06899,0.08282,-0.02708,-0.04496,
              0.05882,0.1815,0.1768,0.03862,
              -0.09606,-0.02213,0.02706,0.08971,-0.2131,-0.1339,
              0.07893,-0.02034,-0.01092,-0.2980)
  
  gamma = 0.07403
  n=length(beta.1)
  
  
#2.B. Set up integral function
  int_box = function(v,alpha,beta,delta,gamma) 
  {
    density = 1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
    eqn = exp(alpha)/(1+exp(alpha))*(gamma*v+1)^(1/gamma)
    Eqn = density*eqn
    return(Eqn)
  }
 
   
#2.C. Calculate incremental effect
  effect_bi_box_2pm=rep(0,n)
  for (i in 1:n)  {
    result_1 = integrate(int_box,-10,Inf,
                         alpha = alpha.0 + alpha.1[i],
                         beta = beta.0 + beta.1[i],
                         delta = delta.0 + delta.1[i], 
                         gamma = gamma)
    
    result_0 = integrate(int_box,-10,Inf,
                         alpha = alpha.0,
                         beta = beta.0,
                         delta = delta.0, 
                         gamma = gamma)
    
    result_ipdis_1 = integrate(int_ipdis,-10,Inf,
                               beta = beta.0 + beta.1[25],
                               delta = delta.0 + delta.1[25], 
                               gamma = gamma)
    
    result_ipdis_0 = integrate(int_ipdis,-10,Inf,
                               beta = beta.0,
                               delta = delta.0, 
                               gamma = gamma)
    
    effect_bi_box_2pm[i]=ifelse(i!=25,
                                (as.numeric(result_1$value))-(as.numeric(result_0$value)),
                                (as.numeric(result_ipdis_1$value))-(as.numeric(result_ipdis_0$value)))
  }
  
  effect_bi_box_2pm
  #[1]   746.66259   965.43947  1071.72045   118.06775   749.37302
  #[6]   609.68287  1617.78720  2437.09608  1118.33388  1002.75743
  #[11]  1062.49373  -795.46808 -1082.85186  -730.86166  -724.87323
  #[16] -1134.16215  -820.30425  -544.29296  -277.15855    78.68313
  #[21]   371.57045  1085.07187   326.62009   338.06125 15295.90296
  
  
#2.D. Calculate p-value for incremental effect
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_box_2pm
  se = effect_bi_box_2pm_std[1:25]
  p_value_box_2pm = p_value(mean, se)

##############################################################################       

  #3. Calculate partial elasticity for Box-Cox distribution
  
  #3.A. Calculate partial elasticity
  effect_bi_box_2pm_pe=rep(0,n)
  
  for (i in 1:n)  {
    result_1 = integrate(int_box,-10,Inf,
                         alpha = alpha.0 + alpha.1[i],
                         beta = beta.0 + beta.1[i],
                         delta = delta.0 + delta.1[i], 
                         gamma = gamma)
    
    result_0 = integrate(int_box,-10,Inf,
                         alpha = alpha.0,
                         beta = beta.0,
                         delta = delta.0, 
                         gamma = gamma)
    
    result_ipdis_1 = integrate(int_ipdis,-10,Inf,
                               beta = beta.0 + beta.1[25],
                               delta = delta.0 + delta.1[25], 
                               gamma = gamma)
    
    result_ipdis_0 = integrate(int_ipdis,-10,Inf,
                               beta = beta.0,
                               delta = delta.0, 
                               gamma = gamma)
    
    effect_bi_box_2pm_pe[i]=ifelse(i!=25,log(as.numeric(result_1$value))-log(as.numeric(result_0$value)),
                                    log(as.numeric(result_ipdis_1$value))-log(as.numeric(result_ipdis_0$value)))
  }
  
  effect_bi_box_2pm_pe
  #[1]  0.26091877  0.32604226  0.35621116  0.04606385  0.26175209  0.21787362
  #[7]  0.49831089  0.67958902  0.36916104  0.33673932  0.35362785 -0.38215236
  #[13] -0.56625644 -0.34504756 -0.34167699 -0.60301461 -0.39679085 -0.24503325
  #[19] -0.11727783  0.03093267  0.13833314  0.35993755  0.12258091  0.12661391
  #[25]  1.81441846
  
  
#3.B. Calculate p-value for partial elasticity
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_box_2pm_pe
  se = effect_bi_box_2pm_std[26:50]
  p_value_box_2pm_pe = p_value(mean, se)
  
##############################################################################     

#4. Summarize incremental effect and partial elasticity for Box-Cox distribution
  
  #Incremental effect
  effect_bi_box_2pm
  effect_bi_box_2pm_std[1:25]                                   
  p_value_box_2pm    
  
  #Partial elasticity
  effect_bi_box_2pm_pe
  effect_bi_box_2pm_std[26:50]                                  
  p_value_box_2pm_pe            
