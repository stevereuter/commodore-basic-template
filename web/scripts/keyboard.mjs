/** @type {Set<string>} */
const keys = new Set();

const keyBuffer = [];

export function getDirectionFromBuffer() {
    return keyBuffer.shift();
}

export function clearKeyBuffer() {
    keyBuffer.length = 0;
}

/** enum {string} */
export const Key = {
    UP: "w",
    DOWN: "s",
    LEFT: "a",
    RIGHT: "d",
    FIRE: " ",
    PAUSE: "p",
    QUIT: "escape",
};

/** @enum {number} Direction */
export const Direction = {
    Right: 1,
    Left: -1,
    Stopped: 0,
    Up: -40,
    Down: 40,
};

function addKeyToBuffer(key) {
    if (keyBuffer.length >= 10) return;
    switch (key) {
        case Key.UP:
            keyBuffer.push(Direction.Up);
            break;
        case Key.DOWN:
            keyBuffer.push(Direction.Down);
            break;
        case Key.LEFT:
            keyBuffer.push(Direction.Left);
            break;
        case Key.RIGHT:
            keyBuffer.push(Direction.Right);
            break;
        default:
            break;
    }
}

/**
 * @description handles key down event
 * @param {Event} event key down event
 */
export function keyDownHandler({ key }) {
    keys.add(key.toLowerCase());
    addKeyToBuffer(key.toLowerCase());
}

/**
 * @description handles key up event
 * @param {Event} event key up event
 */
export function keyUpHandler({ key }) {
    keys.delete(key.toLowerCase());
}

/**
 * @description get direction multiplier
 * @returns {Direction} direction multiplier
 */
export function getDirection() {
    if (keys.has(Key.UP)) return Direction.Up;
    if (keys.has(Key.DOWN)) return Direction.Down;
    if (keys.has(Key.LEFT)) return Direction.Left;
    if (keys.has(Key.RIGHT)) return Direction.Right;
    return Direction.Stopped;
}

/**
 * @description get if firing
 * @returns {boolean} is firing
 */
export function isFiring() {
    return keys.has(Key.FIRE);
}

/**
 * @description gets is pausing
 * @returns {boolean} is pausing
 */
export function isPausing() {
    return keys.has(Key.PAUSE);
}

/**
 * @description gets is quitting
 * @returns {boolean} is quitting
 */
export function isQuitting() {
    return keys.has(Key.QUIT);
}
