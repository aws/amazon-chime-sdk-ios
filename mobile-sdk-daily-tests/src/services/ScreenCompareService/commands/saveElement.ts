import { determineFileData } from '../helpers/utils';
import { saveBase64Image } from '../methods/saveBase64Image';
import { takeElementScreenshot } from '../methods/takeElementScreenshot';
import { takeResizedElementScreenshot } from '../methods/takeResizedElementScreenshot';

/**
 * Save an element
 *
 * @param {object}  element The element
 * @param {string}  tag
 * @param {object}  options
 *
 * @example
 *  // Default
 *  browser.saveElement('~selector', 'tag-name-of-image');
 *
 *  // With all resize dimensions
 *  browser.saveElement(
 *      '~selector',
 *      'tag-name-of-image',
 *      {
 *          resizeDimensions: {
 *              top: 10,
 *              right: 20,
 *              bottom: 30,
 *              left: 40,
 *          }
 *      }
 *  );
 *
 *  // With only 1 resize dimension
 *  browser.saveElement(
 *      '~selector',
 *      'tag-name-of-image',
 *      {
 *          resizeDimensions: {
 *              left: 10,
 *          }
 *      }
 * );
 *
 * @return {Promise<{
 *  base64Screenshot: string,
 *  fileName: string,
 *  folders: {
 *      actual: string,
 *  },
 * }>}
 */
export default async function saveElement(
  this: any,
  element: WebdriverIO.Element,
  tag: string,
  currentBrowser: WebdriverIO.BrowserObject = browser,
  options: any = {},
  isBase: boolean = false
): Promise<any> {
  // Determine the filedata
  const fileData = determineFileData(
    this.capabilities,
    isBase ? this.folders.baseline : this.folders.actual,
    this.formatString,
    tag
  );

  let base64Screenshot;

  // Create resized element screenshot if needed
  if (options.resizeDimensions) {
    base64Screenshot = await takeResizedElementScreenshot(
      element,
      fileData.fileName,
      options.resizeDimensions
    );
  } else {
    base64Screenshot = await takeElementScreenshot(element, fileData.fileName, currentBrowser);
  }

  // Save the screenshot
  saveBase64Image(fileData.filePath, base64Screenshot);

  // Return the element screenshot data
  return {
    base64Screenshot,
    fileName: fileData.fileName,
    folders: {
      actual: this.folders.actual,
    },
  };
}
