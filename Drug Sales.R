install.packages(c("tidyverse", "ggplot2", "corrplot"))

# ============================================================================
# Price vs Usage Analysis for Antidepressants (2019-2023)
# ============================================================================

# Install required packages (run once)
# install.packages(c("tidyverse", "ggplot2", "corrplot"))

# Load libraries
library(tidyverse)
library(ggplot2)
library(corrplot)

# ============================================================================
# STEP 1: Load and Prepare Data
# ============================================================================

# Read the CSV file
# IMPORTANT: Update this path to where your CSV file is located
data <- read.csv("C:/Users/samee/OneDrive/Desktop/N06A_Antidepressant.csv")

# Display basic information
cat("Dataset dimensions:", dim(data), "\n")
cat("Years in dataset:", unique(data$Year), "\n\n")

# Create aggregated data by year
yearly_data <- data %>%
  group_by(Year) %>%
  summarise(
    Total_Claims = sum(Total_claims, na.rm = TRUE),
    Total_Beneficiaries = sum(Total_beneficiaries, na.rm = TRUE),
    Avg_Unit_Price = mean(Avg_unit_price_weighted, na.rm = TRUE),
    Median_Unit_Price = median(Avg_unit_price_weighted, na.rm = TRUE),
    Total_Spending = sum(Total_spending, na.rm = TRUE),
    .groups = 'drop'
  )

print(yearly_data)

# ============================================================================
# STEP 2: Visualizations
# ============================================================================

# Plot 1: Average Unit Price vs Total Claims Over Time
plot1 <- ggplot(yearly_data, aes(x = Avg_Unit_Price, y = Total_Claims)) +
  geom_point(aes(color = as.factor(Year)), size = 4) +
  geom_smooth(method = "lm", se = TRUE, color = "blue", linetype = "dashed") +
  geom_text(aes(label = Year), vjust = -1, size = 3.5) +
  labs(
    title = "Relationship Between Average Unit Price and Total Claims",
    subtitle = "Antidepressants (2019-2023)",
    x = "Average Unit Price ($)",
    y = "Total Claims (millions)",
    color = "Year"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right"
  )

print(plot1)

# Plot 2: Average Unit Price vs Total Beneficiaries
plot2 <- ggplot(yearly_data, aes(x = Avg_Unit_Price, y = Total_Beneficiaries)) +
  geom_point(aes(color = as.factor(Year)), size = 4) +
  geom_smooth(method = "lm", se = TRUE, color = "red", linetype = "dashed") +
  geom_text(aes(label = Year), vjust = -1, size = 3.5) +
  labs(
    title = "Relationship Between Average Unit Price and Total Beneficiaries",
    subtitle = "Antidepressants (2019-2023)",
    x = "Average Unit Price ($)",
    y = "Total Beneficiaries (millions)",
    color = "Year"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right"
  )

print(plot2)

# Plot 3: Time Series - Dual Axis
plot3 <- ggplot(yearly_data, aes(x = Year)) +
  geom_line(aes(y = Total_Claims, color = "Total Claims"), size = 1.2) +
  geom_point(aes(y = Total_Claims, color = "Total Claims"), size = 3) +
  geom_line(aes(y = Avg_Unit_Price * 10000000, color = "Avg Unit Price"), 
            size = 1.2, linetype = "dashed") +
  geom_point(aes(y = Avg_Unit_Price * 10000000, color = "Avg Unit Price"), size = 3) +
  scale_y_continuous(
    name = "Total Claims",
    labels = scales::comma,
    sec.axis = sec_axis(~./10000000, name = "Average Unit Price ($)")
  ) +
  labs(
    title = "Trends: Claims and Unit Price Over Time",
    subtitle = "2019-2023",
    x = "Year",
    color = "Metric"
  ) +
  scale_color_manual(values = c("Total Claims" = "steelblue", 
                                "Avg Unit Price" = "coral")) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom",
    axis.title.y.right = element_text(color = "coral"),
    axis.title.y.left = element_text(color = "steelblue")
  )

print(plot3)

# ============================================================================
# STEP 3: Statistical Analysis
# ============================================================================

cat("\n============ CORRELATION ANALYSIS ============\n\n")

# Correlation between price and claims
cor_claims <- cor.test(yearly_data$Avg_Unit_Price, yearly_data$Total_Claims)
cat("Correlation: Avg Unit Price vs Total Claims\n")
cat("Correlation coefficient:", round(cor_claims$estimate, 4), "\n")
cat("P-value:", format(cor_claims$p.value, scientific = TRUE), "\n")
cat("Interpretation:", 
    ifelse(cor_claims$estimate > 0, "Positive", "Negative"), 
    "correlation\n\n")

# Correlation between price and beneficiaries
cor_benef <- cor.test(yearly_data$Avg_Unit_Price, yearly_data$Total_Beneficiaries)
cat("Correlation: Avg Unit Price vs Total Beneficiaries\n")
cat("Correlation coefficient:", round(cor_benef$estimate, 4), "\n")
cat("P-value:", format(cor_benef$p.value, scientific = TRUE), "\n")
cat("Interpretation:", 
    ifelse(cor_benef$estimate > 0, "Positive", "Negative"), 
    "correlation\n\n")

# ============================================================================
# STEP 4: Linear Regression Analysis
# ============================================================================

cat("\n============ REGRESSION ANALYSIS ============\n\n")

# Regression: Claims predicted by Price
model_claims <- lm(Total_Claims ~ Avg_Unit_Price, data = yearly_data)
cat("Model 1: Total Claims ~ Average Unit Price\n")
print(summary(model_claims))

cat("\n\nModel 1 Interpretation:\n")
cat("For every $1 increase in unit price, claims change by:", 
    round(coef(model_claims)[2], 0), "\n")
cat("R-squared:", round(summary(model_claims)$r.squared, 4), "\n\n")

# Regression: Beneficiaries predicted by Price
model_benef <- lm(Total_Beneficiaries ~ Avg_Unit_Price, data = yearly_data)
cat("\n\nModel 2: Total Beneficiaries ~ Average Unit Price\n")
print(summary(model_benef))

cat("\n\nModel 2 Interpretation:\n")
cat("For every $1 increase in unit price, beneficiaries change by:", 
    round(coef(model_benef)[2], 0), "\n")
cat("R-squared:", round(summary(model_benef)$r.squared, 4), "\n\n")

# ============================================================================
# STEP 5: Year-over-Year Change Analysis
# ============================================================================

cat("\n============ YEAR-OVER-YEAR CHANGES ============\n\n")

yearly_changes <- yearly_data %>%
  arrange(Year) %>%
  mutate(
    Price_Change_Pct = (Avg_Unit_Price - lag(Avg_Unit_Price)) / lag(Avg_Unit_Price) * 100,
    Claims_Change_Pct = (Total_Claims - lag(Total_Claims)) / lag(Total_Claims) * 100,
    Benef_Change_Pct = (Total_Beneficiaries - lag(Total_Beneficiaries)) / lag(Total_Beneficiaries) * 100
  )

print(yearly_changes)

# ============================================================================
# STEP 6: Summary and Insights
# ============================================================================

cat("\n\n============ KEY INSIGHTS ============\n\n")

# Determine overall trends
price_trend <- ifelse(yearly_data$Avg_Unit_Price[5] > yearly_data$Avg_Unit_Price[1], 
                      "increased", "decreased")
claims_trend <- ifelse(yearly_data$Total_Claims[5] > yearly_data$Total_Claims[1], 
                       "increased", "decreased")

cat("1. Price Trend (2019-2023): Average unit price", price_trend, "\n")
cat("   From $", round(yearly_data$Avg_Unit_Price[1], 2), 
    " to $", round(yearly_data$Avg_Unit_Price[5], 2), "\n\n")

cat("2. Usage Trend (2019-2023): Total claims", claims_trend, "\n")
cat("   From", format(yearly_data$Total_Claims[1], big.mark = ","), 
    "to", format(yearly_data$Total_Claims[5], big.mark = ","), "\n\n")

cat("3. Correlation Strength:\n")
if (abs(cor_claims$estimate) > 0.7) {
  cat("   STRONG correlation between price and claims\n")
} else if (abs(cor_claims$estimate) > 0.4) {
  cat("   MODERATE correlation between price and claims\n")
} else {
  cat("   WEAK correlation between price and claims\n")
}

cat("\n4. Statistical Significance:\n")
if (cor_claims$p.value < 0.05) {
  cat("   The relationship is statistically significant (p < 0.05)\n")
} else {
  cat("   The relationship is NOT statistically significant (p >= 0.05)\n")
}

cat("\n============ END OF ANALYSIS ============\n")