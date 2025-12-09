library(haven)
library(dplyr)
#install.packages("quantreg")
library(quantreg)
library(lqmm)


#Load data
meps = read_sas(".../h201.sas7bdat") /* Note: You can modify the "..." to specify the original SAS dataset for MEPS data */

meps_adult = as.data.frame(meps) %>% #31880
  filter(AGE17X>=18) %>% #23529
  mutate(BTOTEXP17 = ifelse(TOTEXP17>0,1,0),
         FAMID = paste0(DUID,FAMIDYR))%>%
  arrange(FAMID)%>%
  filter(HIBPDX>=0 & CHDDX>=0 & STRKDX>=0 & EMPHDX>=0 & CHBRON31>=0 & CHOLDX>=0 & 
           CANCERDX>=0 & DIABDX>=0 & JTPAIN31>=0 & ARTHDX>=0 & ASTHDX>=0)%>% #22613
  mutate(HIBP = ifelse(HIBPDX == 2, 0, 1),
         CHD = ifelse(CHDDX == 2, 0, 1),
         STRK = ifelse(STRKDX == 2, 0, 1),
         EMPH = ifelse(EMPHDX == 2, 0, 1),
         CHBRON = ifelse(CHBRON31 == 2, 0, 1),
         CHOL = ifelse(CHOLDX == 2, 0, 1),
         CANCER = ifelse(CANCERDX == 2, 0, 1),
         DIAB = ifelse(DIABDX == 2, 0, 1),
         JTPAIN = ifelse(JTPAIN31 == 2, 0, 1),
         ARTH = ifelse(ARTHDX == 2, 0, 1),
         ASTH = ifelse(ASTHDX == 2, 0, 1),
         
         MALE = ifelse(SEX == 2, 0, 1),
         RACE_HISPANIC = ifelse(RACETHX == 1, 1, 0),
         RACE_BLACK = ifelse(RACETHX == 3, 1, 0),
         RACE_OTHER = ifelse(RACETHX == 4 | RACETHX == 5, 1, 0),
         IPDIS = ifelse(IPDIS17 >= 1, 1, 0),
         
         AGE_18_24 = ifelse(AGE17X >= 18 & AGE17X < 25, 1, 0),
         AGE_25_34 = ifelse(AGE17X >= 25 & AGE17X < 35, 1, 0),
         AGE_35_44 = ifelse(AGE17X >= 35 & AGE17X < 45, 1, 0),
         AGE_45_54 = ifelse(AGE17X >= 45 & AGE17X < 55, 1, 0),
         AGE_65_74 = ifelse(AGE17X >= 65 & AGE17X < 75, 1, 0),
         AGE_75_85 = ifelse(AGE17X >= 75 & AGE17X <= 85, 1, 0),
         
         REGION_NORTHEAST = ifelse(REGION17 == 1, 1, 0),
         REGION_MIDWEST = ifelse(REGION17 == 2, 1, 0),
         REGION_WEST = ifelse(REGION17 == 4, 1, 0))

################################################################################
################################################################################

#Positive cost database;
meps_positive = meps_adult%>%filter(TOTEXP17>0)
set.seed(12345)

################################################################################
################################################################################

#τ = 0.25

fit.t25 = lqmm(
  TOTEXP17 ~ HIBP + CHD + STRK + EMPH + CHBRON + CHOL +
    CANCER + DIAB + JTPAIN + ARTH + ASTH + MALE +
    RACE_HISPANIC + RACE_BLACK + RACE_OTHER +
    AGE_18_24 + AGE_25_34 + AGE_35_44 + AGE_45_54 +
    AGE_65_74 + AGE_75_85 + REGION_NORTHEAST +
    REGION_MIDWEST + REGION_WEST + IPDIS,
  random = ~ 1,
  group  = FAMID,
  tau    = 0.25,
  data   = meps_positive
)

#Bootstrap for SE
boot.t25 = boot(fit.t25, R = 50, seed = 12345, startQR = FALSE)
summary(boot.t25)

fit.t25.summary = as.data.frame(summary(boot.t25))
write.csv(
  fit.t25.summary,
  ".../chapter7_meps/lqmm_bootstrap_t25_nk7.csv",
  row.names = FALSE
)

################################################################################
################################################################################

#τ = 0.50

fit.t50 = lqmm(
  TOTEXP17 ~ HIBP + CHD + STRK + EMPH + CHBRON + CHOL +
    CANCER + DIAB + JTPAIN + ARTH + ASTH + MALE +
    RACE_HISPANIC + RACE_BLACK + RACE_OTHER +
    AGE_18_24 + AGE_25_34 + AGE_35_44 + AGE_45_54 +
    AGE_65_74 + AGE_75_85 + REGION_NORTHEAST +
    REGION_MIDWEST + REGION_WEST + IPDIS,
  random = ~ 1,
  group  = FAMID,
  tau    = 0.50,
  data   = meps_positive
)

boot.t50 = boot(fit.t50, R = 50, seed = 12345, startQR = FALSE)
summary(boot.t50)

fit.t50.summary = as.data.frame(summary(boot.t50))
write.csv(
  fit.t50.summary,
  ".../chapter7_meps/lqmm_bootstrap_t50_nk7.csv",
  row.names = FALSE
)

################################################################################
################################################################################

#τ = 0.75

fit.t75 = lqmm(
  TOTEXP17 ~ HIBP + CHD + STRK + EMPH + CHBRON + CHOL +
    CANCER + DIAB + JTPAIN + ARTH + ASTH + MALE +
    RACE_HISPANIC + RACE_BLACK + RACE_OTHER +
    AGE_18_24 + AGE_25_34 + AGE_35_44 + AGE_45_54 +
    AGE_65_74 + AGE_75_85 + REGION_NORTHEAST +
    REGION_MIDWEST + REGION_WEST + IPDIS,
  random = ~ 1,
  group  = FAMID,
  tau    = 0.75,
  data   = meps_positive
)

boot.t75 = boot(fit.t75, R = 50, seed = 12345, startQR = FALSE)
summary(boot.t75)

fit.t75.summary = as.data.frame(summary(boot.t75))
write.csv(
  fit.t75.summary,
  ".../chapter7_meps/lqmm_bootstrap_t75_nk7.csv",
  row.names = FALSE
)

################################################################################
################################################################################

#τ = 0.90

fit.t90 = lqmm(
  TOTEXP17 ~ HIBP + CHD + STRK + EMPH + CHBRON + CHOL +
    CANCER + DIAB + JTPAIN + ARTH + ASTH + MALE +
    RACE_HISPANIC + RACE_BLACK + RACE_OTHER +
    AGE_18_24 + AGE_25_34 + AGE_35_44 + AGE_45_54 +
    AGE_65_74 + AGE_75_85 + REGION_NORTHEAST +
    REGION_MIDWEST + REGION_WEST + IPDIS,
  random = ~ 1,
  group  = FAMID,
  tau    = 0.90,
  data   = meps_positive
)

boot.t90 = boot(fit.t90, R = 50, seed = 12345, startQR = FALSE)
summary(boot.t90)

fit.t90.summary = as.data.frame(summary(boot.t90))
write.csv(
  fit.t90.summary,
  ".../chapter7_meps/lqmm_bootstrap_t90_nk7.csv",
  row.names = FALSE
)
################################################################################
################################################################################

#τ = 0.95

fit.t95 = lqmm(
  TOTEXP17 ~ HIBP + CHD + STRK + EMPH + CHBRON + CHOL +
    CANCER + DIAB + JTPAIN + ARTH + ASTH + MALE +
    RACE_HISPANIC + RACE_BLACK + RACE_OTHER +
    AGE_18_24 + AGE_25_34 + AGE_35_44 + AGE_45_54 +
    AGE_65_74 + AGE_75_85 + REGION_NORTHEAST +
    REGION_MIDWEST + REGION_WEST + IPDIS,
  random = ~ 1,
  group  = FAMID,
  tau    = 0.95,
  data   = meps_positive
)

boot.t95 = boot(fit.t95, R = 50, seed = 12345, startQR = FALSE)
summary(boot.t95)

fit.t95.summary = as.data.frame(summary(boot.t95))
write.csv(
  fit.t95.summary,
  ".../chapter7_meps/lqmm_bootstrap_t95_nk7.csv",
  row.names = FALSE
)
