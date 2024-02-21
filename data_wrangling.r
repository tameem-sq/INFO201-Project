library("dplyr")

income_df <- read.csv("kaggle_income.csv")
college_df <- read.csv("mich_college_readiness.csv")


income_mich_df <- income_df %>%
  filter(State_Name == "Michigan")

combined_income_college <- left_join(income_mich_df, college_df, by=c("Zip_Code" = "ZCTA"))

df_clean <- na.omit(combined_income_college)

columns_to_keep <- c("Zip_Code", "Mean", "Median", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore", "MathPctReady", "AllSbjtPctReady", "EBRWPctReady")

combined_df <- select(df_clean, columns_to_keep)

combined_df <- combined_df %>%
  mutate(Income_Level = cut(Median, breaks = c(-Inf, 35000, 75000, Inf), labels = c("Low", "Medium", "High")))

avg_median_income <- combined_df %>%
  summarize(median_income_avg = mean(Median, na.rm = TRUE)) %>%
  pull(median_income_avg)

combined_df['difference_from_avg_median'] = avg_median_income - combined_df['Median']

avg_mean_income <- combined_df %>%
  summarize(mean_income_avg = mean(Mean, na.rm = TRUE)) %>%
  pull(mean_income_avg)

combined_df['difference_from_avg_mean'] = avg_mean_income - combined_df['Mean']

summary_columns <- c("Zip_Code", "Median", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore")
summary_df <- select(combined_df, summary_columns)