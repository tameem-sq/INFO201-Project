library("dplyr")

income_df <- read.csv("kaggle_income.csv")
college_df <- read.csv("mich_college_readiness.csv")


income_mich_df <- income_df %>%
  filter(State_Name == "Michigan")

combined_income_college <- left_join(income_mich_df, college_df, by=c("Zip_Code" = "ZCTA"))

df_clean <- na.omit(combined_income_college)


