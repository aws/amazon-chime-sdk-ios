import { ensureDirSync } from "fs-extra";
import { resolve } from "path";
import { IPHONE_X_MAX_SIZE, IPHONE_X_SIZE, NO_DEVICE_NAME } from "./constants";
import { Dimension, Rect } from "../methods/rectangles";

/**
 * Create the filename
 *
 * @param {object} capabilities
 * @param {string} formatString
 * @param {string} tag
 *
 * @return {string}
 */
function formatFileName(
  capabilities: any,
  formatString: string,
  tag: string
): string {
  const defaults: any = {
    deviceName: capabilities.deviceName || NO_DEVICE_NAME,
    orientation: capabilities.orientation || "no-orientation-in-caps",
    platformName: capabilities.platformName || "no-platform-name-in-caps",
    platformVersion:
      capabilities.platformVersion || "no-platform-version-in-caps",
    tag
  };

  Object.keys(defaults).forEach(value => {
    formatString = formatString.replace(`{${value}}`, defaults[value]);
  });

  return formatString.replace(/ /g, "_").toLowerCase() + ".png";
}

/**
 * Get and create a folder
 *
 * @param {object}  capabilities
 * @param {string}  capabilities.deviceName
 * @param {string}  folder
 * @param {boolean} savePerDevice
 *
 * @return {string}
 */
function getAndCreatePath(
  capabilities: any,
  folder: string,
  savePerDevice: boolean
): string {
  const { deviceName } = capabilities;
  const deviceFolder = deviceName
    ? deviceName.replace(/ /g, "_").toLowerCase()
    : NO_DEVICE_NAME;
  const folderName = resolve(
    process.cwd(),
    folder,
    savePerDevice ? deviceFolder : ""
  );

  ensureDirSync(folderName);

  return folderName;
}

/**
 * Determine the filename and file path
 *
 * @param {object}  capabilities
 * @param {string}  folder
 * @param {string}  formatString
 * @param {string}  tag
 *
 * @return {
 *  {
 *      fileName: string,
 *      filePath: string,
 *  }
 * }
 */
function determineFileData(
  capabilities: any,
  folder: string,
  formatString: string,
  tag: string
): any {
  const fileName = formatFileName(capabilities, formatString, tag);

  return {
    fileName,
    filePath: resolve(folder, fileName)
  };
}

/**
 * Return the values of an iOS object multiplied against the devicePixelRatio
 *
 * @param   {object} values
 * @param   {number} dpr
 *
 * @return  {object}
 */
function multiplyIosObjectValuesAgainstDPR(
  values: any,
  dpr: number,
  currentBrowser: WebdriverIO.BrowserObject = browser
): Rect | Dimension {
  if (currentBrowser.isIOS) {
    Object.keys(values).map(value => {
      values[value] *= dpr;
    });
  }

  return values;
}

/**
 * Determine if this is an iPhone X series phone
 *
 * @param {object} screenSize
 * @param {number} screenSize.height
 * @param {number} screenSize.width
 *
 * @return {boolean}
 */
function determineIphoneXSeries(
  screenSize: Rect,
  currentBrowser: WebdriverIO.BrowserObject = browser
) {
  return (
    (screenSize.width === IPHONE_X_SIZE ||
      screenSize.height === IPHONE_X_SIZE ||
      screenSize.width === IPHONE_X_MAX_SIZE ||
      screenSize.height === IPHONE_X_MAX_SIZE) &&
    currentBrowser.isIOS
  );
}

/**
 * Determine if this is a large iPhone X series phone
 *
 * @param {object} screenSize
 * @param {number} screenSize.height
 * @param {number} screenSize.width
 *
 * @return {boolean}
 */
function determineLargeIphoneXSeries(
  screenSize: Rect,
  currentBrowser: WebdriverIO.BrowserObject = browser
): boolean {
  return (
    determineIphoneXSeries(screenSize, currentBrowser) &&
    (screenSize.width === IPHONE_X_MAX_SIZE ||
      screenSize.height === IPHONE_X_MAX_SIZE)
  );
}

/**
 * Get the size of a screenshot in pixels
 *
 * @param {string} screenshot
 *
 * @return {
 *  {
 *      width: number,
 *      height: number,
 *  }
 * }
 */
function getScreenshotSize(screenshot: string): any {
  const buffer = Buffer.from(screenshot, "base64");

  if (buffer.toString("ascii", 12, 16) === "CgBI") {
    return {
      width: buffer.readUInt32BE(32),
      height: buffer.readUInt32BE(36)
    };
  }
  return {
    width: buffer.readUInt32BE(16),
    height: buffer.readUInt32BE(20)
  };
}

export {
  formatFileName,
  getAndCreatePath,
  determineFileData,
  multiplyIosObjectValuesAgainstDPR,
  determineIphoneXSeries,
  determineLargeIphoneXSeries,
  getScreenshotSize
};
