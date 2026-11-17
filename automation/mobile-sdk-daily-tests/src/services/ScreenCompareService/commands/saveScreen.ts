/* eslint-disable no-console */
import { takeBase64Screenshot } from "../methods/takeBase64Screenshot";
import { determineFileData } from "../helpers/utils";
import { saveBase64Image } from "../methods/saveBase64Image";

/**
 * Save a screen
 *
 * @param {string} tag The tag of the image name
 *
 * @example
 *  browser.saveScreen('tag-name-of-image');
 *
 * @return {Promise<{
 *  base64Screenshot: string,
 *  fileName: string,
 *  folders: {
 *      actual: string,
 *  },
 * }>}
 */
export default async function saveScreen(
  this: any,
  tag: string,
  currentBrowser: WebdriverIO.BrowserObject = browser,
  isBase: boolean = false
): Promise<{
  base64Screenshot: string;
  fileName: string;
  folders: { actual: string };
}> {
  // Determine file data
  const fileData = determineFileData(
    this.capabilities,
    isBase ? this.folders.baseline : this.folders.actual,
    this.formatString,
    tag
  );

  // Take the screenshot
  const base64Screenshot = takeBase64Screenshot(currentBrowser);

  // Save the screenshot
  await saveBase64Image(fileData.filePath, base64Screenshot);

  // Return the screenshot data
  return {
    base64Screenshot,
    fileName: fileData.fileName,
    folders: {
      actual: this.folders.actual
    }
  };
}
