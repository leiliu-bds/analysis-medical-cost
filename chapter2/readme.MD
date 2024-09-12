## This is for Chapter 2 of the book "Statistical and Econometric Methods for Analysis of Medical Cost Data."

## Outlines and Locations for Codes:
- Data Preparation:
  - Data structure for subset and cross-validation for positive cost 
    - File: [chapter2_data.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_data.sas)
    - Description: This script subsets the dataset to include only observations with positive total cost (TOTEXP17 > 0). It also prepares the data for 5-fold cross-validation, assigning each observation to one of the 5 folds.

- Modeling with different distributions:
  - Log normal distribution
    - File: [chapter2_log-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_log-normal.sas) 
    - Description: Implements log-normal distribution modeling. The script includes the calculation of residuals, cross-validated (CV) residuals, incremental effect, and partial elasticity.

  - Generalized Gamma distribution 
    - File: [chapter2_generalized-gamma.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_generalized-gamma.sas)
    - Description: This script fits a generalized gamma distribution model. It calculates residuals, cross-validated residuals, incremental effect, and partial elasticity for the model.

  - Log-skew-normal distribution 
    - File: [chapter2_log-skew-normal.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_log-skew-normal.sas)
    - Description: Implements log-skew-normal distribution modeling. The script includes residuals, cross-validated residuals, incremental effect, and partial elasticity calculations.

  - Box-Cox transformation
    - Files: 
      - [chapter2_box-cox.sas](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_box-cox.sas): Handles model fitting, residuals, CV residuals, and bootstrap resampling for the Box-Cox transformation. 
      - [chapter2_box-cox_rate_of_change.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_box-cox_rate_of_change.R): Implements the calculation of incremental effect and partial elasticity using R for the Box-Cox transformation model.

  - FQL (Flexible Quasi-Likelihood)
    - File: [chapter_fql.R](https://github.com/leiliu-bds/analysis-medical-cost/blob/main/chapter2/chapter2_fql.R) 
    - Discription: Implements the FQL model and includes calculation of residuals, cross-validated residuals, incremental effect, and partial elasticity.

## Additional Notes
- For Log-Normal, Generalized Gamma, and Log-Skew-Normal distributions, all the corresponding codes can be found and executed using SAS.
- For Box-Cox Transformation, scripts are available for both SAS and R:
  - Use SAS for residuals, CV residuals, and bootstrap.
  - Use R for calculating the incremental effect and partial elasticity.
- For the FQL model, the complete code is available in R.
