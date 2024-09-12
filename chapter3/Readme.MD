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

  - Generalized Gamma distribution 
    - File: [chapter3_2pm_generalized-gamma.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_generalized-gamma.sas)
    - Description: This script fits a two-part model with part two in a generalized gamma distribution. It calculates residuals, cross-validated residuals, incremental effect, and partial elasticity for the model.

  - Log-skew-normal distribution 
    - File: [chapter3_2pm_log-skew-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter3/chapter3_2pm_log-skew-normal.sas)
    - Description: Implements log-skew-normal distribution modeling. The script includes residuals, cross-validated residuals, incremental effect, and partial elasticity calculations.
