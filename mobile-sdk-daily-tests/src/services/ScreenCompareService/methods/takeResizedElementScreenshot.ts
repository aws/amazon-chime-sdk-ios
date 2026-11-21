import { DEFAULT_RESIZE_DIMENSIONS } from "../helpers/constants";
import { takeBase64Screenshot } from "./takeBase64Screenshot";
import { getDeviceInfo } from "./getDeviceInfo";
import { makeCroppedBase64Image } from "./makeCroppedBase64Image";
import { getElementRectangles, Dimension } from "./rectangles";

/**
 * Save a resized element screenshot
 *
 * @param {object}  element
 * @param {string}  filePath
 * @param {object}  resizeDimensions
 *
 * @return {Promise<any>}
 *
 * @private
 */
export async function takeResizedElementScreenshot(
  element: WebdriverIO.Element,
  filePath: string,
  currentBrowser: WebdriverIO.BrowserObject = browser,
  resizeDimensions: Dimension = DEFAULT_RESIZE_DIMENSIONS
): Promise<any> {
  // Determine location and size of element
  const elementRectangles = getElementRectangles(element, currentBrowser);

  // Take a screenshot
  const base64Screenshot = takeBase64Screenshot(currentBrowser);

  // Get the device info like screenSize, screenshotHeight, screenshotHeight
  const deviceInfo = getDeviceInfo(base64Screenshot, currentBrowser);

  // Create the cropped screenshot and return it
  return await makeCroppedBase64Image(
    base64Screenshot,
    {
      height: elementRectangles.height * deviceInfo.dpr,
      width: elementRectangles.width * deviceInfo.dpr,
      x: elementRectangles.x * deviceInfo.dpr,
      y: elementRectangles.y * deviceInfo.dpr
    },
    resizeDimensions
  );
}
