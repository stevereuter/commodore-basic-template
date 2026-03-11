import { getImageAsync } from "./asset.mjs";
import { drawBackground } from "./draw.mjs";

const background = await getImageAsync("loading-screen.png");

drawBackground(background);
