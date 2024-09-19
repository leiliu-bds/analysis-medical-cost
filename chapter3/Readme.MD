## This is for Chapter 3 of the book "Statistical and Econometric Methods for Analysis of Medical Cost Data."

## Outlines and Locations for Codes:
- Data Preparation:
  - Data structure for cost
    - File: [MEPS_data.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter1/MEPS data.sas)
    - Description: This script filters the dataset to include only observations with zero-inflated, nonnegative continuous cost data. It also prepares the data for 5-fold cross-validation, assigning each observation to one of the 5 folds.  

- Modeling with different distributions:
  - Log normal distribution
    - Files: 
      - [chapter3_1pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_1pm_log-normal.sas):  Implements a one-part model (1PM) using the log-normal distribution where the outcome is log(cost + 1). This script includes the calculation of residuals.
      - [chapter3_2pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_log-normal.sas): Implements a two-part model (2PM) using the log-normal distribution. The script includes the calculation of residuals, cross-validated (CV) residuals, incremental effect, and partial elasticity.
      - [chapter3_4m_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_4pm_log-normal.sas): Implements a four-part model (4PM) using the log-normal distribution, including the calculation of residuals.

  - Generalized Gamma distribution 
    - File: [chapter3_2pm_generalized-gamma.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_generalized-gamma.sas)
    - Description: This script fits a two-part model (2PM), where part two is modeled using the generalized gamma distribution. It includes the calculation of residuals, cross-validated residuals, incremental effect, and partial elasticity for the model.

  - Log-skew-normal distribution 
    - File: [chapter3_2pm_log-skew-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_log-skew-normal.sas)
    - Description: Implements a two-part model using the log-skew-normal distribution. The script includes the calculation of residuals, cross-validated residuals, incremental effect, and partial elasticity.

  - Box-Cox transformation
    - Files: 
      - [chapter3_2pm_box-cox.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_box-cox.sas): Handles model fitting for the two-part Box-Cox transformation model. The script also includes residuals, cross-validated residuals, and bootstrap resampling.
      - [chapter3_2pm_box-cox_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_box-cox_rate_of_change.R): Uses R to calculate the incremental effect and partial elasticity for the Box-Cox transformation model.

  - Marginalized 2PM
    - File: [chapter3_m2pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_m2pm_log-normal.sas) 
    - Discription: Implements the Marginalized Two-Part Model (M2PM) with part two modeled using the log-normal distribution. The script includes the calculation of residuals, cross-validated residuals, incremental effect, and partial elasticity.

