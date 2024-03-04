library(shiny)
library(ggplot2)
library(plotly)

#library for color
library(bslib)

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Overview Tab Title",
   h1("Income Level Relative to College Readiness in Michigan"),
   p("some explanation")
)

## VIZ 1 TAB INFO

df_colnames = colnames(unified_df)
df_colnames = c(
  "Average All Subjects Score" = "FinalAllSbjtAveScore",
  "Average Math Score" = "FinalMathAveScore",
  "Average Reading/Writing Score" = "FinalEWBRWAveScore"
)

viz_1_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
    selectInput(
    inputId = "viz_1_y_axis",
    label = "Choose y-axis variable.",
    choices = df_colnames,
    selected = "Average All Subjects Score"
  )
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
  #TODO: Put inputs for modifying graph here
)

viz_2_main_panel <- mainPanel(
  h2("Vizualization 2 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_2_tab <- tabPanel("Viz 2 tab title",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  textInput(inputId = "graph_title",
            label = "Title of graph:"),
  #put graph here
  plotlyOutput(outputId = "choropleth_graph")
)

viz_3_tab <- tabPanel("Viz 3 tab title",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Takeaways & Insights",
 h1("Some title"),
 p("some conclusions")
)

ui <- navbarPage("College Readiness & Income Level in Michigan State",
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)
