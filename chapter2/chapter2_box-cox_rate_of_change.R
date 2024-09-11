
#Incremental effect and partial elasticity for Box-Cox distribution

################################################################################

#1. Calculate the SE for incremental effect and partial elasticity using bootstrap


#1.A. Input data
  # This file can be created and downloaded by using the SAS code "chapter2_box-cox.sas"
  box_parameter_part2=read.csv("/.../part2_bootstrap_parameter.csv")
  
  beta = box_parameter_part2[,colnames(box_parameter_part2)[startsWith(colnames(box_parameter_part2),"b")]]
  beta.0=beta$b0
  beta.1=beta[,-1]
  
  delta = box_parameter_part2[,colnames(box_parameter_part2)[startsWith(colnames(box_parameter_part2),"d")]]
  delta.0=delta$d0
  delta.1=delta[,-1]
  
  gamma = box_parameter_part2[,colnames(box_parameter_part2)[startsWith(colnames(box_parameter_part2),"g")]]
  n=length(beta.1)  


#1.B. Set up integral function
  int_box = function(v,beta,delta,gamma) {
    density = 1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
    eqn = (gamma*v+1)^(1/gamma)
    logE = density*eqn
    return(logE)
  }
  

#1.C. Store integral results as 100*75 table
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
  effect_bi_box_part2_std[1,n]
  #[1] 112.65291248 191.45706531 267.45315380 259.17040346 291.35928446
  #[6]  86.18584637 194.29036595 190.88237317 118.17438967 121.47998646
  #[11] 132.62547122  79.65294323  90.53772977  84.75777264 112.61136297
  #[16] 132.69934119 121.78434357 126.04456506 130.91517089 119.89314152
  #[21] 153.84163960 136.04847371  99.71959827 104.22394159 652.48429489

  #SD for partial elasticity
  effect_bi_box_part2_std[n+1,2*n]
  #[26]   0.03259642   0.04930679   0.06475304   0.08037862   0.08339052
  #[31]   0.02596786   0.04161368   0.03632055   0.02781439   0.03223030
  #[36]   0.03248107   0.02828113   0.03852207   0.03141693   0.04472476
  #[41]   0.05761833   0.04512708   0.04493294   0.04673530   0.04094630
  #[46]   0.04904592   0.03532638   0.03223765   0.03252238   0.02859148

##############################################################################     

#2. Calculate incremental effect
  
#2.A. input parameters from SAS output
  # These parameter can be collected using SAS code
  beta.0=9.62
  beta.1=c(0.27,0.46,0.34,0.17,0.22,0.40,0.62,1.00,0.47,0.54,0.59,
           -0.42,-0.83,-0.59,-0.46,
           -0.93,-0.65,-0.44,-0.31,0.15,0.26,
           0.48,0.17,0.17,3.97) 
  
  delta.0=1.65
  delta.1=c(0.045,0.011,0.22,-0.014,0.061,-0.13,0.11,0.069,0.079,-0.026,-0.046,
            0.056,0.18,0.17,0.037,
            -0.088,-0.015,0.042,0.1,-0.21,-0.13,
            0.079,-0.021,-0.0085,-0.29)
  
  gamma=0.074
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
  #[1]   561.3769   841.1273  1197.2540   249.5185   508.6773
  #[6]   411.0970  1460.2455  2258.8528  1042.2716   909.0191
  #[11]   961.4739  -501.3215  -788.2759  -508.7169  -587.1489
  #[16] -1283.3282  -899.1724  -552.5706  -264.6594  -144.5108
  #[21]   169.1132  1063.0832   234.6708   261.2932 15537.9552

#2.D. Calculate p-value for incremental effect
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_box_part2
  se = effect_bi_box_part2_std[1:n]
  p_value(mean, se)

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
  #[1]  0.17158533  0.24722360  0.33590937  0.07991908  0.15667317
  #[6]  0.12846016  0.39669614  0.56143787  0.29827694  0.26474849
  #[11]  0.27808144 -0.18291440 -0.30495387 -0.18587968 -0.21788098
  #[16] -0.55846381 -0.35641772 -0.20364620 -0.09238723 -0.04938527
  #[21]  0.05485657  0.30341341  0.07533805  0.08353713  1.82147581

#3.B. Calculate p-value for partial elasticity
  p_value = function(mean, se) {
    z_stat = mean / se
    p_value = 2 * (1 - pnorm(abs(z_stat)))
    return(p_value)
  }
  
  mean = effect_bi_box_part2_pe
  se = effect_bi_box_part2_std[n+1:2*n]
  p_value(mean, se)

##############################################################################     

#4. Summarize incremental effect and partial elasticity for Box-Cox distribution

#Incremental effect
  effect_bi_box_part2
  effect_bi_box_part2_std[1:n]                                       #SE
  p_value(effect_bi_box_part2, effect_bi_box_part2_std[1:n])         #P-value

#Partial elasticity
  effect_bi_box_part2_pe
  effect_bi_box_part2_std[n+1:2*n]                                   #SE
  p_value(effect_bi_box_part2_pe, effect_bi_box_part2_std[n+1:2*n])  #P-calue
