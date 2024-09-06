
#Incremental effect for Box-Cox distribution

#parameters from SAS output
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


#Set up integral function
int_box = function(v,beta,delta,gamma) 
{
  density = 1/(exp(delta/2)*sqrt(2*pi))*exp(-(v-beta)^2/2/exp(delta/2)^2)
  eqn = (gamma*v+1)^(1/gamma)
  logE = density*eqn
  return(logE)
}


#Calculate incremental effect
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

#Incremental effect
effect_bi_box_part2
#[1]   561.3769   841.1273  1197.2540   249.5185   508.6773
#[6]   411.0970  1460.2455  2258.8528  1042.2716   909.0191
#[11]   961.4739  -501.3215  -788.2759  -508.7169  -587.1489
#[16] -1283.3282  -899.1724  -552.5706  -264.6594  -144.5108
#[21]   169.1132  1063.0832   234.6708   261.2932 15537.9552

##############################################################################     

#Partial Elasticity for Box-Cox distribution

#Calculate partial elasticity
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

