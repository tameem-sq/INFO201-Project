#INFO201 Group Project
library("dplyr")
library("ggplot2")

income_df <- read.csv("kaggle_US_income_by_zipcode.csv")
college_df <- read.csv("michigan_college_readiness_SAT_scores_2017_2018.csv")

income_mich_df <- income_df %>%
  filter(State_Name == "Michigan")

combined_income_college <- left_join(income_mich_df, college_df, by=c("Zip_Code" = "ZCTA"))

df_clean <- na.omit(combined_income_college)

columns_to_keep <- c("State_Name", "County", "City", "Zip_Code", "Mean", "Median", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore", "MathPctReady", "AllSbjtPctReady", "EBRWPctReady")

unified_df <- select(df_clean, all_of(columns_to_keep))

# Convert data type of Median to numeric and add new categorical variable Income_Level with values Low, Medium, and High
unified_df$Median <- as.numeric(unified_df$Median)
unified_df <- unified_df %>%
  mutate(Income_Level = cut(Median, breaks = c(-Inf, 35000, 75000, Inf), labels = c("Low", "Medium", "High")))

avg_median_income <- unified_df %>%
  summarize(median_income_avg = mean(Median, na.rm = TRUE)) %>%
  pull(median_income_avg)

unified_df['difference_from_avg_median'] = avg_median_income - unified_df['Median']

avg_mean_income <- unified_df %>%
  summarize(mean_income_avg = mean(Mean, na.rm = TRUE)) %>%
  pull(mean_income_avg)

unified_df['difference_from_avg_mean'] = avg_mean_income - unified_df['Mean']

summary_columns <- c("Zip_Code", "Median", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore")
summary_df <- select(unified_df, all_of(summary_columns))

median_income_final_all_subject_score <- ggplot(data = unified_df) +
  geom_point(
    mapping = aes(
      x = Median,
      y = FinalAllSbjtAveScore)
  ) + scale_x_continuous(labels = scales::comma, limits = c(0, 200000))  # Adjust the limits as needed

median_income_final_all_subject_score

