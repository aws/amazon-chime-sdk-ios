import {
  DEFAULT_BASELINE_FOLDER,
  DEFAULT_SCREENSHOTS_FOLDER
} from "./constants";
import { nativeAppCompareLog } from "./logger";

export interface ScreenCompareServiceOutputOption {
  largeImageThreshold: number;
  errorColor: {
    red: number;
    green: number;
    blue: number;
  };
}
export interface NativeAppCompareOption {
  baselineFolder: string;
  screenshotPath: string;
  formatImageName?: string;
  savePerInstance?: boolean;
  autoSaveBaseline?: boolean;
  blockOutStatusBar?: boolean;
  blockOutToolBar?: boolean;
}

export interface ScreenCompareServiceInputOption {
  blockOuts?: any[];
  blockOutStatusBar?: boolean;
  blockOutNavigationBar?: boolean;
  blockOutIphoneXBottomBar?: boolean;
  elementBlockOuts?: any[];
  debug?: boolean;
  ignore?: any[];
  ignoreAlpha?: boolean;
  ignoreAntialiasing?: boolean;
  ignoreColors?: boolean;
  ignoreLess?: boolean;
  ignoreNothing?: boolean;
  rawMisMatchPercentage?: boolean;
  saveAboveTolerance?: number;
  nativeAppCompare?: NativeAppCompareOption;
  largeImageThreshold?: number;
  resizeDimensions?: boolean;
  imageNameFormat?: string;
  savePerDevice?: boolean;
}

interface ScreenCompareOutput {
  output: ScreenCompareServiceOutputOption;
}

export type ScreenCompareServiceOption = Pick<
  ScreenCompareServiceInputOption,
  Exclude<
    keyof ScreenCompareServiceInputOption,
    "largeImageThreshold" | "nativeAppCompare"
  >
> &
  ScreenCompareOutput;

/**
 * Validate and if needed default the init options
 *
 * @param {object} options
 * @return {{
 *      baselineFolder: string,
 *      screenshotPath: string
 * }}
 */
function initOptions(
  options: ScreenCompareServiceInputOption
): ScreenCompareServiceInputOption & NativeAppCompareOption {
  const init: any = {};

  if (!("nativeAppCompare" in options)) {
    const nativeAppCompareMessage = `'nativeAppCompare'--object is missing in the wdio-config file! 'baselineFolder' set to '${DEFAULT_BASELINE_FOLDER}' and 'screenshotPath' set to '${DEFAULT_SCREENSHOTS_FOLDER}'`;

    nativeAppCompareLog.warn(nativeAppCompareMessage);

    return {
      baselineFolder: DEFAULT_BASELINE_FOLDER,
      screenshotPath: DEFAULT_SCREENSHOTS_FOLDER
    };
  }

  if (!("baselineFolder" in options.nativeAppCompare!)) {
    const baselineFolderMessage = `'nativeAppCompare.baselineFolder'--property is missing in the wdio-config file! 'baselineFolder' set to '${DEFAULT_BASELINE_FOLDER}'`;

    nativeAppCompareLog.warn(baselineFolderMessage);

    init.baselineFolder = DEFAULT_BASELINE_FOLDER;
  }

  if (!("screenshotPath" in options.nativeAppCompare!)) {
    const screenshotsFolderMessage = `'nativeAppCompare.screenshotPath'--property is missing in the wdio-config file! 'screenshotPath' set to '${DEFAULT_SCREENSHOTS_FOLDER}'`;

    nativeAppCompareLog.warn(screenshotsFolderMessage);

    init.screenshotPath = DEFAULT_SCREENSHOTS_FOLDER;
  }

  return { ...init, ...options.nativeAppCompare };
}

/**
 * Determine the default compare options
 *
 * @param {object}  options
 * @param {boolean} options.blockOutStatusBar If the statusbar on mobile / tablet needs to blocked out by default
 * @param {boolean} options.blockOutNavigationBar If the navigation bar on mobile / tablet needs to blocked out by default. This will only
 *   work on Android
 * @param {boolean} options.blockOutIphoneXBottomBar Block out the iPhoneX bottom bar
 * @param {boolean} options.debug Add some extra logging and always save the image difference (default:false)
 * @param {boolean} options.ignoreAlpha compare images and discard alpha
 * @param {boolean} options.ignoreAntialiasing compare images and discard anti aliasing
 * @param {boolean} options.ignoreColors Even though the images are in colour, the comparison wil compare 2 black/white images
 * @param {boolean} options.ignoreLess compare images and compare with red = 16, green = 16, blue = 16, alpha = 16, minBrightness=16,
 *   maxBrightness=240
 * @param {boolean} options.ignoreNothing compare images and compare with red = 0, green = 0, blue = 0, alpha = 0, minBrightness=0,
 *   maxBrightness=255
 * @param {number}  options.largeImageThreshold Enable skipping pixels during the comparison to mitigate performance issues based on a
 *   amount of pixels (width / height), default 0
 * @param {boolean} options.rawMisMatchPercentage default false. If true the return percentage will be like 0.12345678, default is 0.12
 * @param {number}  options.saveAboveTolerance Allowable value of misMatchPercentage that prevents saving image with differences
 *
 * @return {{
 *      blockOutStatusBar: boolean,
 *      blockOutNavigationBar: boolean,
 *      blockOutIphoneXBottomBar: boolean,
 *      debug: boolean,
 *      elementBlockOuts: array,
 *      ignore: array,
 *      ignoreAlpha: boolean,
 *      ignoreAntialiasing: boolean,
 *      ignoreColors: boolean,
 *      ignoreLess: boolean,
 *      ignoreNothing: boolean,
 *      rawMisMatchPercentage: boolean,
 *      saveAboveTolerance: number,
 *      output: {
 *        largeImageThreshold: number,
 *        errorColor: {
 *          red: number,
 *          green: number,
 *          blue: number,
 *        }
 *      }
 *  }}
 */
function defaultCompareOptions(
  options: ScreenCompareServiceInputOption
): ScreenCompareServiceOption {
  return {
    blockOuts: [],
    blockOutStatusBar: options.blockOutStatusBar || false,
    blockOutNavigationBar: options.blockOutNavigationBar || false,
    blockOutIphoneXBottomBar: options.blockOutIphoneXBottomBar || false,
    elementBlockOuts: [],
    debug: options.debug || false,
    ignore: [],
    ignoreAlpha: options.ignoreAlpha || false,
    ignoreAntialiasing: options.ignoreAntialiasing || false,
    ignoreColors: options.ignoreColors || false,
    ignoreLess: options.ignoreLess || false,
    ignoreNothing: options.ignoreNothing || false,
    rawMisMatchPercentage: options.rawMisMatchPercentage || false,
    saveAboveTolerance: options.saveAboveTolerance || 0,
    output: {
      largeImageThreshold: options.largeImageThreshold || 0,
      errorColor: {
        red: 255,
        green: 0,
        blue: 255
      }
    }
  };
}

/**
 * Determine the instance compare options
 *
 * @param {object}  options
 * @param {array}   options.blockOuts One or multiple block outs on a screen / element can be provided in an Array with objects
 * @param {boolean} options.blockOutStatusBar If the statusbar on mobile / tablet needs to blocked out by default
 * @param {boolean} options.blockOutNavigationBar If the navigation bar on mobile / tablet needs to blocked out by default. This will only
 *   work for Android
 * @param {boolean} options.blockOutIphoneXBottomBar Block out the iPhoneX bottom bar
 * @param {array}   options.elementBlockOuts One or multiple elements that need to be blocked out
 * @param {boolean} options.ignoreAlpha compare images and discard alpha
 * @param {boolean} options.ignoreAntialiasing compare images and discard anti aliasing
 * @param {boolean} options.ignoreColors Even though the images are in colour, the comparison wil compare 2 black/white images
 * @param {boolean} options.ignoreLess compare images and compare with red = 16, green = 16, blue = 16, alpha = 16, minBrightness=16,
 *   maxBrightness=240
 * @param {boolean} options.ignoreNothing compare images and compare with red = 0, green = 0, blue = 0, alpha = 0, minBrightness=0,
 *   maxBrightness=255
 * @param {object}  options.resizeDimensions The compare options used as `{top:0, right:0, bottom:0, left:0}`
 *
 * @return {{}}
 */
function instanceCompareOptions(options: ScreenCompareServiceInputOption): any {
  return {
    blockOuts: options.blockOuts || false,
    blockOutStatusBar: options.blockOutStatusBar || false,
    blockOutIphoneXBottomBar: options.blockOutIphoneXBottomBar || false,
    blockOutNavigationBar: options.blockOutNavigationBar || false,
    elementBlockOuts: options.elementBlockOuts || false,
    ignoreAlpha: options.ignoreAlpha || false,
    ignoreAntialiasing: options.ignoreAntialiasing || false,
    ignoreColors: options.ignoreColors || false,
    ignoreLess: options.ignoreLess || false,
    ignoreNothing: options.ignoreNothing || false,
    resizeDimensions: options.resizeDimensions || false
  };
}

export { defaultCompareOptions, initOptions, instanceCompareOptions };
