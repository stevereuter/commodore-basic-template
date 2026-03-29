const HighScoreKey = "theMunchingMillipedeHighScore";

export function getHighScore() {
    const highScore = localStorage.getItem(HighScoreKey);
    return highScore ? parseInt(highScore, 10) : 0;
}

export function setHighScore(score) {
    const highScore = getHighScore();
    if (score > highScore) {
        localStorage.setItem(HighScoreKey, score.toString());
    }
}
