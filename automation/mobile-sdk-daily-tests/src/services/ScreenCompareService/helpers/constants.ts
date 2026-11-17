export const ACTUAL = "actual";
export const DEFAULT_IMAGE_FORMAT_NAME = "{tag}-{deviceName}";
export const DEFAULT_BASELINE_FOLDER = "./baseline";
export const DEFAULT_RESIZE_DIMENSIONS = {
  top: 0,
  right: 0,
  bottom: 0,
  left: 0
};
export const DEFAULT_SCREENSHOTS_FOLDER = "./.tmp/screenshots";
export const DIFF = "diff";

export const NAVIGATION_BAR_SELECTORS = {
  ANDROID: '//*[@resource-id="android:id/navigationBarBackground"]'
};
export const NO_DEVICE_NAME = "no-device-name-in-caps";
export const STATUS_BAR_SELECTORS = {
  IOS: "//XCUIElementTypeStatusBar",
  ANDROID: '//*[@resource-id="android:id/statusBarBackground"]'
};

//=====================
// iPhone X-series data
//=====================
export const IPHONE_X_SIZE = 812;
export const IPHONE_X_MAX_SIZE = 896;
export const IPHONE_X_DEFAULT_HOME_BAR = {
  bottom: 15,
  right: 402,
  left: 362,
  top: 2397
};
export const IPHONE_X_LARGE_HOME_BAR = {
  bottom: 15,
  right: 444,
  left: 399,
  top: 2649
};
