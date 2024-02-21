library("dplyr")

income_df <- read.csv("kaggle_income.csv")
college_df <- read.csv("mich_college_readiness.csv")


income_mich_df <- income_df %>%
  filter(State_Name == "Michigan")

combined_income_college <- left_join(income_mich_df, college_df, by=c("Zip_Code" = "ZCTA"))

df_clean <- na.omit(combined_income_college)


df_clean <- select(-id)

columns_to_keep <- c("County", "City", "Zip_Code", "Area_Code", "Mean", "Median", "Stdev", "sum_w", "MathNumAssessed", "MathNumReady", "AllSbjtNumReady", "AllSbjtNumAssessed", "EBRWNumAssessed", "EBRWNumReady", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore", "MathPctReady", "AllSbjtPctReady", "EBRWPctReady")

combined_df <- select(df_clean, columns_to_keep)

summary_columns <- c("County", "City", "Zip_Code", "Mean", "Median")
summary_df <- select(combined_df, summary_columns)

