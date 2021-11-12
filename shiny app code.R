ui = navbarPage("ANIME WITH U!",
                tags$head(tags$style(HTML("
      .navbar-default .navbar-brand {font-weight: bold;color: #F47321;font-size:22px;
      font-family:'Georgia'}
      .navbar-default .navbar-brand:hover {color: white;}
      .navbar { background-color: #005030;}
      .navbar-default .navbar-nav > li > a {font-weight: bold;color:white;font-size:18px;font-family:'New Times Roman'}
      .navbar-default .navbar-nav > .active > a,
      .navbar-default .navbar-nav > .active > a:focus,
      .navbar-default .navbar-nav > .active > a:hover {color: #005030;background-color: #F47321;}"
                ))),
                tabPanel(
                  title = "Find Your Favorite Anime!",
                  sidebarLayout(
                    sidebarPanel(
                      tags$style(
                        ".well {background-color:#005030;}
             .well {font-weight:bold;color: white;font-family:'Times New Roman'}
             .well:hover {font-weight: bold;color: #F47321;}
            "),
                      titlePanel("Select Your Anime"),
                      fluidRow(
                        selectInput("Rating",
                                    "Rating:",
                                    c("All",
                                      unique(anime$Rating))),
                        selectInput("Source",
                                    "Source:",
                                    c("All",
                                      unique(anime$Source))),
                        selectInput("Season",
                                    "Season:",
                                    c("All",
                                      unique(anime$Season))))),
                    mainPanel( 
                      tabsetPanel(
                        tabPanel('Data', DT::dataTableOutput("table"))
                      )
                    )
                  )
                ),
                tabPanel(
                  title = "Top Picks",
                  sidebarLayout(
                    sidebarPanel(
                      tags$style(
                        ".well {background-color:#005030;}
             .well {font-weight:bold;color: white;font-family:'Times New Roman'}
             .well:hover {font-weight: bold;color: #F47321;}
            "),
                      conditionalPanel(
                        'input.dataset === "score"',
                        checkboxGroupInput("show_vars1", "TOP 10 SCORE ANIMES:",
                                           names(rank_by_score), selected = names(rank_by_score)),
                        sliderInput("range", 
                                    label = "Range of episodes:",
                                    min = min(rank_by_score$Episodes), 
                                    max = max(rank_by_score$Episodes), value = c(10, 50))
                      ),
                      conditionalPanel(
                        'input.dataset === "year"',
                        checkboxGroupInput("show_vars2", "TOP 1 ANIME FROM 1963 TO 2021:",
                                           names(rank_by_year), selected = names(rank_by_year)),
                        sliderInput("range", 
                                    label = "Range of episodes:",
                                    min = min(rank_by_score$Episodes), 
                                    max = max(rank_by_score$Episodes), value = c(10, 50))
                      ),
                      
                      conditionalPanel(
                        'input.dataset === "genre"',
                        checkboxGroupInput("show_vars3", "TOP 1 ANIME IN 33 GENRES:",
                                           names(rank_by_genre), selected = names(rank_by_genre)),
                        sliderInput("range", 
                                    label = "Range of episodes:",
                                    min = min(rank_by_score$Episodes), 
                                    max = max(rank_by_score$Episodes), value = c(10, 50))
                      ),
                      
                      conditionalPanel(
                        'input.dataset === "rating"',
                        checkboxGroupInput("show_vars4", "TOP 1 ANIME IN 5 RANTINGS:",
                                           names(rank_by_rating), selected = names(rank_by_rating)),
                        sliderInput("range", 
                                    label = "Range of episodes:",
                                    min = min(rank_by_score$Episodes), 
                                    max = max(rank_by_score$Episodes), value = c(10, 50))
                      ),
                    ),
                    mainPanel(
                      tabsetPanel(
                        id = 'dataset',
                        tabPanel("score", DT::dataTableOutput("mytable1")),
                        tabPanel("year", DT::dataTableOutput("mytable2")),
                        tabPanel("genre", DT::dataTableOutput("mytable3")),
                        tabPanel("rating", DT::dataTableOutput("mytable4"))
                      )
                    )#mainpanel
                  )#sidebarlayout
                ),#tabpanel1
                tabPanel(
                  title = "Overview",
                  fluidPage(
                    tags$style(HTML("li>a {color:#005030;font-weight:bold;;font-size:16px;
    font-family:'Times New Roman'} .nav-tabs>li.active>a {color: #F47321;}")),
                    tabsetPanel(
                      tabPanel(
                        title = "Average Score in Different Years",
                        imageOutput("avg_socre_by_year1"),
                        imageOutput("avg_socre_by_year2")),
                      tabPanel(
                        "Total Number of Animes in Different Years",
                        imageOutput("total_num_by_year")),
                      tabPanel(
                        "Average Score in Different Genres",
                        imageOutput("avg_socre_by_genre")),
                      tabPanel(
                        "Total Number of Animes in Different Genres",
                        imageOutput("total_num_by_genre"))
                    )#tabsetPanel2
                  )#fluidpage
                ),#tabpanel2
                tabPanel(
                  title = "User Profile",
                  fluidPage(
                    tags$style(HTML("li>a {color:#005030;font-weight:bold;;font-size:16px;
        font-family:'Times New Roman'} .nav-tabs>li.active>a {color: #F47321;}")),
                    dataTableOutput('data')
                  )),#tabpenel3
                tabPanel(
                  title = "Anime Profile",
                  tags$style(HTML("li>a {color:#005030;font-weight:bold;;font-size:16px;
        font-family:'Times New Roman'} .nav-tabs>li.active>a {color: #F47321;}")),
                  sidebarLayout(
                    sidebarPanel(
                      tags$style(
                        ".well {background-color:#005030;}
        .well {font-weight:bold;color: white;font-family:'Times New Roman'}
        .well:hover {font-weight: bold;color: #F47321;}
        "),
                      selectInput('Genres', 'Please Select a Genre:', choices=unique(anime_view$Genres))
                    ),
                    mainPanel(
                      tabsetPanel(
                        tabPanel('CompleteRate', plotOutput('complete')),
                        tabPanel('DropRate', plotOutput('drop'))
                      )))),
                tabPanel(
                  title = "Your Anime Information",
                  sidebarLayout(
                    sidebarPanel(
                      textInput(
                        "animeName",
                        NULL,
                        placeholder = "Input the Anime Name"
                      ),
                      actionButton(
                        'showAnime',
                        'Explore more about your anime'
                      )
                    ),
                    mainPanel(
                      h3('Basic Information'),
                      tableOutput('animeTable1'),
                      h4('Watching Information'),
                      tableOutput('animeTable2'),
                    )#mainpanel
                  ),#sidebarlayout
                )
)# ui

server <- function(input, output){
  filtered1 <- reactive({
    rank_by_score%>%
      filter(Episodes >= min(input$range) & Episodes <= max(input$range))
  })
  filtered2 <- reactive({
    rank_by_year%>%
      filter(Episodes >= min(input$range) & Episodes <= max(input$range))
  })
  filtered3 <- reactive({
    rank_by_genre%>%
      filter(Episodes >= min(input$range) & Episodes <= max(input$range))
  })
  filtered4 <- reactive({
    rank_by_rating%>%
      filter(Episodes >= min(input$range) & Episodes <= max(input$range))
  })
  output$mytable1 <- DT::renderDataTable({
    DT::datatable((filtered1()[, input$show_vars1, drop = FALSE]),options = list(lengthMenu = c(10, 30, 50)))
  })
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(filtered2()[, input$show_vars2, drop = FALSE], options = list(orderClasses = F))
  })
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(filtered3()[, input$show_vars3, drop = FALSE])
  })
  output$mytable4 <- DT::renderDataTable({
    DT::datatable(filtered4()[, input$show_vars4, drop = FALSE])
  })
  output$avg_socre_by_year1 <- renderImage({
    avg_socre_by_year1 <- tempfile(fileext='.gif')
    a = ggplot(anime_by_season,aes(x = Year, y = avg_score, col = Season))+
      geom_point()+
      geom_line()+
      facet_grid(Season~.)+
      labs(y = 'Average Score', title = "Average Score over Same Season in Different Years")+
      theme_economist()+ 
      scale_color_tableau()
    a2 = a + facet_grid(Season~.) + transition_reveal(Year)
    anim_save("avg_socre_by_year1.gif", animate(a2, renderer = gifski_renderer())) 
    list(src = "avg_socre_by_year1.gif",
         contentType = 'image/gif'
    )}, deleteFile = TRUE)
  output$avg_socre_by_year2 <- renderImage({
    avg_socre_by_year2 <- tempfile(fileext='.gif')
    b = ggplot(anime_by_season,aes(x = Year, y = avg_score, col = Season))+
      geom_point()+
      geom_line() +
      labs(y = 'Average Score', title = "Average Score over Same Season in Different Years")+
      theme_economist()+ 
      scale_color_tableau()
    b2 = b +  transition_reveal(Year)
    anim_save("avg_socre_by_year2.gif", animate(b2, renderer = gifski_renderer()))
    list(src = "avg_socre_by_year2.gif",
         contentType = 'image/gif'
    )}, deleteFile = TRUE)
  output$total_num_by_year <- renderImage({
    total_num_by_year <- tempfile(fileext='.gif')
    c = ggplot(anime_by_season,aes(x = Year, y = total_anime, col = Season))+
      geom_point()+
      geom_line()+
      labs(y = 'Total Number', title = 'Total Number of Animes over Same Season in Different Years')+
      theme_economist()+ 
      scale_color_tableau()
    c2 = c +  transition_reveal(Year)
    anim_save("total_num_by_year.gif", animate(c2, renderer = gifski_renderer())) 
    list(src = "total_num_by_year.gif",
         contentType = 'image/gif'
    )}, deleteFile = TRUE)
  output$avg_socre_by_genre <- renderImage({
    avg_socre_by_genre <- tempfile(fileext='.gif')
    d = ggplot(anime_by_genre,aes(x=Genres,y=avg_score))+
      geom_col(fill = "#1a476f")+
      coord_flip()+ 
      labs(title = "Average Score in Different Genres")+
      scale_y_continuous(name = 'Average Score',breaks = 5:10)+
      theme_economist(horizontal=FALSE)
    d2 = d +  transition_states(Genres)+shadow_mark()
    anim_save("avg_socre_by_year1.gif", animate(d2, renderer = gifski_renderer())) 
    list(src = "avg_socre_by_year1.gif",
         contentType = 'image/gif'
    )}, deleteFile = TRUE)
  output$total_num_by_genre <- renderImage({
    total_num_by_genre <- tempfile(fileext='.gif')
    e = ggplot(anime_by_genre,aes(x=Genres,y=total_anime))+
      geom_col(fill = 'dodgerblue4')+
      coord_flip()+
      labs(title = "Total Number of Animes in Different Genres")+
      scale_y_continuous(name = 'Total Number',breaks = seq(0,1300,by=100))+
      theme_economist(horizontal=FALSE)
    e2 = e +  transition_states(Genres)+shadow_mark()
    anim_save("total_num_by_genre.gif", animate(e2, renderer = gifski_renderer())) 
    list(src = "total_num_by_genre.gif",
         contentType = 'image/gif'
    )}, deleteFile = TRUE)
  output$data = renderDataTable(user_table)
  
  output$table <- DT::renderDataTable(DT::datatable({
    data <- anime
    if (input$Rating != "All") {
      data <- data[data$Rating == input$Rating,]
    }
    if (input$Source != "All") {
      data <- data[data$Source == input$Source,]
    }
    if (input$Season != "All") {
      data <- data[data$Season == input$Season,]
    }
    data[,1:9]
  }))
  
  output$drop = renderPlot(
    anime_view %>%
      filter(Genres == input$Genres) %>%
      ggplot(aes(x=Year, y=avg_drop_rate)) + 
      geom_line(size=1, col = 'darkred') + 
      theme_economist() + 
      scale_color_fivethirtyeight() + 
      scale_y_continuous(name = 'Average Drop Rate',limits=c(0, 1))
  )
  
  output$complete = renderPlot(
    anime_view %>%
      filter(Genres == input$Genres) %>%
      ggplot(aes(x=Year, y=avg_complete_rate)) + 
      geom_line(size=1, col = 'steelblue') + 
      theme_economist() + 
      scale_color_fivethirtyeight() + 
      scale_y_continuous(name = 'Average Complete Rate',limits=c(0, 1))
  )
  output$animeTable1 <- renderTable(
    if (input$showAnime == 0) {
      anime %>%
        filter(grepl(pattern = 'Fullmetal Alchemist', Name, ignore.case = 1)) %>%
        slice(1:1) %>%
        select(Name, Year, Season, Score, Genres, Episodes, Source, Rating) %>%
        gather(key = 'Item', value = 'Info')
    }
    else {
      input$showAnime
      isolate(
        anime %>%
          filter(grepl(pattern = input$animeName, Name, ignore.case = 1)) %>%
          slice(1:1) %>%
          select(Name, Year, Season, Score, Genres, Episodes, Source, Rating) %>%
          gather(key = 'Item', value = 'Info')
      )
    }
  )
  output$animeTable2 <- renderTable(
    if (input$showAnime == 0) {
      anime %>%
        mutate(
          Category = ifelse(Genres == 'Action', ifelse(Name == 'Fullmetal Alchemist', 'Your Anime', 'Other Animes in this Genre'), 'Others')
        ) %>%
        filter(Category != -1) %>%
        select(Category, Score, Favorites, Watching, Completed, On.Hold, Dropped, Plan.to.Watch) %>%
        group_by(Category) %>%
        summarise(
          Avg_score = round(mean(Score), 2),
          AVg_num_favorites = ceiling(mean(Favorites)),
          Avg_num_watching = ceiling(mean(Watching)),
          Avg_num_completed = ceiling(mean(Completed)),
          Avg_num_on_hold = ceiling(mean(On.Hold)),
          Avg_num_dropped = ceiling(mean(Dropped)),
          Avg_num_plan_to_watch = ceiling(mean(Plan.to.Watch))
        ) %>%
        transpose() %>%
        row_to_names(row_number = 1) %>%
        mutate(
          Category = c('Avg_score', 'AVg_num_favorites', 'Avg_num_watching', 'Avg_num_completed', 'Avg_num_on_hold', 'Avg_num_dropped', 'Avg_num_plan_to_watch')
        ) %>%
        select(Category, 'Your Anime', 'Other Animes in this Genre')
    }
    else {
      input$showPanel
      isolate(
        anime %>%
          mutate(
            Category = ifelse(grepl(pattern = input$animeName, .$Name, ignore.case = 1), 'Your Anime', 'Other Animes')
          ) %>%
          filter(Category != -1) %>%
          select(Category, Score, Favorites, Watching, Completed, On.Hold, Dropped, Plan.to.Watch) %>%
          group_by(Category) %>%
          summarise(
            Avg_score = round(mean(Score), 2),
            AVg_num_favorites = ceiling(mean(Favorites)),
            Avg_num_watching = ceiling(mean(Watching)),
            Avg_num_completed = ceiling(mean(Completed)),
            Avg_num_on_hold = ceiling(mean(On.Hold)),
            Avg_num_dropped = ceiling(mean(Dropped)),
            Avg_num_plan_to_watch = ceiling(mean(Plan.to.Watch))
          ) %>%
          transpose() %>%
          row_to_names(row_number = 1) %>%
          mutate(
            Category = c('Avg_score', 'AVg_num_favorites', 'Avg_num_watching', 'Avg_num_completed', 'Avg_num_on_hold', 'Avg_num_dropped', 'Avg_num_plan_to_watch')
          ) %>%
          select(Category, 'Your Anime', 'Other Animes')
      )
    }
  )
}
shinyApp(ui, server)
