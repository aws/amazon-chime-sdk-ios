const { join } = require('path');

const baseConfig = require('./wdio.conf').config;

const { CAT_APP_URL, CAT_LOG_LEVEL, CAT_MOBILE_PLATFORM, CAT_HEADLESS, CAT_DEMO_URL } = process.env;

const CustomService = require('../../dist/services/ScreenCompareService/index').default;
const { buildHelperDemoUrl, requireDemoUrl } = require('../../dist/utils/DemoUrlUtils');

// need to redefine it here as it can't import ts file constant in constants/index.ts
// TODO make sure how it can sync up with constants
const PLATFORM = { IOS: 'ios', ANDROID: 'android' };
const isChrome = browserName => browserName.toLowerCase() === 'chrome';
const isFirefox = browserName => browserName.toLowerCase() === 'firefox';
// const isSafari = (browserName: string): boolean => browserName.toLowerCase() === 'safari';
// const isEdge = (browserName: string): boolean => browserName.toLowerCase() === 'edge';
const createCapability = ({
  browserName,
  browserVersion = null,
  osName = null,
  osVersion = null,
  headless = false,
  isLocal = true,
}) => {
  return {
    browserName,
    ...(!!browserVersion && { version: browserVersion }),
    ...(!!osName && { os: osName }),
    ...(!!osVersion && { os_version: osVersion }),
    ...(isChrome(browserName) && {
      'goog:chromeOptions': {
        args: [
          // ...(headless ? ['--headless', '--disable-gpu'] : []),
          '--use-fake-ui-for-media-stream',
          '--use-fake-device-for-media-stream',
        ],
        prefs: {
          'profile.managed_default_content_settings.notifications': 1,
        },
      },
    }),
    ...(isFirefox(browserName) && {
      'moz:firefoxOptions': {
        args: [...(JSON.parse(CAT_HEADLESS) ? ['-headless'] : [])],
        prefs: {
          'media.navigator.streams.fake': true,
          'media.navigator.permission.disabled': true,
        },
      },
    }),
    ...(isLocal && {
      'cjson:metadata': {
        browser: {
          name: browserName,
          version: browserVersion,
        },
        platform: {
          name: osName,
          version: osVersion,
        },
      },
    }),
  };
};

const sharedMobileConfig = {
  'appium:noReset': false,
  'appium:newCommandTimeout': 240,
  'appium:app': CAT_APP_URL,
};

const configIOS = {
  ...sharedMobileConfig,
  platformName: 'iOS',
  'appium:orientation': 'PORTRAIT',
  // `automationName` will be mandatory, see
  // https://github.com/appium/appium/releases/tag/v1.13.0
  // The path to the app
  'appium:automationName': 'XCUITest',
  // Read the reset strategies very well, they differ per platform, see
  // http://appium.io/docs/en/writing-running-appium/other/reset-strategies/
};

// IOS configuration local dev and real devices
const localConfigIOS = {
  'appium:deviceName': 'IOS',
  'appium:udid': 'auto',
  xcodeSigningId: 'iPhone Developer',
  // Apple Developer Team ID used to sign WebDriverAgent on a local device.
  xcodeOrgId: process.env.XCODE_ORG_ID,
  'appium:showIOSLog': true,
  'appium:autoAcceptAlerts': true,
  // see https://github.com/appium/appium/issues/13745
  simpleIsVisibleCheck: true,
};

// Android Configuration
const configAndroid = {
  ...sharedMobileConfig,
  platformName: 'Android',
  'appium:deviceName': process.env.DEVICEFARM_DEVICE_NAME || 'Android',
  'appium:udid': process.env.DEVICEFARM_DEVICE_NAME || undefined,
  'appium:orientation': 'PORTRAIT',
  'appium:automationName': 'UiAutomator2',
  'appium:appWaitActivity': '*',
  'appium:autoGrantPermissions': true,
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
  const config = {
    ...baseConfig,
    maxInstances: 1,
    capabilities: {
      targetDevice: {
        capabilities: buildLocalCap(),
        port: 4723,
      },
      helperBrowser: {
        capabilities: createCapability({ browserName: 'chrome' }),
        baseUrl: buildHelperDemoUrl(requireDemoUrl(CAT_DEMO_URL)),
      },
    },
    services: ['selenium-standalone', 'appium', [CustomService]],
    nativeAppCompare: {
      baselineFolder: join(process.cwd(), './baselines/'),
      formatImageName: '{tag}-{logName}-{width}x{height}',
      screenshotPath: join(process.cwd(), '/tmp/'),
      savePerInstance: true,
      autoSaveBaseline: true,
      blockOutStatusBar: true,
      blockOutToolBar: true,
    },
    appium: {
      command: 'appium',
    },
    logLevel: CAT_LOG_LEVEL,
  };
  return config;
}

exports.config = buildConfig();
exports.createCapability = createCapability;
