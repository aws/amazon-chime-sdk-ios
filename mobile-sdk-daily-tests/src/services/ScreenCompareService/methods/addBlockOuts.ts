import { getScreenshotSize } from "../helpers/utils";
import { Dimension } from "./rectangles";

const { createCanvas, loadImage } = require("canvas");

/**
 * Create a canvas with the ignore boxes if they are present
 *
 * @param {string}  screenshot
 * @param {object}  ignoredBoxes
 */
export async function addBlockOuts(
  screenshot: string,
  ignoredBoxes: Dimension[]
) {
  // Create canvas and load image
  const { height, width } = getScreenshotSize(screenshot);
  const canvas = createCanvas(width, height);
  const image = await loadImage(`data:image/png;base64,${screenshot}`);
  const canvasContext = canvas.getContext("2d");

  // Draw the image on canvas
  canvasContext.drawImage(
    image,
    // Start at x/y pixels from the left and the top of the image (crop)
    0,
    0,
    // 'Get' a (w * h) area from the source image (crop)
    width,
    height,
    // Place the result at 0, 0 in the canvas,
    0,
    0,
    // With as width / height: 100 * 100 (scale)
    width,
    height
  );

  // Loop over all ignored areas and add them to the current canvas
  ignoredBoxes.forEach((ignoredBox: Dimension) => {
    const {
      right: ignoredBoxWidth,
      bottom: ignoredBoxHeight,
      left: x,
      top: y
    } = ignoredBox;
    const ignoreCanvas = createCanvas(ignoredBoxWidth, ignoredBoxHeight);
    const ignoreContext = ignoreCanvas.getContext("2d");

    // Add a background color to the ignored box
    ignoreContext.globalAlpha = 0.5;
    ignoreContext.fillStyle = "#39aa56";
    ignoreContext.fillRect(0, 0, ignoredBoxWidth, ignoredBoxHeight);

    // add to canvasContext
    canvasContext.drawImage(ignoreCanvas, x, y);
  });

  // Return the screenshot
  return canvas.toDataURL().replace(/^data:image\/png;base64,/, "");
}
