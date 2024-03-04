
server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  output$Median_vs_SbjtScore <- renderPlotly({
    Median_vs_SbjtScore <- ggplot(unified_df) +
      geom_point(
        mapping = aes(
          x = Median,
          y = FinalAllSbjtAveScore)
      ) +
      labs(title = input$viz_1_title)
    return(ggplotly(Median_vs_SbjtScore))
  })
  
}