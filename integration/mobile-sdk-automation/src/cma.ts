import * as fs from 'fs-extra';
import * as path from 'path';

import {
  SUPPORTED_ANDROID_DEVICES,
  SUPPORTED_DEVICES_MAP,
  SUPPORTED_IOS_DEVICES,
} from './constants';
import { createLogger } from './utils/LoggerUtils';

const Launcher = require('@wdio/cli').default;

import yargs = require('yargs');

const logger = createLogger('cma');

function configure(): void {
  const args = yargs
    .option('device', {
      alias: 'd',
      describe: 'Provide a device that app is going to be installed',
      choices: [...SUPPORTED_ANDROID_DEVICES.values(), ...SUPPORTED_IOS_DEVICES.values()],
      type: 'string',
      coerce: (device: string) => {
        const devicesMapped = SUPPORTED_DEVICES_MAP[device.toLocaleLowerCase()];
        return devicesMapped;
      },
    })
    .option('app-url', {
      alias: 'a',
      describe: 'Provide app url to obtain the target app',
      type: 'string',
    })
    .demandOption('app-url')
    .option('demo-url', {
      describe: 'Provide demo url for target app',
      type: 'string',
    })
    .option('dev', {
      describe: 'Run tests in developer mode, i.e., use local Selenium driver and Appium Server',
      default: false,
      type: 'boolean',
    })
    .option('platform-version', {
      describe: 'Platform version, i.e. 11 (for iOS) or 9 (for Android) ',
      type: 'string',
    })
    .option('tag', {
      describe: 'Run tests by tag',
      type: 'string',
    })
    .option('specs', {
      describe: 'Run specific tests',
      type: 'array',
    })
    .option('test-type', {
      describe: 'canary or automated test or local',
      type: 'string',
      default: 'automated',
      option: ['canary', 'canary-gamma', 'automated', 'local'],
    })
    .option('log-level', {
      alias: 'll',
      describe: 'Run log levels',
      choices: ['debug', 'info', 'warn', 'error', 'silent'],
      type: 'string',
      default: 'debug',
    })
    .option('app-id', {
      alias: 'ai',
      describe: 'Provide app id',
      type: 'string',
    })
    .option('retry', {
      alias: 'r',
      describe: 'Retry with given app-id.',
      type: 'boolean',
    })
    .option('sauce-enable-audio', {
      alias: 'sea',
      describe: 'Enable audio capture in saucelabs',
      type: 'boolean',
      default: false,
    });

  const { argv } = args;
  if (!argv.dev) {
    args.demandOption(['device']);
    process.env.CAT_TEST_TYPE = argv['test-type'];
  }
  const isAndroid = argv['app-url'].endsWith('.apk');
  const isIOS = argv['app-url'].endsWith('.app') || argv['app-url'].endsWith('.ipa');
  if (isAndroid === isIOS) {
    logger.error('unable to tell the app url please provide either apk, ipa, app');
    process.exit(1);
  }
  process.env.CAT_MOBILE_PLATFORM = isAndroid ? 'android' : 'ios';
  process.env.CAT_DEVICE = argv.device;
  process.env.CAT_DEV = JSON.stringify(argv.dev);
  process.env.CAT_APP_URL = argv['app-url'];
  process.env.CAT_LOG_LEVEL = argv['log-level'];
  process.env.CAT_SAUCE_APP_ID = argv['app-id'];
  process.env.CAT_RETRY = argv['retry'] ? 'true' : 'false';
  process.env.CAT_SAUCE_ENABLE_AUDIO = argv['sauce-enable-audio'] ? 'true' : 'false';

  if (argv['platform-version']) {
    process.env.CAT_PLATFORM_VERSION = argv['platform-version'];
  }
  if (argv.tag) {
    process.env.CAT_TAG = argv.tag;
  } else {
    // Use @common tag for normal run on Android since it does not need callkit
    if (isAndroid) {
      process.env.CAT_TAG = '@common';
    }
  }
  if (argv['demo-url']) {
    process.env.CAT_DEMO_URL = argv['demo-url'];
  }
}

async function configureAndRun(): Promise<void> {
  configure();
  const configFile = JSON.parse(process.env.CAT_DEV as string)
    ? './configs/wdio.conf.mobile.js'
    : './configs/wdio.conf.sauce.js';
  const configPath = path.join(__dirname, `${configFile}`);
  const wdio = new Launcher(configPath, {});
  try {
    const result = await wdio.run();
    fs.removeSync('store.json');
    process.exit(result);
  } catch (err) {
    logger.error(err);
    process.exit(1);
  }
}

configureAndRun();

process.on('SIGTERM', () => {
  logger.warn('received sigterm');
  global.driver && global.driver.quit();
});

process.on('SIGINT', () => {
  logger.warn('received sigint');
  global.driver && global.driver.quit();
});
