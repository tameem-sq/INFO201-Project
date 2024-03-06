library("dplyr")
library("ggplot2")
library("plotly")

# Install these:
# install.packages("maps")
# install.packages("mapproj")

library("maps")
library("mapproj")

income_df <- read.csv("../kaggle_US_income_by_zipcode.csv")
college_df <- read.csv("../michigan_college_readiness_SAT_scores_2017_2018.csv")

income_mich_df <- income_df %>%
  filter(State_Name == "Michigan")

combined_income_college <- left_join(income_mich_df, college_df, by=c("Zip_Code" = "ZCTA"))

df_clean <- na.omit(combined_income_college)

columns_to_keep <- c("State_Name", "County", "City", "Zip_Code", "AllSbjtNumReady", "AllSbjtNumAssessed", "Lat", "Lon", "Mean_Income" = "Mean", "Median_Income" = "Median", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore", "MathPctReady", "TotalPerReady" = "AllSbjtPctReady", "EBRWPctReady")

unified_df <- select(df_clean, all_of(columns_to_keep))

# Convert data type of Median to numeric and add new categorical variable Income_Level with values Low, Medium, and High
unified_df$Median <- as.numeric(unified_df$Median)
unified_df <- unified_df %>%
  mutate(Income_Level = cut(Median, breaks = c(-Inf, 35000, 75000, Inf), labels = c("Low", "Medium", "High")))

state_shape <- map_data("state")
michigan_shape <- subset(state_shape, region == "michigan")

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  output$Median_vs_SbjtScore <- renderPlotly({
    Median_vs_SbjtScore <- ggplot(unified_df) +
      geom_point(
        mapping = aes(
          x = Median,
          y = !!as.name(input$viz_1_y_axis))
      ) +
      labs(title = input$viz_1_title)
    return(ggplotly(Median_vs_SbjtScore))
  })
  
  output$choropleth_graph <- renderPlotly({
    merged_data <- merge(michigan_shape, unified_df, by.x = "region", by.y = "State_Name", all.x = TRUE)
    
    # create ggplot and use
    my_plot <- ggplot(data = michigan_shape) +
      geom_polygon(aes(
        x = long,
        y = lat,
        group = group,
        State = "Michigan"
      )) +
      geom_point(data = unified_df, aes(
        x = Lon,
        y = Lat,
        Zip_Code = Zip_Code,
        Income = Median,
        Ready = TotalPerReady)
      ) +
      coord_map() + 
      labs(title = input$graph_title)
    return(ggplotly(my_plot))
  })
  
  output$Scores_vs_Median <- renderPlotly({
  Scores_vs_Median <- ggplot(unified_df) +
    geom_point(
      mapping = aes(
      x = FinalMathAveScore,
      y = FinalEWBRWAveScore, 
      color = Median)) +
    scale_color_gradient(low = "blue", high = "red", name = "Median Income") +
    labs(title = "Correlation between Math and Verbal Scores with Median Income")
  return(ggplotly(Scores_vs_Median))
  })
  
}