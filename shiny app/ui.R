library(shiny)
library(ggplot2)
library(plotly)

#library for color
library(bslib)

# import df
unified_df <- read.csv("unified_df.csv")

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Home Page",
   h1("Income Level Relative to College Readiness in Michigan"),
   p("Using median family incomes based on ZIP Codes, and measuring college readiness 
   through total SAT scores, our dataset explores if there is a relationship between 
   family incomes and SAT scores among high school students in Michigan. We are seeking 
   to answer if there is a correlation between median family incomes and college readiness 
   in Michigan, using U.S. individual income statistics published on Kaggle by Golden Oak Research Group using 
   2011-2015 ACS 5-Year data provided by the U.S. Census Reports
   (https://www.kaggle.com/datasets/goldenoakresearch/us-household-income-stats-geo-locations) and 
   a dataset on college readiness information (including SAT scores) by Zip Code Tabulation Areas (ZCTA) 
   in 2017-2018 for the state of Michigan published on Data.gov
   (https://catalog.data.gov/dataset/collegereadiness-2017-2018-byzip-20181107-501d2). 

The income data came from Kaggle, yet some median family incomes are at 0, which may be inaccurate or missing data. While we measure college readiness on SAT scores, we do not measure the students that do not take the SAT tests, which may be misleading on measuring college readiness on students in Michigan. 
")
)

## VIZ 1 TAB INFO
df_colnames = colnames(unified_df)
df_colnames = c(
  "Average All Subjects Score" = "FinalAllSbjtAveScore",
  "Average Math Score" = "FinalMathAveScore",
  "Average Reading/Writing Score" = "FinalEWBRWAveScore",
  "Percentage of Students who scored above College Readiness Proficiency in All Subjects" = "AllSbjtPctReady",
  "Percentage of Students who scored above College Readiness Proficiency in Math" = "MathPctReady",
  "Percentage of Students who scored above College Readiness Proficiency in Reading/Writing" = "EBRWPctReady"
)

viz_1_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
    selectInput(
    inputId = "viz_1_y_axis",
    label = "Choose y-axis variable.",
    choices = df_colnames,
    selected = "Average All Subjects Score",
  ),
  sliderInput("point_size", "Point Size:", min = 1, max = 3, value = 1),
)

viz_1_main_panel <- mainPanel(
  h2("Income Medians vs SAT Test Scores"),
  plotlyOutput(outputId = "Median_vs_SbjtScore")
)

viz_1_tab <- tabPanel("Median vs SAT Scores",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel
  )
)

## VIZ 2 TAB INFO
viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  sliderInput("size", "Point Size:", min = 1, max = 3, value = 2),
  numericInput("low_income", "Lower Median Income Threshold:", value = 5000),
  numericInput("high_income", "Upper Median Income Threshold:", value = 100000)
)

viz_2_main_panel <- mainPanel(
  h2("Correlation between Math and Verbal Scores with Median Income"),
  plotlyOutput(outputId = "Scores_vs_Median")
)

viz_2_tab <- tabPanel("SAT Score Correlation with Income",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO
viz_3_sidebar <- sidebarPanel(
  h2("Explanation and Options for Graph"),
  p("Points located at Latitude & Longitude for Zipcodes"), 
  p("Size of point is determined by Total Percent of Students Ready by default but can be toggled to change size based on input slider"),
  p("Color intensity of point is determined by Median Income."),
  checkboxInput("show_point_size_as_allsbjctperready", "Toggle point size to percentage of students above college proficiency level", TRUE),
  sliderInput("map_point_size", "Point Size:", min = 1, max = 4, value = 3),
  numericInput("lower_limit_for_income", "Lower Median Income Threshold:", value = 5000),
  numericInput("upper_limit_for_income", "Upper Median Income Threshold:", value = 100000)
)

viz_3_main_panel <- mainPanel(
  h2("Interactive Map of Michigan State"),
  labs(title = "Show Points: Michigan Zip Codes"),
  #put graph here
  plotlyOutput(outputId = "choropleth_graph")
)

viz_3_tab <- tabPanel("Map of Michigan",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Drawing Conclusions",
 h1("Takeaways & Insights"),
 p("The dataset offers information on a variety of insight, including SAT scores, median income, 
   and zip codes from diverse places. There is no doubt that analyzing this data reveals some 
   intriguing correlations and trends."),
 p("When the association between Median Income and Total SAT Scores is examined, 
   a slight positive correlation is found, indicating that locations with higher 
   Median Incomes also have higher Total SAT Scores. This shows that socioeconomic 
   status may influence academic performance and vice versa. Similarly, both English 
   and Math SAT scores have a positive relationship with Median Income with some outliers, showing that greater economic affluence leads to improved performance in these disciplines."),
 p("The dataset demonstrates economic diversity across distinct geographical areas in 
   terms of median income distribution among Zip Codes. While the graph does not directly indicate the direct association between Median Income and Zip Code, the data does highlight income inequalities between regions represented by zip codes."),
 p("To recapitulate, the information sheds light on how socioeconomic characteristics 
   such as median income influence academic performance, particularly on standardized tests such as the SAT. It also provides light on the economic diversity that exists across different zip codes, stressing the necessity of addressing socioeconomic aspects when examining educational outcomes.")
)

my_theme <- bs_theme(bg = "#0b3d91",
                     fg = "white",
                     primary = "#FCC780")
my_theme <- bs_theme_update(my_theme,
                            bootswatch = "sketchy")

ui <- navbarPage("College Readiness & Income Level in Michigan State",
  theme = my_theme,
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
