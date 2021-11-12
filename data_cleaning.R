library(readr)
library(tidyr)
library(dplyr)
library(lubridate)
library(ggplot2)
library(gganimate)
library(gifski)
library(shiny)
library(DT)
library(ggthemes)
library(rsconnect)
library(data.table)
library(janitor)


anime <- read.csv("anime.csv")%>%
  select(-(English.name:Type),-Aired, -(Producers:Studios), -Duration,-Ranked, -Members,-(Score.10:Score.1))%>%
  separate('Premiered', c('Season', 'Year'), sep=' ')%>%
  mutate(Genres = gsub(" .*","", Genres),
         Genres = gsub(",","", Genres),
         Rating = gsub(" .*","", Rating),
         Year = year(as.Date(Year, '%Y')),
         Score = as.numeric(Score),
         Episodes = as.numeric(Episodes)
  )%>%
  filter(!is.na(Score) == TRUE &Genres != 'Unknown'& Episodes != 'Unknown' &  
           Rating != 'Unknown' & Season != 'Unknown' & !is.na(Year) == TRUE )

rank_by_score = anime %>% top_n(n=10,wt=Score)%>% select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%arrange(desc(Score),desc(Year))
rank_by_genre = anime %>% group_by(Genres)%>%top_n(n=1,wt=Score)%>% select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%arrange(Genres)
rank_by_year = anime %>% group_by(Year)%>%top_n(n=1,wt=Score)%>% select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%arrange(desc(Year))
rank_by_rating= anime %>% group_by(Rating)%>%top_n(n=1,wt=Score)%>% select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%arrange(desc(Score))
anime_by_season= anime %>% 
  select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%
  group_by(Year,Season)%>%
  summarise(avg_score = round(mean(Score),2),
            total_anime = n())
anime_by_year= anime %>% 
  select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%
  group_by(Season,Year)%>%
  summarise(avg_score = round(mean(Score),2),
            total_anime = n())
anime_by_genre= anime %>% 
  select(-MAL_ID,-(Popularity:Plan.to.Watch))%>%
  group_by(Genres)%>%
  summarise(avg_score = round(mean(Score),2),
            total_anime = n())

user_watch <- read.csv("user_watch.csv")
anime = anime %>% mutate(anime_id = MAL_ID
)
user_watch = right_join(anime, user_watch, by = 'anime_id') %>%
  select(-anime_id) %>%
  filter(!is.na(user_id) == TRUE,
         !is.na(Score) == TRUE)
ScoreSD = summarise(group_by(user_watch, user_id),ScoreSD = round(sd(Score), 2))
AvgScore = summarise(group_by(user_watch, user_id),AvgScore = round(mean(Score), 2))

Completed = user_watch %>%
  filter(watching_status == 2) %>%
  group_by(user_id) %>%
  count(user_id)%>%
  mutate(Completed = n) %>%
  select(-2)

Watching = user_watch %>%
  filter(watching_status == 1) %>%
  group_by(user_id) %>%
  count(user_id)%>%
  mutate(Watching = n) %>%
  select(-2)

Dropped = user_watch %>%
  filter(watching_status == 4) %>%
  group_by(user_id) %>%
  count(user_id)%>%
  mutate(Dropped = n) %>%
  select(-2)

FavoriteGenres = user_watch %>%
  group_by(user_id, Genres) %>%
  count(user_id) %>%
  mutate(count = n) %>%
  select(-3) %>%
  group_by(user_id) %>%
  top_n(n=1,wt=count)%>%
  select(-3)%>%
  rename(FavoriteGenres = Genres)

user_table = FavoriteGenres %>%
  inner_join(AvgScore, by = 'user_id')%>%
  inner_join(ScoreSD, by = 'user_id')%>%
  inner_join(Completed, by = 'user_id')%>%
  inner_join(Watching, by = 'user_id')%>%
  inner_join(Dropped, by = 'user_id')

anime_view = anime %>%
  group_by(Genres,Year)%>%
  summarise(
    avg_drop_rate = mean(Dropped/(Plan.to.Watch+Completed+Watching)),
    avg_complete_rate = mean(Completed/(Plan.to.Watch+Completed+Watching))
  )