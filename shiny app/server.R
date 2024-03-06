
library("ggplot2")
library("plotly")

# Install these:
# install.packages("maps")
# install.packages("mapproj")

library("maps")
library("mapproj")

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
        fill = "Median"
      )) +
      coord_map() + 
      labs(title = "Choropleth Map of Median Income Michigan")
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