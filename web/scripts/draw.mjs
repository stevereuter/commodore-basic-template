import { Asset, getAssetsAsync } from "./asset.mjs";
import { CanvasIds, getCanvases } from "./dom.mjs";

const WIDTH = 384;
const HEIGHT = 272;
export const Screen = {
    X: 40,
    Y: 25,
};
export const Scene = {
    LoadingBackground: 0,
    // TitleBackground: 1,
    // GameBackground: 2,
    // GameOverForeground: 3,
    // ReadyForeground: 4,
    // SetForeground: 5,
    // GoForeground: 6,
};
const contexts = new Map();
const images = new Map();

export async function initContextsAsync() {
    contexts.clear();
    const canvases = getCanvases();
    Object.entries(canvases).forEach(([key, canvas]) => {
        contexts.set(key, canvas.getContext("2d"));
    });
    const [backgroundImage, spritesImage] = await getAssetsAsync();
    images.set(Asset.Screens, backgroundImage);
    images.set(Asset.Sprites, spritesImage);
}

function drawImageInContext(
    context,
    image,
    sx,
    sy,
    sWidth,
    sHeight,
    dx,
    dy,
    dWidth,
    dHeight,
) {
    context.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
}

/**
 * @description draws background image
 * @param {Scene} screen
 */
export function drawBackground(screen = Scene.LoadingBackground) {
    const image = images.get(Asset.Screens);
    const sectionWidth = image.width / 1;
    const x = screen * sectionWidth;
    const backgroundContext = contexts.get(CanvasIds.Background);
    drawImageInContext(
        backgroundContext,
        image,
        x,
        0,
        sectionWidth,
        image.height,
        0,
        0,
        WIDTH,
        HEIGHT,
    );
}
