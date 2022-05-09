# WordGame
Currently, this *WordGame* uses Spanish and English word translations but it can be used for different languages without having to modify any code. A 
word falls from the start of the screen and its translation is shown in the middle of the screen. The player has to guess if the word and translation 
both match or not. If player makes _15_ total attempts or _3_ wrong attempts, the current round ends and the player is asked if they want to play this 
game again or quit from the app.

# App Architecture
It uses simple _MVVM_ pattern with dependency initializer based dependency injection.
There is only one Screen in the app. The app has test cases written for WordAttemptsViewController and WordAttemptsViewModel

# Enhancements
* We can use translations for a different language. This is already done from coding point, we just need to provide a separate json file.
* If there were different screens and navigations involved, we could have considered using _MVVM-C_ patter
* We can use sentences rather than just words.
* We can improve error handling.
* We can show the timer to user which may give better user experience
* We can show the alert in a separate custom screen
* We can consider fetching the list of words from internet rather than just hardcooding in the application

## Time effort
* The time effort put in is roughly between 6-8 hours
### Time Distribution
* Planning: The app is fairly simple, so it took ~10 mins
* UI: Designing the UI roughly took 1 hour
* Model Layer: Creating the models, reading data from disk roughly took 1 hour
* ViewModel: Creating and incrementally updating the ViewModel roughly took 2-3 hours
* ViewController: Adding logic in ViewController and setting it up with ViewModel took 2-3 hours
* Writing different TestCases for ViewController and ViewModel took ~2 hours

### Decisions made
* Should the _timer_ object be stored in a ViewController or ViewModel
* Use _System Alert_ for popup rather than creating a separate custom popup screen

### Given more time
* Given more time, we could add more meaningful UITestCases.
