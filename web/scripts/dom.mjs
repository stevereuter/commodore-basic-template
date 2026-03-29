import { Key, keyDownHandler, keyUpHandler } from "./keyboard.mjs";

const controlElements = {
    [Key.UP]: document.querySelector("#up"),
    [Key.DOWN]: document.querySelector("#down"),
    [Key.LEFT]: document.querySelector("#left"),
    [Key.RIGHT]: document.querySelector("#right"),
    [Key.FIRE]: document.querySelector("#fire"),
    [Key.PAUSE]: document.querySelector("#pause"),
    [Key.QUIT]: document.querySelector("#quit"),
};

export const CanvasIds = {
    Background: "game-background",
    Foreground: "game-foreground",
    Main: "game-main",
};

const canvases = new Map();
Object.values(CanvasIds).forEach((id) => {
    canvases.set(id, document.querySelector(`#${id}`));
});
// keyboard events
document.addEventListener("keydown", keyDownHandler);
document.addEventListener("keyup", keyUpHandler);
// // touch events for mobile
// Object.entries(controlElements).forEach(([key, element]) => {
//     element.addEventListener("touchstart", (e) => {
//         keyDownHandler({ ...e, key });
//     });
//     element.addEventListener("touchend", (e) => {
//         keyUpHandler({ ...e, key });
//     });
// });

export function getCanvases() {
    return {
        [CanvasIds.Background]: canvases.get(CanvasIds.Background),
        [CanvasIds.Foreground]: canvases.get(CanvasIds.Foreground),
        [CanvasIds.Main]: canvases.get(CanvasIds.Main),
    };
}

export function waitForClickAsync() {
    return new Promise((resolve) => {
        const handleClick = () => {
            document.removeEventListener("click", handleClick);
            resolve();
        };
        document.addEventListener("click", handleClick);
    });
}
