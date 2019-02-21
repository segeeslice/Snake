# v1.1.0

### Changes
- Added AI capability in the "AI" mode *(selectable in top left)*
  - Rudimentary AI loosely based on neural networking principles
  - Tends to get trapped in itself, so not the smartest yet
- AI speed reduced to 1/5 the original

___
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
