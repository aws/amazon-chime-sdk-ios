import { DEFAULT_RESIZE_DIMENSIONS } from "../helpers/constants";
import { nativeAppCompareLog } from "../helpers/logger";
import { Rect, Dimension } from "./rectangles";

const { createCanvas, loadImage } = require("canvas");

/**
 * Save a (cropped) canvas screen
 *
 * @param {string}  screenshot
 * @param {object}  rectangles
 * @param {object}  resizeDimensions
 *
 * @return {Promise<string>}
 */
export async function makeCroppedBase64Image(
  screenshot: string,
  rectangles: Rect,
  resizeDimensions: Dimension
): Promise<string> {
  const { top, right, bottom, left } = {
    ...DEFAULT_RESIZE_DIMENSIONS,
    ...resizeDimensions
  };
  const { height, width, x, y } = rectangles;
  const canvasWidth = width + left + right;
  const canvasHeight = height + top + bottom;
  const canvas = createCanvas(canvasWidth, canvasHeight);
  const image = await loadImage(`data:image/png;base64,${screenshot}`);
  const ctx = canvas.getContext("2d");

  let sourceXStart = x - left;
  let sourceYStart = y - top;

  if (sourceXStart < 0) {
    nativeAppCompareLog.warn(`
#####################################################################################
 THE RESIZE DIMENSION LEFT '${left}' MADE THE CROPPING GO OUT OF
 THE IMAGE BOUNDARIES RESULTING IN AN IMAGE STARTPOSITION '${sourceXStart}'.
 THIS HAS BEEN DEFAULTED TO '0'
#####################################################################################
`);
    sourceXStart = 0;
  }

  if (sourceYStart < 0) {
    nativeAppCompareLog.warn(`
#####################################################################################
 THE RESIZE DIMENSION LEFT '${top}' MADE THE CROPPING GO OUT OF
 THE IMAGE BOUNDARIES RESULTING IN AN IMAGE STARTPOSITION '${sourceYStart}'.
 THIS HAS BEEN DEFAULTED TO '0'
#####################################################################################
`);
    sourceYStart = 0;
  }

  ctx.drawImage(
    image,
    // Start at x/y pixels from the left and the top of the image (crop)
    sourceXStart,
    sourceYStart,
    // 'Get' a (w * h) area from the source image (crop)
    canvasWidth,
    canvasHeight,
    // Place the result at 0, 0 in the canvas,
    0,
    0,
    // With as width / height: 100 * 100 (scale)
    canvasWidth,
    canvasHeight
  );

  return canvas.toDataURL().replace(/^data:image\/png;base64,/, "");
}
