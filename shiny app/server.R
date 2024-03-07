library("shiny")
library("dplyr")
library("ggplot2")
library("plotly")


# Install these:
# install.packages("maps")
# install.packages("mapproj")

library("maps")
library("mapproj")

income_df <- read.csv("kaggle_US_income_by_zipcode.csv")
college_df <- read.csv("michigan_college_readiness_SAT_scores_2017_2018.csv")

income_mich_df <- income_df %>%
  filter(State_Name == "Michigan")

combined_income_college <- left_join(income_mich_df, college_df, by=c("Zip_Code" = "ZCTA"))

df_clean <- na.omit(combined_income_college)

columns_to_keep <- c("State_Name", "County", "City", "Zip_Code", "AllSbjtNumReady", "TotalNumberAssessed" = "AllSbjtNumAssessed", "Lat", "Lon", "MeanIncome" = "Mean", "MedianIncome" = "Median", "FinalMathAveScore", "FinalAllSbjtAveScore", "FinalEWBRWAveScore", "MathPctReady", "AllSbjtPctReady", "EBRWPctReady")

unified_df <- select(df_clean, all_of(columns_to_keep))

# write.csv("~/Documents/GitHub/INFO201-Project/shiny app/unified_df.csv")
# unified_df <- read.csv("~/Documents/GitHub/INFO201-Project/shiny app/unified_df.csv")

# Convert data type of Median to numeric and add new categorical variable Income_Level with values Low, Medium, and High
unified_df$Median <- as.numeric(unified_df$Median)
unified_df <- unified_df %>%
  mutate(Income_Level = cut(Median, breaks = c(-Inf, 35000, 75000, Inf), labels = c("Low", "Medium", "High")))

state_shape <- map_data("state")
michigan_shape <- subset(state_shape, region == "michigan")

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  output$Median_vs_SbjtScore <- renderPlotly({
    
    filtered_df <- unified_df %>%
      filter(Median >= input$lower_limit_median_income_viz1 & Median <= input$upper_limit_median_income_viz1)
    
    Median_vs_SbjtScore <- ggplot(filtered_df) +
      geom_point(
        mapping = aes(
          x = Median,
          y = !!as.name(input$viz_1_y_axis)), size = input$point_size
      ) +
      labs(title = input$viz_1_title)
    return(ggplotly(Median_vs_SbjtScore))
  })
  
  output$Scores_vs_Median <- renderPlotly({
    
    filtered_df <- unified_df %>%
      filter(Median >= input$lower_limit_median_income_viz2 & Median <= input$upper_limit_median_income_viz2)
    
    Scores_vs_Median <- ggplot(filtered_df) + 
      geom_point(mapping = aes(x = FinalMathAveScore, y = FinalEWBRWAveScore, color = Median), size = input$size) + 
      scale_color_viridis_c(name = "Median Income") +
      labs(title = "Correlation between Math and Verbal Scores with Median Income") 
    
    ggplotly(Scores_vs_Median)
  })
  
  output$choropleth_graph <- renderPlotly({
    
    filtered_df <- unified_df %>%
      filter(Median >= input$lower_limit_median_income_viz3 & Median <= input$upper_limit_median_income_viz3)

    merged_data <- merge(michigan_shape, filtered_df, by.x = "region", by.y = "State_Name", all.x = TRUE)
    # create ggplot and use
    if (input$show_point_size_as_allsbjctperready) {
      my_plot <- ggplot(data = michigan_shape) +
        geom_polygon(aes(
          x = long,
          y = lat,
          group = group,
        ),
        fill = "white",
        color = "purple"
        ) +
        geom_point(
          data = filtered_df,
          aes(
            x = Lon,
            y = Lat,
            fill = MedianIncome,
          ),
          size = input$map_point_size  # Set the default size for points
        ) +
        coord_map() + 
        labs(title = "Map of Michigan")
    }
    else {
      my_plot <- ggplot(data = michigan_shape) +
        geom_polygon(aes(
          x = long,
          y = lat,
          group = group,
        ),
        fill = "white",
        color = "purple"
        ) +
        geom_point(
          data = filtered_df,
          aes(
            x = Lon,
            y = Lat,
            fill = MedianIncome,
            size = AllSbjtPctReady,
          )
        ) +
        coord_map() + 
        labs(title = "Map of Michigan")
    }
  
    return(ggplotly(my_plot))
  })
}