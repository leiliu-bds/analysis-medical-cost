library(dplyr)
library(haven)
library(janitor)
library(cubature)

#Incremental effect and partial elasticity for Generalized-Gamma distribution

################################################################################

#1. Calculate incremental effect

#1.A. input parameters from SAS output
# These parameter can be collected using SAS code
  var.a=1.186
  var.b=0.220
  cov.ab=0.184
  dim.r=2   
  Sigma_matrix=matrix(c(var.a,cov.ab, cov.ab,var.b), 2, 2) 

  k=0.273

  alpha.0=2.110
  alpha.1=c(0.890,0.690,0.191,-0.136,1.157,0.839,0.987,1.444,0.583,0.608,0.706,
            -1.068,-1.219,-0.867,-0.654,
            -0.336,-0.315,-0.275,-0.172,0.698,0.679,
            0.470,0.413,0.365,0) 
  
  beta.0=7.356
  beta.1=c(0.166,0.240,0.165,0.062,0.101,0.213,0.324,0.532,0.270,0.279,0.319,
           -0.240,-0.461,-0.314,-0.238,
           -0.556,-0.388,-0.260,-0.173,0.091,0.135,
           0.285,0.098,0.103,2.041)
  
  delta.0=0.438 
  delta.1=c(0.018,-0.026,0.236,-0.003,0.054,-0.198,0.089,0.004,0.050,-0.082,-0.113,
            0.105,0.274,0.245,0.088,
            0.007,0.057,0.092,0.126,-0.252,-0.188,
            0.026,-0.051, -0.039,-0.608)
  
   n=length(alpha.1)

###############################################################################    
  
#1.B. Method 1: Model setting using adaptIntegrate for 2 random effects
  #1.B.1. function for incremental effects for covariates with 2 random effects
    int_gamma = function(x,alpha_0,alpha,beta_0,beta,delta_0,delta,k,Sigma_matrix)
    {
      a=x[1] #random effect in part 1
      b=x[2] #random effect in part 2
      
      # NOTE: det function is used to calculate the Determinant of a Matrix
      # NOTE: solve function is used to calculate x when a %*% x = b
      # norm.den.ab = 1/(sqrt((2*pi)^dim.r)*sqrt(det(Sigma_matrix)))*
       #            exp(-0.5*t(x)%*%solve(Sigma_matrix)%*%x)

      norm.den.ab = 1/(2*pi*sqrt(det(Sigma_matrix)))*
                    exp(-0.5*t(x)%*%solve(Sigma_matrix)%*%x)
      
      sigma = exp(delta/2)
      sigma_0 = exp(delta_0/2)
      
      eqn_1 = exp(alpha+a)/(1+exp(alpha+a))*
        exp(beta+b+sigma*log(k^2)/k+log(gamma(1/(k^2)+sigma/k))-log(gamma(1/(k^2))))
      
      eqn_0 = exp(alpha_0+a)/(1+exp(alpha_0+a))*
        exp(beta_0+b+sigma_0*log(k^2)/k+log(gamma(1/(k^2)+sigma_0/k))-log(gamma(1/(k^2))))
  
      int_ab = (eqn_1 - eqn_0)*norm.den.ab
      
      return(int_ab)
    }
      
    #Set lower/upper limits for a and b
    lower = c(-Inf, -Inf)  
    upper = c(Inf, Inf)    
    
  
  #1.B.2. function for incremental effects for covariates only with the second random effect
    int_gamma_ipdis = function(b,beta_0,beta,delta_0,delta)
    {
      den.b = 1/sqrt(2*pi*(var.b))*exp(-0.5*b^2/var.b)
      
      sigma = exp(delta/2)
      sigma_0 = exp(delta_0/2)
      
      eqn_1 =  exp(beta+b+sigma*log(k^2)/k+log(gamma(1/(k^2)+sigma/k))-log(gamma(1/(k^2))))
      
      eqn_0 =  exp(beta_0+b+sigma_0*log(k^2)/k+log(gamma(1/(k^2)+sigma_0/k))-log(gamma(1/(k^2))))
      
      int_ab = (eqn_1 - eqn_0)*den.b
      
      return(int_ab)
    }
    
    
    #1.B.3. run the integrate functions
    effect_bi_gamma=rep(0,n)
    for (i in 1:n) 
    { #when disease is i
      result = adaptIntegrate(int_gamma, lower, upper, 
                              alpha_0 = alpha.0,
                              alpha = alpha.0 + alpha.1[i],
                              beta_0 = beta.0, 
                              beta = beta.0 + beta.1[i],
                              delta_0 = delta.0, 
                              delta = delta.0 + delta.1[i], 
                              k,
                              Sigma_matrix)
      
      result_ipdis = integrate(int_gamma_ipdis, 
                                    -100, 100, 
                                    beta_0 = beta.0, 
                                    beta = beta.0 + beta.1[i],
                                    delta_0 = delta.0, 
                                    delta = delta.0 + delta.1[i])$value
      
      effect_bi_gamma[i]=ifelse(i!=25,
                                as.numeric(result$integral),
                                as.numeric(result_ipdis))
    }
    
  round(effect_bi_gamma,0)
  #[1]   753   874  1090   119   657   507  1540  2337  1125
  #[10]   879   985  -777 -1010  -645  -637 -1184  -857  -556
  #[19]  -282    50   255  1092   303   326 14719
  
###############################################################################    
  
#1.C. Method 2: Model setting using integrated for 2 random effects
  #1.C.1. function for incremental effects for covariates with 2 random effects
  int2 = function(a, b, alpha_0,alpha,beta_0,beta,delta_0,delta, k, Sigma_matrix) 
    {
    norm.den.ab = 1/(2*pi*sqrt(det(Sigma_matrix)))*
      exp(-0.5*(a^2*solve(Sigma_matrix)[1, 1]+2*a*b*solve(Sigma_matrix)[1, 2]+b^2*solve(Sigma_matrix)[2, 2]))
    
    sigma = exp(delta/2)
    sigma_0 = exp(delta_0/2)
    
    eqn_1 = exp(alpha+a)/(1+exp(alpha+a))*
      exp(beta+b+sigma*log(k^2)/k+log(gamma(1/(k^2)+sigma/k))-log(gamma(1/(k^2))))
    
    eqn_0 = exp(alpha_0+a)/(1+exp(alpha_0+a))*
      exp(beta_0+b+sigma_0*log(k^2)/k+log(gamma(1/(k^2)+sigma_0/k))-log(gamma(1/(k^2))))
    
    int_ab2 = (eqn_1 - eqn_0)*norm.den.ab
    
    return(int_ab2)
  }
  
  
  #2.B.2. run the integrate functions
  effect_bi_gamma2=rep(0,n)
  for (i in 1:n) 
  {
    result = integrate(Vectorize(function(b) 
      {integrate(function(a) int2(a, b, 
                                  alpha_0 = alpha.0,
                                  alpha = alpha.0 + alpha.1[i],
                                  beta_0 = beta.0, 
                                  beta = beta.0 + beta.1[i],
                                  delta_0 = delta.0, 
                                  delta = delta.0 + delta.1[i], 
                                  k,
                                  Sigma_matrix),-100, 100)$value
      }),
      -100, 100)
    
    result_ipdis = integrate(int_gamma_ipdis, 
                             -100, 100, 
                             beta_0 = beta.0, 
                             beta = beta.0 + beta.1[i],
                             delta_0 = delta.0, 
                             delta = delta.0 + delta.1[i])$value
    
    effect_bi_gamma2[i]=ifelse(i!=25,
                               as.numeric(result$value),
                               as.numeric(result_ipdis))
  }
  
  round(effect_bi_gamma2,0)
  # [1]   753   874  1090   119   657   507  1540  2337  1125
  # [10]   879   985  -777 -1010  -645  -637 -1184  -857  -556
  # [19]  -282    50   255  1092   303   326 14719
