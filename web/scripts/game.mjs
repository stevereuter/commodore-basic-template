import { waitForClickAsync } from "./dom.mjs";
import { drawBackground, initContextsAsync, Scene } from "./draw.mjs";

function initIntro() {
    // TODO: add intro assets and logic
    alert("Welcome to the game! Click OK to continue.");
}

function introLoop() {
    // TODO: add intro animation logic
    alert("Intro loop placeholder. Click OK to start the game.");
}

export async function loadGameAsync() {
    await initContextsAsync();
    // loading screen
    drawBackground(Scene.LoadingBackground);
    await waitForClickAsync();
    initIntro();
    introLoop();
}
