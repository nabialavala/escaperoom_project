class ScoreService {
  //Calculates the final score using time, hints, mistakes, and difficulty bonus
  int calculateScore({
    required int timeSpent,
    required int hintsUsed,
    required int wrongAttempts,
    required int difficultyBonus,
  }) {
    int score = 1000
        - (timeSpent * 2)
        - (hintsUsed * 50)
        - (wrongAttempts * 25)
        + (difficultyBonus * 100);

    if (score < 0) {
      return 0;
    }

    return score;
  }

  //Assigns a larger bonus when the player completes more levels
  int getDifficultyBonus(int totalLevelsCompleted) {
    if (totalLevelsCompleted >= 10) {
      return 3;
    } else if (totalLevelsCompleted >= 5) {
      return 2;
    } else {
      return 1;
    }
  }
}