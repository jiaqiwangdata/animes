# Anime Users Analysis


## Overview

Nowadays, young people are interested in anime, and there are a bunch of anime-related apps and websites. Driven by the motivation to provide insights to app and website providers, we have conducted an analysis of existing user profiles and anime profiles based on data from the MyAnimeList website. Additionally, we aim to make better recommendations based on this analysis.

[ANIME WITH U!](https://jiaqiwangcelia.shinyapps.io/app_final_revised/)

## Data Source

Our original data was obtained from Kaggle, specifically the [Anime Recommendation Database 2020](https://www.kaggle.com/hernan4444/anime-recommendation-database-2020?select=animelist.csv). Our datasets include two parts: anime and user data.

- The "anime" dataset includes information about anime, such as name, genre, episodes, scores, and the number of users watching or completing it.
- The "user" dataset contains user information, including their scores for each anime and watching statuses.

## Project Features

### 1. Find Your Favorite Anime
<img width="416" alt="image" src="https://github.com/celiawangjq/animes/assets/91340312/d79efc48-28f3-4d8c-b539-36c345ccea97">


By filtering ratings, seasons, and more, users can find anime that fit their taste.

### 2. Top Picks
<img width="416" alt="image" src="https://github.com/celiawangjq/animes/assets/91340312/fb267812-02ce-46c8-a5e9-09bee063869f">


We list anime information using several methods. Users can find their favorite anime based on top 10 scored anime, the top 1 anime in different genres, years, and ratings. They can also choose the columns to display and select the number of anime episodes.

### 3. Overview
<img width="416" alt="image" src="https://github.com/celiawangjq/animes/assets/91340312/8567c1de-a5b6-4895-88c7-fc65e4cb8f8b">


Users, especially website providers, can gain insight into the average score and the total number of anime in different seasons and genres of the same year. This information helps them decide when and which kind of anime to feature.

### 4. User Profile
<img width="416" alt="image" src="https://github.com/celiawangjq/animes/assets/91340312/ecff2eb0-e0db-4211-9ddb-80d79c55db51">


We analyze users' watching preferences, including their favorite genres (determined by the number of anime watched in each genre), the average score of the anime they've watched, and the standard deviation of scores. Additionally, we provide information on the number of anime they have completed, are currently watching, and have dropped. This dashboard offers a better understanding of user preferences.

### 5. Anime Profile
<img width="416" alt="image" src="https://github.com/celiawangjq/animes/assets/91340312/0d586b12-f341-42dd-8464-73e00fc26e16">


We calculate the average drop rate and average completion rate in different genres of anime.

### 6. Your Anime Information
<img width="416" alt="image" src="https://github.com/celiawangjq/animes/assets/91340312/3416e445-c4fa-4bda-9d0a-f6862c775ec5">


Users can enter the name of an anime they choose to see basic information as well as overall watching information for that anime.

## Deployment

You can access the interactive R Shiny web application here: [ANIME WITH U!](https://jiaqiwangcelia.shinyapps.io/app_final_revised/)

Please note:
- Due to the inclusion of GIFs in our app, it may take some time to load completely.

---

**Important Links:**
- [MyAnimeList](https://myanimelist.net)
- [Kaggle Anime Recommendation Database](https://www.kaggle.com/hernan4444/anime-recommendation-database-2020?select=animelist.csv)
- [RStudio.io Deployment](https://jiaqiwangcelia.shinyapps.io/app_final_revised/)

---


