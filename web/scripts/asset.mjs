export const Asset = {
    Screens: "web-screens.png",
    Sprites: "web-sprites.png",
};

/**
 * @description get image
 * @param {string} filename image filename
 * @returns {Promise<HTMLImageElement>} image
 */
function getImageAsync(filename) {
    return new Promise((resolve) => {
        const image = new Image();
        image.src = `images/${filename}`;
        image.onload = () => resolve(image);
    });
}

export async function getAssetsAsync() {
    return await Promise.all([
        getImageAsync(Asset.Screens),
        getImageAsync(Asset.Sprites),
    ]);
}
