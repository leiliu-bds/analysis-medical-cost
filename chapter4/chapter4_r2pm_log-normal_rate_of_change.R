library(dplyr)
library(haven)
library(janitor)
library(cubature)

#Incremental effect and partial elasticity for Log-Normal distribution

################################################################################

#1. Calculate incremental effect

#1.A. input parameters from SAS output
# These parameter can be collected using SAS code
  var.a=1.203
  var.b=0.228
  cov.ab=0.239
  dim.r=2   
  Sigma_matrix=matrix(c(var.a,cov.ab, cov.ab,var.b), 2, 2) 
  
  alpha.0=2.111
  alpha.1=c(0.893,0.689,0.189,-0.139,1.155,0.840,0.982,1.438,0.582,0.610,0.704,
            -1.069,-1.217,-0.865,-0.647,
            -0.333,-0.315,-0.274,-0.172,0.702,0.680,
            0.475,0.416,0.366,0) 
  
  beta.0=7.174
  beta.1=c(0.167,0.243,0.150,0.058,0.099,0.230,0.322,0.534,0.268,0.288,0.330,
           -0.252,-0.486,-0.338,-0.246,
           -0.558,-0.396,-0.272,-0.187,0.113,0.151,
           0.286,0.104,0.109,2.095)
  
  delta.0=0.466
  delta.1=c(0.033,-0.028,0.227,-0.014,0.052,-0.190,0.068,0.020,0.065,-0.078,-0.111,
            0.088,0.262,0.271,0.086,
            -0.009,0.058,0.085,0.113,-0.266,-0.191,
            0.033,-0.033, -0.040,-0.611)
  
  n=length(alpha.1)
  
################################################################################
  
#1.B. Method 1: Model setting using adaptIntegrate for 2 random effects
  #1.B.1. function for incremental effects for covariates with 2 random effects
  int_ln = function(x,alpha_0,alpha,beta_0,beta,delta_0,delta,Sigma_matrix)
  {
    a=x[1] #random effect in part 1
    b=x[2] #random effect in part 2
    
    # NOTE: det function is used to calculate the Determinant of a Matrix
    # NOTE: solve function is used to calculate x when a %*% x = b
    norm.den.ab = 1/ (2*pi*sqrt(det(Sigma_matrix)))*
      exp(-0.5*t(x)%*%solve(Sigma_matrix)%*%x)
    
    sigma = exp(delta/2)
    sigma_0 = exp(delta_0/2)
    
    eqn_1 = exp(alpha+a)/(1+exp(alpha+a))*
      exp(beta+b+sigma^2/2)
    
    eqn_0 = exp(alpha_0+a)/(1+exp(alpha_0+a))*
      exp(beta_0+b+sigma_0^2/2)
    
    int_ab = (eqn_1 - eqn_0)*norm.den.ab
    
    return(int_ab)
  }
  
  #Set lower/upper limits for a and b
  lower = c(-Inf, -Inf)  
  upper = c(Inf, Inf)  
  
  
  #1.B.2. function for incremental effects for covariates only with the second random effect
  int_ln_ipdis = function(b,beta_0,beta,delta_0,delta)
  {
    den.b = 1/sqrt(2*pi*(var.b))*exp(-0.5*b^2/var.b)
    
    sigma = exp(delta/2)
    sigma_0 = exp(delta_0/2)
    
    eqn_1 = exp(beta+b+sigma^2/2)
    
    eqn_0 = exp(beta_0+b+sigma_0^2/2)
    
    int_ab = (eqn_1 - eqn_0)*den.b
    
    return(int_ab)
  }
  
  
  #1.B.3. run the integrate functions
  effect_bi_ln=rep(0,n)
  for (i in 1:n) 
  { #when disease is i
    result = adaptIntegrate(int_ln, lower, upper, 
                            alpha_0 = alpha.0,
                            alpha = alpha.0 + alpha.1[i],
                            beta_0 = beta.0, 
                            beta = beta.0 + beta.1[i],
                            delta_0 = delta.0, 
                            delta = delta.0 + delta.1[i], 
                            Sigma_matrix)
    
    result_ipdis = integrate(int_ln_ipdis, 
                             -100, 100, 
                             beta_0 = beta.0, 
                             beta = beta.0 + beta.1[i],
                             delta_0 = delta.0, 
                             delta = delta.0 + delta.1[i])$value
    
    effect_bi_ln[i]=ifelse(i!=25,
                            as.numeric(result$integral),
                            as.numeric(result_ipdis))
  }
  
  round(effect_bi_ln,0)
  # [1]   862   918  1281    89   720   494  1632  2576  1285
  #[10]   925  1018  -836 -1030  -556  -657 -1291  -911  -593
  #[19]  -300   -37   209  1217   354   339 15071
  
###############################################################################    
  
#1.C. Method 2: Model setting using integrated for 2 random effects
  #1.C.1. function for incremental effects for covariates with 2 random effects
  int_ln2 = function(a,b,alpha_0,alpha,beta_0,beta,delta_0,delta,Sigma_matrix) 
  {
    norm.den.ab = 1/(2*pi*sqrt(det(Sigma_matrix)))*
      exp(-0.5*(a^2*solve(Sigma_matrix)[1, 1]+2*a*b*solve(Sigma_matrix)[1, 2]+b^2*solve(Sigma_matrix)[2, 2]))
    
    sigma = exp(delta/2)
    sigma_0 = exp(delta_0/2)

    eqn_1 = exp(alpha+a)/(1+exp(alpha+a))*
      exp(beta+b+sigma^2/2)
    
    eqn_0 = exp(alpha_0+a)/(1+exp(alpha_0+a))*
      exp(beta_0+b+sigma_0^2/2)
 
    int_ab2 = (eqn_1 - eqn_0)*norm.den.ab
    
    return(int_ab2)
  }
  
  
  #1.C.2. run the integrate functions
  effect_bi_ln2=rep(0,n)
  for (i in 1:n) 
  {
    result = integrate(Vectorize(function(b) 
    {integrate(function(a) int_ln2(a, b, 
                                    alpha_0 = alpha.0,
                                    alpha = alpha.0 + alpha.1[i],
                                    beta_0 = beta.0, 
                                    beta = beta.0 + beta.1[i],
                                    delta_0 = delta.0, 
                                    delta = delta.0 + delta.1[i],
                                    Sigma_matrix),-100, 100)$value
    }),
    -100, 100)
    
    result_ipdis = integrate(int_ln_ipdis, 
                             -100, 100, 
                             beta_0 = beta.0, 
                             beta = beta.0 + beta.1[i],
                             delta_0 = delta.0, 
                             delta = delta.0 + delta.1[i])$value
    
    effect_bi_ln2[i]=ifelse(i!=25,
                             as.numeric(result$value),
                             as.numeric(result_ipdis))
  }
  
  round(effect_bi_ln2,0)
  # [1]   862   918  1281    89   720   494  1632  2576  1285
  #[10]   925  1018  -836 -1030  -556  -657 -1291  -911  -593
  #[19]  -300   -37   209  1217   354   339 15071
