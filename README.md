# Forecasting Trends in Pharmaceutical and Antidepressant Markets
## Project Overview
This project undertakes a comprehensive time series study to uncover dynamics within the global pharmaceutical sector, specifically focusing on the utilization and expenditure of antidepressants. The study analyzes temporal shifts to shape healthcare policy, optimize market operations, and inform future demand forecasting.

## Methodology
Temporal Coverage: Cross-country data (2010–2024) and US-specific claims data (2019–2023).
Validation Strategy: 12-year training period (2010–2021) with a 3-year holdout test period (2022–2024).
Software Environment: R (packages: forecast, prophet, stats, ggplot2) and Microsoft Excel.
Preprocessing: Missing values were treated using linear interpolation for gaps ≤2 years.

## Analytics & Findings
#### Exploratory Data Analysis (EDA) & Market Growth
Using Compound Annual Growth Rate (CAGR), we identified the most dynamic markets:
Latvia: 7.17% CAGR.
Chile: 6.22% CAGR.
United States: Maintains the highest absolute per-capita spending with a 4.51% CAGR.

#### Time Series Decomposition
STL (Seasonal and Trend decomposition using Loess) was applied to the US market.
Trend: A smooth, monotonically increasing pattern confirmed a strong positive trend1313.
Stationarity: The series was identified as non-stationary, necessitating second-order differencing ($d=2$) for ARIMA modeling

#### Drug-Specific Trend Analysis (US Market)
Analysis of N06A class antidepressants (2019–2023) revealed:
Market Leader: Sertraline HCl reached an all-time high of over 15 million claims in 2023.
Beneficiary Gap: Sertraline HCl consistently dominated with >4M beneficiaries, while Fluoxetine HCl and Mirtazapine remained in the 2-3M range.
Oligopoly: The market is highly concentrated among three generic manufacturers: Aurobindo Pharma, Lupin Pharmaceuticals, and Teva USA.

## Limitations & Diagnostic Failures
Multicollinearity Paradox: Multivariate regression achieved an $R^2$ of 0.99 but failed to produce significant individual predictors26. This "regression failure" was caused by perfect temporal correlation ($r > 0.95$) between predictors
Sample Size: The claims-level dataset was limited to 5 years ($n=5$), restricting statistical power for complex multivariate models.
