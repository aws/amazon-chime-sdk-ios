import { instanceCompareOptions } from '../helpers/options';
import { checkBaselineImageExists } from '../methods/checkBaselineImageExists';
import { executeCompare } from '../methods/executeCompare';

/**
 * Compare an element against a baseline
 *
 * @param {object}  element
 * @param {string}  tag
 * @param {object}  options
 * @param {boolean} options.blockOuts One or multiple block outs on a screen / element can be provided in an Array with objects
 * @param {boolean} options.ignoreAlpha compare images and discard alpha
 * @param {boolean} options.ignoreAntialiasing compare images and discard anti aliasing
 * @param {boolean} options.ignoreColors Even though the images are in colour, the comparison wil compare 2 black/white images
 * @param {boolean} options.ignoreLess compare images and compare with red = 16, green = 16, blue = 16, alpha = 16, minBrightness=16, maxBrightness=240
 * @param {boolean} options.ignoreNothing compare images and compare with red = 0, green = 0, blue = 0, alpha = 0, minBrightness=0, maxBrightness=255
 *
 * @example
 *  // Default
 *  browser.compareElement($('~selector'), 'tag-name-of-image');
 *
 *  // With compare options
 *  browser.compareElement(
 *      $('~selector'),
 *      'tag-name-of-image',
 *      {
 *          ignoreAlpha: true,
 *          ignoreAntialiasing: true,
 *          ignoreColors: false,
 *          // ...
 *      }
 *  );
 *
 *  // With all resize dimensions and ignore alpha
 *  browser.compareElement(
 *      $('~selector'),
 *      'tag-name-of-image',
 *      {
 *          ignoreAlpha: true,
 *          resizeDimensions: {
 *              top: 10,
 *              right: 20,
 *              bottom: 30,
 *              left: 40,
 *          }
 *      }
 *  );
 *
 *  // With only 1 resize dimension and ignore alpha
 *  browser.compareElement(
 *      $('~selector'),
 *      'tag-name-of-image',
 *      {
 *          ignoreAlpha: true,
 *          resizeDimensions: {
 *              left: 10,
 *          }
 *      }
 * );
 *
 * @return {Promise<{
 *      fileName: {string},
 *      folders: {object},
 *      misMatchPercentage: number
 * }>}
 */
export default async function compareElement(
  this: any,
  element: WebdriverIO.Element,
  tag: string,
  options: any = {},
  currentBrowser: WebdriverIO.BrowserObject = browser
): Promise<any> {
  // Determine the element compare options
  const elementCompareOptions = {
    ...this.compareOptions,
    ...instanceCompareOptions(options),
  };

  // Save the element and return the data
  // @ts-ignore
  const elementScreenshotData = await currentBrowser.saveElement(
    element,
    tag,
    currentBrowser,
    options
  );

  // Check if the baseline image exists
  await checkBaselineImageExists(
    this.folders,
    elementScreenshotData.fileName,
    this.autoSaveBaseline
  );

  // Execute the compare and return the compare data
  return await executeCompare(this.folders, elementScreenshotData.fileName, elementCompareOptions);
}
