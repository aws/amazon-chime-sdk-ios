import {
  determineIphoneXSeries,
  determineLargeIphoneXSeries,
  getScreenshotSize
} from "../helpers/utils";

let DEVICE_INFO: any = null;

export interface DeviceInfo {
  dpr: number;
  screenSize: {
    height: number;
    width: number;
  };
  screenshotHeight: number;
  screenshotWidth: number;
  isIphoneXSeries: boolean;
  isLargeIphoneXSeries: boolean;
}

/**
 * Get the device info and store it to a global if needed
 *
 * @param   {string}  screenshot
 *
 * @return  {Promise<{
 *      dpr: number,
 *      screenSize: {
 *          height: number,
 *          width: number,
 *      },
 *      screenshotHeight: number,
 *      screenshotWidth: number,
 *      isIphoneXSeries: boolean,
 *      isLargeIphoneXSeries: boolean,
 * }>}
 */
export function getDeviceInfo(
  screenshot: string,
  currentBrowser: WebdriverIO.BrowserObject = browser
): DeviceInfo {
  if (DEVICE_INFO) {
    return DEVICE_INFO;
  }
  const {
    height: screenshotHeight,
    width: screenshotWidth
  } = getScreenshotSize(screenshot);
  const screenSize = currentBrowser.getWindowSize();
  const isIphoneXSeries = determineIphoneXSeries(screenSize, currentBrowser);
  const isLargeIphoneXSeries = determineLargeIphoneXSeries(
    screenSize,
    currentBrowser
  );

  DEVICE_INFO = {
    dpr: screenshotWidth / screenSize.width,
    screenSize,
    screenshotHeight,
    screenshotWidth,
    isIphoneXSeries,
    isLargeIphoneXSeries
  };

  return DEVICE_INFO;
}
