/**
 * @description get image
 * @param {string} filename image filename
 * @returns {Promise<HTMLImageElement>} image
 */
export function getImageAsync(filename) {
    return new Promise((resolve) => {
        const image = new Image();
        image.src = `images/${filename}`;
        image.onload = () => resolve(image);
    });
}
