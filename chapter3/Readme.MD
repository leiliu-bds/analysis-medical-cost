## This is for Chapter 3 of the book "Statistical and Econometric Methods for Analysis of Medical Cost Data."

## Outlines and Locations for Codes:
- Data Preparation:
  - Data structure for subset and cross-validation for cost
    - File: [chapter3_data.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_data.sas)
    - Description: This script subsets the dataset to include only observations with zero-inflated nonnegative continuous cost data. It also prepares the data for 5-fold cross-validation, assigning each observation to one of the 5 folds.  

- Modeling with different distributions:
  - Log normal distribution
    - Files: 
      - [chapter3_2pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_log-normal.sas): Implements log-normal distribution modeling. The script includes the calculation of residuals, cross-validated (CV) residuals, incremental effect, and partial elasticity.
      - [chapter3_1pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_1pm_log-normal.sas): Implements log-normal distribution modeling in a 1-Part Model taking log(cost+1) as outcome. The script includes the calculation of residuals.
      - [chapter3_4m_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_4pm_log-normal.sas): Implements log-normal distribution modeling in a 4-Part Model. The script includes the calculation of residuals.

  - Generalized Gamma distribution 
    - File: [chapter3_2pm_generalized-gamma.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_generalized-gamma.sas)
    - Description: This script fits a two-part model with part two in a generalized gamma distribution. It calculates residuals, cross-validated residuals, incremental effect, and partial elasticity for the model.

  - Log-skew-normal distribution 
    - File: [chapter3_2pm_log-skew-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_log-skew-normal.sas)
    - Description: Implements log-skew-normal distribution modeling. The script includes residuals, cross-validated residuals, incremental effect, and partial elasticity calculations.

  - Box-Cox transformation
    - Files: 
      - [chapter3_2pm_box-cox.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_box-cox.sas): Handles model fitting, residuals, CV residuals, and bootstrap resampling for the Box-Cox transformation. 
      - [chapter3_2pm_box-cox_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_box-cox_rate_of_change.R): Implements the calculation of incremental effect and partial elasticity using R for the Box-Cox transformation model.

  - Marginalized 2PM
    - File: [chapter3_m2pm_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_m2pm_log-normal.sas) 
    - Discription: Implements the Marginalized two-part model with part 2 in a log normal distribution and includes calculation of residuals, cross-validated residuals, incremental effect, and partial elasticity.
