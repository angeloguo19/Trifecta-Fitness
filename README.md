#Trifecta Fitness and Health

Our goal is to make a social stay-at-home fitness app where users can track their workout data to compare and compete with friends. By making fitness in isolation a more social activity, it becomes easier to workout at home. 

The main feature allows users to challenge their friends. An example of a challenge may be a competition to do x amount of pushups for the week. This will use friendly competition to encourage the user to pursue fitness goals. The fitness portion of the app will also include workout routines and tutorials on how to do them. The meditation portion of the app will include links on how to meditate and guided meditation as well as tracking meditation time. The nutrition portion of the app will allow users to search up different recipes.

## Contributions
### Oliver Rodas
#### API
I created a custom API for my team to use. It allows for the creation of various user accounts that contain the statistical data for each user as well as the information for challenges between users. The API creates a leaderboard that updates when a player adds to their progress. The API returns success messages, leaderboard data, and user data. 
#### UI/UX
I created a theme for the application. I wanted the app to have a smooth, modern look. I made every clickable surface a similar color so that a user could easily navigate through controllers and the api calls I used. I added animations between transistions to add flair to the design. 
#### Architecture
I increased the efficiency and speed of the app by creating modules that could be copy and pasted into other view controllers with minor tweaks. I also reduced the number of API calls the application used by passing information through segways whenever applicable. To increase speed, one API call can fill various tables with information and can be used for a variety of purposes. 
