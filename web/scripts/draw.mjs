/** @type {CanvasRenderingContext2D} */
const backgroundContext = document
    .getElementById("game-background")
    .getContext("2d");

/** @type {CanvasRenderingContext2D} */
const foregroundContext = document
    .getElementById("game-foreground")
    .getContext("2d");

/** @type {CanvasRenderingContext2D} */
const mainContext = document.getElementById("game-main").getContext("2d");

/**
 * @description draws background image
 * @param {HTMLImageElement} image
 */
export function drawBackground(image) {
    backgroundContext.drawImage(image, 0, 0);
}
