const { addArgument } = require('@wdio/allure-reporter').default;
const axios = require('axios');
const Base64 = require('js-base64').Base64;
const path = require('path');
const fs = require('fs');
const emitMetrics = require('../../dist/utils/CloudWatchUtils').emitMetrics;

const rootDir = path.join(`${__dirname}`, '..', '..');
const fiveMegaBytes = 5242880;
const hundredFiftyKiloBytes = 153600;
const {
  CAT_LOG_LEVEL,
  CAT_TAG,
  CAT_DEV,
  CAT_MOBILE_PLATFORM,
  CAT_TEST_TYPE,
  CAT_RETRY,
} = process.env;
const stepTimeout = 120000;
let scenarioCounter = 0;
let firstTime = true;
let featurePassed = true;

function getFileSizeInBytes(filePath) {
  const stats = fs.statSync(filePath);
  return stats.size;
}
exports.config = {
  //
  // ====================
  // Runner Configuration
  // ====================
  //
  // WebdriverIO allows it to run your tests in arbitrary locations (e.g. locally or
  // on a remote machine).
  runner: 'local',
  //
  // Override default path ('/wd/hub') for chromedriver service.
  path: '/wd/hub',
  //
  // ==================
  // Specify Test Files
  // ==================
  // Define which test specs should run. The pattern is relative to the directory
  // from which `wdio` was called. Notice that, if you are calling `wdio` from an
  // NPM script (see https://docs.npmjs.com/cli/run-script) then the current working
  // directory is where your package.json resides, so `wdio` will be called from there.
  //
  specs: ['./src/features/**/*.feature'],
  // Patterns to exclude.
  exclude: [
    // 'path/to/excluded/files'
  ],
  //
  // ============
  // Capabilities
  // ============
  // Define your capabilities here. WebdriverIO can run multiple capabilities at the same
  // time. Depending on the number of capabilities, WebdriverIO launches several test
  // sessions. Within your capabilities you can overwrite the spec and exclude options in
  // order to group specific specs to a specific capability.
  //
  // First, you can define how many instances should be started at the same time. Let's
  // say you have 3 different capabilities (Chrome, Firefox, and Safari) and you have
  // set maxInstances to 1; wdio will spawn 3 processes. Therefore, if you have 10 spec
  // files and you set maxInstances to 10, all spec files will get tested at the same time
  // and 30 processes will get spawned. The property handles how many capabilities
  // from the same test should run tests.
  //
  //
  // If you have trouble getting all important capabilities together, check out the
  // Sauce Labs platform configurator - a great tool to configure your capabilities:
  // https://docs.saucelabs.com/reference/platforms-configurator
  //
  //
  // ===================
  // Test Configurations
  // ===================
  // Define all options that are relevant for the WebdriverIO instance here
  //
  // Level of logging verbosity: trace | debug | info | warn | error | silent
  logLevel: CAT_LOG_LEVEL,

  // in debug mode passes --inspect
  //
  // Set specific log levels per logger
  // loggers:
  // - webdriver, webdriverio
  // - @wdio/applitools-service, @wdio/browserstack-service, @wdio/devtools-service, @wdio/sauce-service
  // - @wdio/mocha-framework, @wdio/jasmine-framework
  // - @wdio/local-runner, @wdio/lambda-runner
  // - @wdio/sumologic-reporter
  // - @wdio/cli, @wdio/config, @wdio/sync, @wdio/utils
  // Level of logging verbosity: trace | debug | info | warn | error | silent
  // logLevels: {
  //     webdriver: 'info',
  //     '@wdio/applitools-service': 'info'
  // },
  //
  // If you only want to run your tests until a specific amount of tests have failed use
  // bail (default is 0 - don't bail, run all tests).
  bail: 0,
  sync: true,
  //
  // Set a base URL in order to shorten url command calls. If your `url` parameter starts
  // with `/`, the base url gets prepended, not including the path portion of your baseUrl.
  // If your `url` parameter starts without a scheme or `/` (like `some/path`), the base url
  // gets prepended directly.
  //
  // Default timeout for all waitFor* commands.
  waitforTimeout: 10000,
  //
  // Default timeout in milliseconds for request
  // if Selenium Grid doesn't send response
  connectionRetryTimeout: 200000,
  //
  // Default request retries count
  connectionRetryCount: 2,
  //
  // Test runner services
  // Services take over a specific job you don't want to take care of. They enhance
  // your test setup with almost no effort. Unlike plugins, they don't add new
  // commands. Instead, they hook themselves up into the test process.

  // Framework you want to run your specs with.
  // The following are supported: Mocha, Jasmine, and Cucumber
  // see also: https://webdriver.io/docs/frameworks.html
  //
  // Make sure you have the wdio adapter package for the specific framework installed
  // before running any tests.
  framework: 'cucumber',

  // Test reporter for stdout.
  // The only one supported by default is 'dot'
  // see also: https://webdriver.io/docs/dot-reporter.html
  reporters: [
    'spec',
    [
      'allure',
      {
        outputDir: 'allure-results',
        disableWebdriverStepsReporting: true,
        disableWebdriverScreenshotsReporting: false,
        useCucumberStepReporter: true,
      },
    ],
  ],

  // The number of times to retry the entire specfile when it fails as a whole
  specFileRetries: CAT_RETRY === 'true' ? 2 : 0,
  // 5-second delay between retries
  specFileRetriesDelay: 5,
  // Retry after all other tests have run
  specFileRetriesDeferred: true,

  // If you are using Cucumber you need to specify the location of your step definitions.
  cucumberOpts: {
    sync: true,
    backtrace: false, // <boolean> show full backtrace for errors
    dryRun: false, // <boolean> invoke formatters without executing steps
    failFast: false, // <boolean> abort the run on first failure
    format: ['pretty'], // <string[]> (type[:path]) specify the output format, optionally supply PATH to redirect formatter output (repeatable)
    colors: true, // <boolean> disable colors in formatter output
    snippets: true, // <boolean> hide step definition snippets for pending steps
    source: true, // <boolean> hide source uris
    profile: [], // <string[]> (name) specify the profile to use
    strict: false, // <boolean> fail if there are any undefined or pending steps
    tagExpression: CAT_TAG || '', // <string> (expression) only execute the features or scenarios with tags matching the expression
    timeout: stepTimeout, // <number> timeout for step definitions
    ignoreUndefinedDefinitions: false, // <boolean> Enable this config to treat undefined definitions as warnings
    requireModule: [
      // <string[]> ("extension:module") require files with the given EXTENSION after requiring MODULE (repeatable)
      // 'tsconfig-paths/register',
      () => {
        require('ts-node').register({ files: true });
      },
    ],
    require: ['./src/steps/*.steps.ts'], // <string[]> (file/dir) require files before executing features
  },

  //
  // =====
  // Hooks
  // =====
  // WebdriverIO provides several hooks you can use to interfere with the test process in order to enhance
  // it and to build services around it. You can either apply a single function or an array of
  // methods to it. If one of them returns with a promise, WebdriverIO will wait until that promise got
  // resolved to continue.
  /**
   * Gets executed once before all workers get launched.
   * @param {Object} config wdio configuration object
   * @param {Array.<Object>} capabilities list of capabilities details
   */
  // onPrepare: async function(config, capabilities) {

  // },
  /**
   * Gets executed just before initialising the webdriver session and test framework. It allows you
   * to manipulate configurations depending on the capability or spec.
   * @param {Object} config wdio configuration object
   * @param {Array.<Object>} capabilities list of capabilities details
   * @param {Array.<String>} specs List of spec file paths that are to be run
   */
  beforeSession: function(config, capabilities, specs) {},
  /**
   * Gets executed before test execution begins. At this point you can access to all global
   * variables like `browser`. It is the perfect place to define custom commands.
   * @param {Array.<Object>} capabilities list of capabilities details
   * @param {Array.<String>} specs List of spec file paths that are to be run
   */
  // before: function (capabilities, specs) {
  // },
  before: async function(capabilities, specs) {
    // Checks the file
    if ((CAT_TEST_TYPE === 'canary' || CAT_TEST_TYPE === 'canary-gamma') && firstTime) {
      let successDownload = 0;
      try {
        const mediaFileName =
          CAT_MOBILE_PLATFORM === 'android'
            ? 'amazon-chime-sdk-media.tar.gz'
            : 'AmazonChimeSDKMedia.tar.gz';
        const sdkFileName =
          CAT_MOBILE_PLATFORM === 'android' ? 'amazon-chime-sdk.tar.gz' : 'AmazonChimeSDK.tar.gz';
        if (
          getFileSizeInBytes(path.join(rootDir, mediaFileName)) < fiveMegaBytes ||
          getFileSizeInBytes(path.join(rootDir, sdkFileName)) < hundredFiftyKiloBytes
        ) {
          console.log('Unable to meet minium file size');
        } else {
          console.log('Media and SDK file meets minimum requirement');
          successDownload = 1;
        }
      } catch (err) {
        console.log('File did not exist', err);
      }
      await emitMetrics('DownloadCanary', global.targetDevice.capabilities, 'PRE', successDownload);
    }
  },
  /**
   * Runs before a WebdriverIO command gets executed.
   * @param {String} commandName hook command name
   * @param {Array} args arguments that command would receive
   */
  // beforeCommand: function (commandName, args) {
  // },
  /**
   * Runs before a Cucumber feature
   */
  beforeFeature: function(uri, feature, scenarios) {
    scenarioCounter = 0;
    featurePassed = true;
  },
  /**
   * Runs before a Cucumber scenario
   */
  beforeScenario: function(uri, feature, scenario, sourceLocation) {
    if (!firstTime) {
      global.targetDevice.closeApp();
      global.targetDevice.pause(1000);
      global.targetDevice.launchApp();
      if (global.targetDevice.isIOS) {
        global.targetDevice.pause(2000);
      }
    }
    firstTime = false;
  },
  /**
   * Runs before a Cucumber step
   */
  // beforeStep: function(uri, feature, stepData, context) {},
  /**
   * Runs after a Cucumber step
   */
  // afterStep: function (uri, feature, { error, result, duration, passed }, stepData, context) {
  // },
  afterStep: function(uri, feature, { error }) {
    if (error !== undefined) {
      browser.takeScreenshot();
    }
  },
  /**
   * Runs after a Cucumber scenario
   */
  afterScenario: function(uri, feature, scenario, result, sourceLocation) {
    scenarioCounter += 1;
    if (result.status === 'failed') {
      featurePassed = false;
    }
    addArgument('Scenario #', scenarioCounter);
  },

  // afterTest: function(test) {

  // },
  /**
   * Runs after a Cucumber feature
   */
  // afterFeature: function(uri, feature, scenarios) {
  //   if (!JSON.parse(CAT_DEV)) {
  //     // const sessionId = global.targetDevice.sessionId;
  //     // updateSauceLabsStatus(sessionId, featurePassed);
  //   }
  // },

  /**
   * Runs after a WebdriverIO command gets executed
   * @param {String} commandName hook command name
   * @param {Array} args arguments that command would receive
   * @param {Number} result 0 - command success, 1 - command error
   * @param {Object} error error object if any
   */
  // afterCommand: function (commandName, args, result, error) {
  // },

  /**
   * Gets executed right after terminating the webdriver session.
   * @param {Object} config wdio configuration object
   * @param {Array.<Object>} capabilities list of capabilities details
   * @param {Array.<String>} specs List of spec file paths that ran
   */
  afterSession: async function(config, capabilities, specs) {
    if (!JSON.parse(CAT_DEV)) {
      // each session runs each spec
      const spec = specs[0];
      const separatedNames = spec.split(path.sep);
      if (separatedNames.length > 0) {
        const testName = separatedNames[separatedNames.length - 1].split('.')[0];
        await emitMetrics(testName, global.targetDevice.capabilities, 'E2E', featurePassed ? 1 : 0);
      }
    }
  },
  /**
   * Gets executed after all workers got shut down and the process is about to exit. An error
   * thrown in the onComplete hook will result in the test run failing.
   * @param {Object} exitCode 0 - success, 1 - fail
   * @param {Object} config wdio configuration object
   * @param {Array.<Object>} capabilities list of capabilities details
   * @param {<Object>} results object containing test results
   */
  onComplete: function(exitCode, config, capabilities, results) {
    if (!JSON.parse(CAT_DEV)) {
      global.driver && global.driver.quit();
    }
    try {
      fs.writeFileSync(path.join(rootDir, 'result'), `${exitCode}`);
    } catch (err) {
      console.log(err);
    }
  },
  /**
   * Gets executed when a refresh happens.
   * @param {String} oldSessionId session ID of the old session
   * @param {String} newSessionId session ID of the new session
   */
  // onReload: function(oldSessionId, newSessionId) {
  // }
};
