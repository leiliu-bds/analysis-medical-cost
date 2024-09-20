
## This is for Chapter 4 of the book "Statistical and Econometric Methods for Analysis of Medical Cost Data."

## Outlines and Locations for Codes:
- Data Preparation:
  - Data structure for correlated cost
    - File: [MEPS_data.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter1/MEPS_data.sas)
    - Description: This script include the observations with correlated cost data.

- Modeling with different distributions:
  - Log normal distribution
    - Files: 
      - [chapter4_r2pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_log-normal.sas): Implements a random effect two-part model using the log-normal distribution. The script includes the calculation of residuals.
      - [chapter4_r2pm_log-normal_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_log-normal_rate_of_change.R): Uses R to calculate the incremental effect and partial elasticity by stochastic integration for the random effect two-part model.

  - Generalized Gamma distribution 
    - File: 
      - [chapter4_r2pm_generalized-gamma.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_generalized-gamma.sas): This script fits a a random effect two-part model, where part two is modeled using the generalized gamma distribution. It includes the calculation of residuals for the model.
      - [chapter4_r2pm_generalized-gamma_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_generalized-gamma_rate_of_change.R): Uses R to calculate the incremental effect and partial elasticity by stochastic integration for the random effect two-part model.

  - Log-skew-normal distribution 
    - File: 
      - [chapter4_r2pm_log-skew-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_log-skew-normal.sas): Implements a two-part model using the log-skew-normal distribution. The script includes the calculation of residuals.
      - [chapter4_r2pm_log-skew-normal_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_log-skew-normal_rate_of_change.R): Uses R to calculate the incremental effect and partial elasticity by stochastic integration for the random effect two-part model.

  - Box-Cox transformation
    - Files: 
      - [chapter4_r2pm_box-cox.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_box-cox.sas): Handles model fitting for the random effects two-part Box-Cox transformation model. The script includes residuals.
      - [chapter4_r2pm_box-cox_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter4/chapter4_r2pm_box-cox_rate_of_change.R): Uses R to calculate the incremental effect and partial elasticity for the Box-Cox transformation model.

## Additional Notes
- For Log-Normal, Generalized Gamma, Log-Skew-Normal distributions and Box-Cox Transformation, scripts are available for both SAS and R:
  - Use SAS for residuals.
  - Use R for calculating the incremental effect and partial elasticity.
