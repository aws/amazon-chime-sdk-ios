const { join } = require('path');
const path = require('path');
const baseConfig = require('./wdio.conf').config;

const ANDROID_SUPPORTED_VERSION = ['7', '8', '9', '10', '11', '12'];
// iOS 10 is excluded because the app cannot be installed on Sauce Labs devices.
// iOS 11 and 12 are excluded until a Sauce Labs device issue is resolved.
const IOS_SUPPORTED_VERSION = ['13', '14', '15'];

// We would like to disregard these devices unless SauceLabs fixes these devices to not behave weird
// Vivo V9 had screen lock issue. Huawei Honor 5X has crash on video. LG Phoenix 2 just has disconnection issue
// Samsung Galaxy S7 Edge leave meeting element cannot be found
// Honeywell CK65 has Larger Accessibility Sizes enabled
// iPhone 12 Pro has Larger Accessibility Sizes enabled
// OnePlus_Nord_N200_5G_real_us screen share crash
// Xiaomi_MI_6_real|Xiaomi_Mi_MIX_2_real cannot input in textfield
const ANDROID_DEVICE_NAME_REGEX =
  '^(?!.*(?:Vivo V9$|Huawei Honor 5X$|LG Phoenix 2$|Samsung Galaxy S7 Edge$|OnePlus Nord N200 5G$|Xiaomi MI 6$|Xiaomi Mi MIX 2$|Honeywell CK65$)).*$';
const IOS_DEVICE_NAME_REGEX = '^(?!.*(?:iPhone SE$|iPhone 12 Pro$)).*$';

const getRandomNumber = num => {
  return Math.floor(Math.random() * num);
};

const setSauceStatus = async passed => {
  const passedStr = passed ? 'passed' : 'failed';
  await global.targetDevice.execute(`sauce:job-result=${passedStr}`);
  await global.helperBrowser.execute(`sauce:job-result=${passedStr}`);
};

const {
  CAT_LOG_LEVEL,
  CAT_MOBILE_PLATFORM,
  CAT_PLATFORM_VERSION,
  CAT_DEMO_URL,
  CAT_SAUCE_APP_ID,
  CAT_TEST_TYPE,
  SAUCE_USERNAME,
  SAUCE_ACCESS_KEY,
  CAT_DEV,
  CAT_SAUCE_ENABLE_AUDIO,
} = process.env;
const CustomService = require('../../dist/services/ScreenCompareService/index').default;
const { buildHelperDemoUrl, requireDemoUrl } = require('../../dist/utils/DemoUrlUtils');
const createCapability = require('./wdio.conf.mobile').createCapability;
// need to redefine it here as it can't import ts file constant in constants/index.ts
// TODO make sure how it can sync up with constants
const PLATFORM = { IOS: 'ios', ANDROID: 'android' };

const sharedMobileConfig = {
  'sauce:options': {
    phoneOnly: true,
    sauceLabsImageInjectionEnabled: false,
    audioCapture: CAT_SAUCE_ENABLE_AUDIO === 'true',
  },
  'appium:noReset': false,
  'appium:newCommandTimeout': 5000,
  ...(CAT_SAUCE_APP_ID && { 'appium:app': `storage:${CAT_SAUCE_APP_ID}` }),
};

const configIOS = {
  ...sharedMobileConfig,
  'appium:deviceName': IOS_DEVICE_NAME_REGEX,
  platformName: 'iOS',
  'appium:orientation': 'PORTRAIT',
  // `'appium:automationName'` will be mandatory, see
  // https://github.com/appium/appium/releases/tag/v1.13.0
  // The path to the app
  'appium:automationName': 'XCUITest',
  'appium:platformVersion':
    CAT_PLATFORM_VERSION || IOS_SUPPORTED_VERSION[getRandomNumber(IOS_SUPPORTED_VERSION.length)],
  // simpleIsVisibleCheck: true,
  // autoAcceptAlerts: true,
  // Read the reset strategies very well, they differ per platform, see
  // http://appium.io/docs/en/writing-running-appium/other/reset-strategies/
  'sauce:options': {
    ...sharedMobileConfig['sauce:options'],
    name: 'iOS Mobile SDK Test',
    allowTouchIdEnroll: false,
  },
};

// IOS configuration local dev and real devices
const localConfigIOS = {
  'appium:udid': 'auto',
  'appium:showIOSLog': true,
  // see https://github.com/appium/appium/issues/13745
  // simpleIsVisibleCheck: true,
};

// Android Configuration
const configAndroid = {
  ...sharedMobileConfig,
  'appium:deviceName': ANDROID_DEVICE_NAME_REGEX,
  platformName: 'Android',
  'appium:orientation': 'PORTRAIT',
  'appium:automationName': 'UiAutomator2',
  'appium:appWaitActivity': '*',
  'appium:platformVersion':
    CAT_PLATFORM_VERSION ||
    ANDROID_SUPPORTED_VERSION[getRandomNumber(ANDROID_SUPPORTED_VERSION.length)],
  'appium:autoGrantPermissions': true,
  'sauce:options': {
    ...sharedMobileConfig['sauce:options'],
    name: 'Android Mobile SDK Test Target',
    sauceLabsBypassScreenshotRestriction: true,
    resigningEnabled: false,
    allowTouchIdEnroll: false,
  },
};

function isIOS() {
  return CAT_MOBILE_PLATFORM === PLATFORM.IOS;
}

/**
 * Create a local capability for either IOS or Android
 */
function buildLocalCap() {
  // Assuming we only have two mobile platform
  return isIOS()
    ? {
        ...configIOS,
        ...localConfigIOS,
      }
    : // Android
      {
        ...configAndroid,
      };
}

function buildConfig() {
  const testName = isIOS()
    ? 'iOS Mobile SDK Test Helper Web'
    : 'Android Mobile SDK Test Helper Web';
  const helperBrowserUrl = buildHelperDemoUrl(
    requireDemoUrl(CAT_DEMO_URL),
    CAT_TEST_TYPE === 'canary-gamma' ? 'us-east-1' : undefined
  );

  const config = {
    ...baseConfig,
    maxInstances: 1,
    capabilities: {
      targetDevice: {
        maxInstances: 1,
        protocol: 'https',
        hostname: `${SAUCE_USERNAME}:${SAUCE_ACCESS_KEY}@ondemand.us-west-1.saucelabs.com`,
        port: 443,
        path: '/wd/hub',
        capabilities: buildLocalCap(),
      },
      helperBrowser: {
        maxInstances: 1,
        protocol: 'https',
        hostname: `${SAUCE_USERNAME}:${SAUCE_ACCESS_KEY}@ondemand.saucelabs.com`,
        path: '/wd/hub',
        port: 443,
        capabilities: {
          ...createCapability({ browserName: 'chrome', isLocal: false }),
          platformName: 'macOS 10.14',
          'sauce:options': {
            idleTimeout: 600,
            name: testName,
            tags: [testName],
          },
        },
        baseUrl: helperBrowserUrl,
      },
    },
    services: [[CustomService]],
    nativeAppCompare: {
      baselineFolder: join(process.cwd(), './baselines/'),
      formatImageName: '{tag}-{logName}-{width}x{height}',
      screenshotPath: join(process.cwd(), '/tmp/'),
      savePerInstance: true,
      autoSaveBaseline: true,
      blockOutStatusBar: true,
      blockOutToolBar: true,
    },
    logLevel: CAT_LOG_LEVEL,

    beforeSession: function(config, capabilities, specs) {
      // Need in case it collide with base config
      baseConfig.beforeSession(config, capabilities, specs);
      // Update browser test name
      testPaths = specs[0].split(path.sep);
      if (testPaths.length > 0) {
        const testName = testPaths[testPaths.length - 1].split('.')[0];
        const browserName = capabilities.helperBrowser.capabilities['sauce:options'].name;
        capabilities.helperBrowser.capabilities[
          'sauce:options'
        ].name = `${browserName}-${testName}-${CAT_TEST_TYPE}`;

        // Update real device session name
        const name = capabilities.targetDevice.capabilities['sauce:options'].name;
        capabilities.targetDevice.capabilities[
          'sauce:options'
        ].name = `${name}-${testName}-${CAT_TEST_TYPE}`;
      }
    },
    beforeFeature: function(uri, feature, scenarios) {
      baseConfig.beforeFeature(uri, feature, scenarios);
      // We'll update the status based on feature where it contains multiple scenarios
      sauceFeaturePassed = true;
    },
    /**
     * Runs after a Cucumber scenario
     */
    afterScenario: function(uri, feature, scenario, result, sourceLocation) {
      // Need in case it collide with base config
      baseConfig.afterScenario(uri, feature, scenario, result, sourceLocation);
      if (result.status === 'failed') {
        // If one of scenarios failed, then the whole feature is failed.
        sauceFeaturePassed = false;
      }
    },
    /**
     * Gets executed right after terminating the webdriver session.
     * @param {Object} config wdio configuration object
     * @param {Array.<Object>} capabilities list of capabilities details
     * @param {Array.<String>} specs List of spec file paths that ran
     */
    after: async function(result, capabilities, specs) {
      if (!JSON.parse(CAT_DEV)) {
        helperBrowserSessionId = global.helperBrowser.sessionId;
        targetDeviceSessionId = global.targetDevice.sessionId;
        console.log(
          'Your report url is',
          global.targetDevice.capabilities.testobject_test_report_url
        );
      }
      await setSauceStatus(sauceFeaturePassed);
    },
  };
  return config;
}
exports.config = buildConfig();
