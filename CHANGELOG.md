# v1.3.1
### New Features
- Show the death state of the snake upon losing
    - When running into a wall, **head** turns black to indicate where it was upon death
    - When running into body part, the **body part** turns black to indicate failure direction
- Added a "view board" button upon the snake dying
    - Appears directly under play button
    - Clicking allows the user to see the board as it was upon death
    - This view can be exited via an "X" button in the top right

### Other Changes
- Improved Brute AI
    - Search for a path to the tail upon finding the food
    - Ensures it will have a way to escape from wherever the food is
    - If paths to food are found, but none have a path to the tail, a "backup" path is used
- Brute AI now simply kills itself instantly if no path is found
    - Indicated by point right behind head turning black (snake forceably turns completely around)

<br/>

# v1.3.0
### New Features
- Added "Brute" mode!
    - AI that uses a A\*-based search algorithm to find a path to the food
    - Selectable via the difficulty alongside the original AI
    - Tends to get trapped still, but generally does much better than neural network
- Colorized the snake with gradient to more easily see where it is moving

### Other Changes
- Renamed "AI" mode to "Neural"
- Fixed bug where very last point was ignored for collision

<br/>

# v1.2.0
### Changes
- Improved AI to detect and avoid "traps", or areas in which the food is surrounded by 3 walls
  - Average score of ~40 now! (Compared to the previous ~20)

<br/>

# v1.1.0
### Changes
- Added AI capability in the "AI" mode *(selectable in top left)*
  - Rudimentary AI loosely based on neural networking principles
  - Tends to get trapped in itself, so not the smartest yet
- AI speed reduced to 1/5 the original

<br/>

---

# v1.0.0
Base release of the snake game, a functional replica of the old arcade versions.

## General principles
- Snake is controlled with the arrow keys
- Primary objective is to gain points
  - Points gained via eating food (red squares)
  - Eating food also increases size of snake by 3, increasing difficulty
- If the head of the snake runs into the walls or the body of the snake, the game is over

## Other features
- 4 speed difficulties selectable in top left (difficulty increasing respectively):
  - Easy
  - Medium
  - Hard
  - Sanic
- One AI mode selectable in top left
  - Not yet implemented
- Score and high score tracking per difficulty
  - Does not carry over after program close
