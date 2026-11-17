import { join, normalize } from "path";
import {
  ACTUAL,
  DEFAULT_BASELINE_FOLDER,
  DEFAULT_IMAGE_FORMAT_NAME,
  DEFAULT_SCREENSHOTS_FOLDER,
  DIFF
} from "./helpers/constants";
import compareScreen from "./commands/compareScreen";
import compareElement from "./commands/compareElement";
import saveElement from "./commands/saveElement";
import saveScreen from "./commands/saveScreen";
import {
  defaultCompareOptions,
  initOptions,
  ScreenCompareServiceOption,
  NativeAppCompareOption,
  ScreenCompareServiceInputOption
} from "./helpers/options";
import { getAndCreatePath } from "./helpers/utils";

/**
 * The webdriver.io native app compare class
 *
 * @constructor
 * @class WdioNativeAppCompare
 * @param {object}  browser The webdriver instance
 * @param {object}  options
 * @param {boolean} options.autoSaveBaseline If no baseline image is found the image is automatically copied to the baselinefolder
 * @param {string}  options.baselineFolder Path to the baseline folder
 * @param {boolean} options.blockOutStatusBar If the statusbar on mobile / tablet needs to blocked out by default
 * @param {string}  options.screenshotPath Path to the folder where the screenshots are saved
 * @param {boolean} options.debug Add some extra logging and always save the image difference (default:false)
 * @param {boolean} options.ignoreAlpha compare images and discard alpha
 * @param {boolean} options.ignoreAntialiasing compare images and discard anti aliasing
 * @param {boolean} options.ignoreColors Even though the images are in colour, the comparison wil compare 2 black/white images
 * @param {boolean} options.ignoreLess compare images and compare with red = 16, green = 16, blue = 16, alpha = 16, minBrightness=16,
 *                  maxBrightness=240
 * @param {boolean} options.ignoreNothing compare images and compare with red = 0, green = 0, blue = 0, alpha = 0, minBrightness=0,
 *                  maxBrightness=255
 * @param {number}  options.imageNameFormat Custom variables for the image name (default:{tag}-{deviceName})
 * @param {number}  options.largeImageThreshold Enable skipping pixels during the comparison to mitigate performance issues based on a
 *                  amount of pixels (width / height), default 0
 * @param {boolean} options.rawMisMatchPercentage default false. If true the return percentage will be like 0.12345678, default is 0.12
 * @param {number}  options.saveAboveTolerance Allowable value of misMatchPercentage that prevents saving image with differences
 * @param {number}  options.savePerDevice Save the images per device in a separate folder
 */
export default class WdioNativeAppCompare {
  private options: ScreenCompareServiceInputOption & NativeAppCompareOption;
  private autoSaveBaseline: boolean;
  private compareOptions: ScreenCompareServiceOption;
  private formatString: string;
  private savePerDevice: boolean;
  private imageNameFormat: string;
  private capabilities: any;
  private folders: any;
  constructor(options: ScreenCompareServiceInputOption) {
    this.options = initOptions(options);
  }

  /**
   * Gets executed before test execution begins. At this point you can access to all global
   * variables like `browser`. It is the perfect place to define custom commands.
   *
   * @param {Array.<Object>} capabilities list of capabilities details
   */
  before(capabilities: any) {
    const nativeAppCompareOptions = this.options;
    this.autoSaveBaseline = nativeAppCompareOptions.autoSaveBaseline || false;
    this.compareOptions = defaultCompareOptions(nativeAppCompareOptions);
    this.formatString =
      nativeAppCompareOptions.imageNameFormat || DEFAULT_IMAGE_FORMAT_NAME;
    this.savePerDevice = nativeAppCompareOptions.savePerDevice || false;

    this.capabilities = capabilities;

    // Determine folders
    const baselineFolder = normalize(
      nativeAppCompareOptions.baselineFolder || DEFAULT_BASELINE_FOLDER
    );
    const baseFolder = normalize(
      nativeAppCompareOptions.screenshotPath || DEFAULT_SCREENSHOTS_FOLDER
    );

    this.folders = {
      actual: getAndCreatePath(
        this.capabilities,
        join(baseFolder, ACTUAL),
        this.savePerDevice
      ),
      baseline: getAndCreatePath(
        this.capabilities,
        baselineFolder,
        this.savePerDevice
      ),
      diff: getAndCreatePath(
        this.capabilities,
        join(baseFolder, DIFF),
        this.savePerDevice
      )
    };
    if (!Array.isArray(capabilities)) {
      // Multi-remote pattern
      Object.keys(capabilities).forEach(capability => {
        // @ts-ignore
        const currentBrowser = global[capability];
        currentBrowser.addCommand("saveElement", saveElement.bind(this));
        currentBrowser.addCommand("compareElement", compareElement.bind(this));
        currentBrowser.addCommand("saveScreen", saveScreen.bind(this));
        currentBrowser.addCommand("compareScreen", compareScreen.bind(this));
      });
    }
    browser.addCommand("saveElement", saveElement.bind(this));
    browser.addCommand("compareElement", compareElement.bind(this));
    browser.addCommand("saveScreen", saveScreen.bind(this));
    browser.addCommand("compareScreen", compareScreen.bind(this));
  }
}
