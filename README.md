# Flappy Bird Remake

Flappy Bird Remake is a 2D arcade game developed as a capstone project using Qt 6 and QML. This project aims to replicate the addictive gameplay of the original Flappy Bird, while adding a modern implementation of game mechanics and score management.

## Features

- **Bird Movement and Gravity Simulation**: Smooth animations for bird jumps and gravity effects.
- **Pipe Obstacles**: Dynamically generated obstacles with collision detection.
- **Score Tracking**: Scores are calculated based on the number of pipes passed.
- **High Score Leaderboard**: Stores and displays the top 5 scores persistently using SQLite.
- **User Input Handling**: Support for keyboard (spacebar) and mouse controls.
- **Audio Effects**: Background music and sound effects enhance the player experience.

## Technologies Used

- **Frontend**: 
  - **Qt 6 & QML**: For the game's user interface and animations.
  - **JavaScript**: To manage game logic.
- **Database**:
  - **SQLite**: Stores high scores with fields like ID, Score, and DateTime.

## Architecture

1. **Game Logic**:
   - Real-time animations using SequentialAnimation and Timer.
   - Collision detection for pipes and ground.
   - Functions to handle bird control and game termination.

2. **Score Management**:
   - **saveScore()**: Saves the final score to the database.
   - **fetchTopScores()**: Retrieves the top 5 scores for display.

3. **Graphics**:
   - Bird sprite and animated background tiles.
   - Horizontal scrolling pipes and ground.

4. **UI Design**:
   - Landing page.
   - Gameplay screen.
   - Game-over screen with leaderboard.

## Deployment

- **Source Code**: 
  - [GitHub Repository](https://github.com/moclananhh/QT_QML_FinalProjec_FlappyBird)
  - [GitLab Repository](https://gitlab.com/mlananhh/qt_qml_finalprojec_flappybird)
- **Demo**:
  - [Game Demo Video](https://drive.google.com/file/d/1AUfUFHFF_pjTY2VDWeROqiL5TL3eKKb-/view?usp=sharing)

## Setup and Installation

1. Clone the repository:
   ```bash
     git clone https://github.com/moclananhh/QT_QML_FinalProjec_FlappyBird.git
     cd QT_QML_FinalProjec_FlappyBird ```
  
2. Open the project in Qt Creator IDE.
3. Build and run the project to start the game.
#### Challenges and Solutions
Collision Detection: Optimized real-time monitoring for seamless performance.
Database Integration: Streamlined SQLite queries for efficient score management.
Smooth Animations: Fine-tuned animation properties for a visually engaging experience.
