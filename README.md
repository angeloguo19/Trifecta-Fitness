# Trifecta Fitness

With gyms closed due to the coronavirus pandemic, staying active is harder now than ever. We were inspired to create an app to help people stay fit and healthy at home. 

## Features
- Isolated fitness becomes a social activity by allowing users to challenge their friends to competitions and compare workout stats.
- Mental health is encouraged through our meditation feature where users can track their meditiation sessions on the app. 
- Users can also make healthy meals they find in our recipies tab where users can search any food they like and learn how to make it.


## Video 
[Presentation](https://duke.zoom.us/rec/play/v8Uodeiuqzo3GdKW4wSDB_N6W9W9KPqshihLq_MKmk_kUiRXZAelZuAVZntibyBb9ArOilrGI94PEns?continueMode=true)

## Architecture
- Charts cocoapod: Used to create the Meditation Graph
- Spoonacular Recipe API: Used to search for different recipes
- Custom API: Made to store/retrieve user workout data and allow users to challenge each other

## Contributions
### Oliver Rodas
*  I created a custom API for my team to use. It allows for the creation of various user accounts that contain the statistical data for each user as well as the information for challenges between users. The API creates a leaderboard that updates when a player adds to their progress. The API returns success messages, leaderboard data, and user data. 
*  I created a theme for the application. I wanted the app to have a smooth, modern look. I made every clickable surface a similar color so that a user could easily navigate through controllers and the api calls I used. I added animations between transistions to add flair to the design. I worked on every view controller and assisted my partners in their designs. 
*  I increased the efficiency and speed of the app by creating modules that could be copy and pasted into other view controllers with minor tweaks. I also reduced the number of API calls the application used by passing information through segways whenever applicable. To increase speed, one API call can fill various tables with information and can be used for a variety of purposes. 

### Angelo Guo
*  I implemented the UserDefaults which stores user's data for each workout statistic. In the workouts tab, I added functionality for the user to update their progress by adding the number of reps they've completed. This updates UserDefaults and also calls Oliver's API to update the user's information file.
I also added video tutorials for each workout, which are stored in UserDefaults. These are then loaded in each workout view controller through a Youtube request and displayed in a web view. 

### Loten Lhatsang
*  Worked on account creation, logging in, and home page view controllers. Interacted with server calls through sending and receiving data that is updated and displayed. 
*  For login and creating a new account, userdefault was used to save the username onto the app. This username would be used to fetch and update data of challenges and stats for the corresponding user. App properly checks to see if username exists when logging in and creating a new user to ensure functionality for users. 
*  Worked on the leaderboard view controller which fetches data from server and worked on pieces of UI.

### Sergio Wallace
*  Created the basic storyboard layout that people added onto
*  Helped change UI colors for different view controllers
*  Created a timer that sounds a notification when timer finishes. Made timer use start, pause, and reset button. Alert that can automatically update data. Made meditation data use core data to store and retrieve data. Used a Charts cocoapod to display a bar chart with meditation data.
*  Found spoonacular api that can give recipe data. Uses 2 api calls to get data. Passed data to another view controller to display the data more succinctly. Made alerts so that user puts in correct info into search field

### Amr Bedawi
*  Created and coded the challenges view controllers and the add a new challenge view controller. Interacted with custom server API to retrieve challenges.