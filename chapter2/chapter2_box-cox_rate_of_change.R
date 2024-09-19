
#Incremental effect and partial elasticity for Box-Cox distribution

################################################################################

#1. Calculate the SE for incremental effect and partial elasticity using bootstrap


#1.A. Input data
  # This file can be created and downloaded by using the SAS code "chapter2_box-cox.sas"
  box_parameter_part2=read.csv("/.../part2_bootstrap_parameter.csv",
                               header=T)
  
  beta = box_parameter_part2[,colnames(box_parameter_part2)[startsWith(colnames(box_parameter_part2),"b")]]
  beta.0=beta$b0
  beta.1=beta[,-1]
  
  delta = box_parameter_part2[,colnames(box_parameter_part2)[startsWith(colnames(box_parameter_part2),"d")]]
  delta.0=delta$d0
  delta.1=delta[,-1]
  
  gamma = box_parameter_part2[,colnames(box_parameter_part2)[startsWith(colnames(box_parameter_part2),"g")]]
  n=length(beta.1)  

  list=c("HIBP","CHD","STRK","EMPH","CHBRON","CHOL",
         "CANCER","DIAB","JTPAIN","ARTH","ASTH",
         "MALE","RACE_HISPANIC","RACE_BLACK","RACE_OTHER",
         "AGE_18_24","AGE_25_34","AGE_35_44","AGE_45_54","AGE_65_74","AGE_75_85",
         "REGION_NORTHEAST","REGION_MIDWEST","REGION_WEST","IPDIS")
  
  
#1.B. Set up integral function
  int_box = function(v,beta,delta,gamma) {
    density = 1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
    eqn = (gamma*v+1)^(1/gamma)
    Eqn = density*eqn
    return(Eqn)
  }

#1.C. Store integral results as 100*50 table
  effect_bi_box_part2_boot=matrix(0,ncol = n*2,nrow = 100)

  for (j in 1:100){
    for (i in 1:n)  {
      result_1 = integrate(int_box,-10,Inf,
                           beta = beta.0[j] + beta.1[j,i],
                           delta = delta.0[j] + delta.1[j,i], 
                           gamma = gamma[j])
      
      result_0 = integrate(int_box,-10,Inf,
                           beta = beta.0[j] ,
                           delta = delta.0[j], 
                           gamma = gamma[j])
  
      #first 25 columns are incremental effect: E_1-E_0
      effect_bi_box_part2_boot[j,i]=(as.numeric(result_1$value))-(as.numeric(result_0$value))
      
      #second 25 columns are the partial elasticity: log(E_1/E_0)
      effect_bi_box_part2_boot[j,i+25]=log(as.numeric(result_1$value))-log(as.numeric(result_0$value))
    }
  }
  
  colnames(effect_bi_box_part2_boot) = c(paste0(list,rep(c("difference","_logratio"),each=n)))


#1.D. Calculate std for incremental effect and partial elasticity
  effect_bi_box_part2_std = rep(0,2*n)
  
  for (i in 1:(2*n)) {
    effect_bi_box_part2_std[i]=sd(effect_bi_box_part2_boot[,i])
  }

  #SD for incremental effect
  effect_bi_box_part2_std[1:25]
  #[1] 101.25556 209.19010 294.10741 228.27957 257.62728  88.67341 205.29007
  #[8] 201.49588 119.36761 119.05508 124.98423  67.16926  92.69458 100.54226
  #[15] 117.77302 141.10681 136.92142 125.57389 117.17720 117.55268 139.82849
  #[22] 134.90007  97.20778 110.15005 775.89744
  
  #SD for partial elasticity
  effect_bi_box_part2_std[26:50]
  #[1] 0.02977188 0.05240751 0.06902949 0.07076865 0.07499678 0.02689382
  #[7] 0.04757040 0.03769890 0.03007140 0.03108089 0.03108468 0.02553350
  #[13] 0.03848074 0.03783271 0.04710749 0.06067299 0.05195325 0.04499678
  #[19] 0.04129478 0.04031301 0.04518071 0.03363686 0.03084853 0.03446923
  #[25] 0.03293531
  
##############################################################################     

#2. Calculate incremental effect
  
#2.A. input parameters from SAS output
  # These parameter can be collected using SAS code
  beta.0=9.631
  beta.1=c(0.272,0.461,0.339,0.171,0.217,0.405,0.624,1.001,0.476,0.542,0.589,
           -0.418,-0.827,-0.589,-0.456,
           -0.927,-0.652,-0.443,-0.321,0.155,0.259,
           0.48,0.172,0.172,3.986) 
  
  delta.0=1.660
  delta.1=c(0.045,0.008,0.218,-0.013,0.064,-0.131,0.114,0.069,0.080,-0.027,-0.046,
            0.055,0.177,0.173,0.036,
            -0.088,-0.015,0.042,0.098,-0.205,-0.125,
            0.078,-0.021,-0.009,-0.294)
  
  gamma=0.075
  n=length(beta.1)


#2.B. Set up integral function
  int_box = function(v,beta,delta,gamma){
    density = 1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
    eqn = (gamma*v+1)^(1/gamma)
    logE = density*eqn
    return(logE)
  }


#2.C. Calculate incremental effect
  effect_bi_box_part2=rep(0,n) 
  for (i in 1:n) {
    result_1 = integrate(int_box,-10,Inf,
                         beta = beta.0 + beta.1[i],
                         delta = delta.0 + delta.1[i], 
                         gamma = gamma)
    
    result_0 = integrate(int_box,-10,Inf,
                         beta = beta.0 ,
                         delta = delta.0, 
                         gamma = gamma)
    
    effect_bi_box_part2[i]=(as.numeric(result_1$value))-(as.numeric(result_0$value))
  }

  effect_bi_box_part2
  #[1]   550.5005   813.5089  1157.9015   246.7588   497.5158   406.6288
  #[7]  1442.4818  2199.1788  1029.7692   886.3147   933.7171  -487.8221
  #[13]  -770.2354  -488.2401  -569.1435 -1250.3721  -879.5634  -542.5176
  #[19]  -276.9641  -126.3751   171.7975  1032.3929   231.8305   256.7847
  #[25] 15109.1076
  
#2.D. Calculate p-value for incremental effect
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_box_part2
  se =   effect_bi_box_part2_std[1:25]
  p_value_box_part2 = p_value(mean, se)

##############################################################################     

#3. Calculate partial elasticity for Box-Cox distribution

#3.A. Calculate partial elasticity
  effect_bi_box_part2_pe=rep(0,n)
  
  for (i in 1:n)  {
    result_1 = integrate(int_box,-10,Inf,
                         beta = beta.0 + beta.1[i],
                         delta = delta.0 + delta.1[i], 
                         gamma = gamma)
    
    result_0 = integrate(int_box,-10,Inf,
                         beta = beta.0 ,
                         delta = delta.0, 
                         gamma = gamma)
    
    effect_bi_box_part2_pe[i]=log(as.numeric(result_1$value))-
                                  log(as.numeric(result_0$value))
  }
    
  effect_bi_box_part2_pe
  #[1]  0.17146921  0.24405295  0.33176742  0.08051312  0.15618684  0.12941580
  #[7]  0.39885843  0.55803235  0.30002478  0.26324825  0.27555072 -0.18122324
  #[13] -0.30341661 -0.18139350 -0.21490516 -0.55312114 -0.35504160 -0.20375181
  #[19] -0.09883312 -0.04388858  0.05673272  0.30068497  0.07582221  0.08365124
  #[25]  1.81380349

#3.B. Calculate p-value for partial elasticity
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_box_part2_pe
  se = effect_bi_box_part2_std[26:50]
  p_value_box_part2_pe = p_value(mean, se)

##############################################################################     

#4. Summarize incremental effect and partial elasticity for Box-Cox distribution

#Incremental effect
  effect_bi_box_part2
  effect_bi_box_part2_std[1:25]                                   
  p_value_box_part2    

#Partial elasticity
  effect_bi_box_part2_pe
  effect_bi_box_part2_std[26:50]                                  
  p_value_box_part2_pe            
