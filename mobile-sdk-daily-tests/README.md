# Mobile SDK Daily Tests

End-to-end daily test harness for the Amazon Chime SDK iOS and Android demo applications. It drives a demo app on a Sauce Labs real device with [Appium](http://appium.io/) and [WebdriverIO](https://webdriver.io/), and uses a Chrome session running the [Amazon Chime SDK JS meeting demo](https://github.com/aws/amazon-chime-sdk-js/tree/main/demos/browser) as the second meeting participant. Scenarios are written as [Cucumber](https://github.com/cucumber/cucumber-js) features.

The same harness serves both mobile SDKs: `--app-url` ending in `.ipa` or `.app` selects iOS, and `.apk` selects Android.

## Layout

| Path | Contents |
|---|---|
| `src/cma.ts` | Command-line entry point (`npm run cma`) that sets `CAT_*` environment variables and launches WebdriverIO |
| `src/configs/` | WebdriverIO configuration. `wdio.conf.sauce.js` is used for Sauce Labs runs and `wdio.conf.mobile.js` for local `--dev` runs; both extend `wdio.conf.js` |
| `src/features/` | Cucumber features. The daily workflows run scenarios tagged `@common` |
| `src/steps/` | Step definitions. All step files are loaded for every run |
| `src/screens/` | Mobile demo application screen objects |
| `src/pages/` | Browser demo page object for the helper participant |
| `src/services/ScreenCompareService/` | WebdriverIO service for screenshot comparison |
| `src/utils/` | Shared helpers, including the optional CloudWatch metric adapter |

## Prerequisites

- Node.js 15.14.0 (the version used by the GitHub workflows)
- A Sauce Labs account for device runs
- The URL of a deployed Amazon Chime SDK JS meeting demo

The `canvas` dependency builds a native module during install. On a machine without the Cairo and Pango libraries (for example macOS without `pkg-config`), `npm ci` fails while building `canvas`. Install the libraries listed in the [node-canvas documentation](https://github.com/Automattic/node-canvas#compiling), or use `npm ci --ignore-scripts` when you only need to compile and run unit tests.

The package depends on an old `husky` release that installs Git hooks into the enclosing repository. Set `HUSKY_SKIP_INSTALL=1` before installing to skip this.

## Build and unit tests

```bash
cd mobile-sdk-daily-tests
export HUSKY_SKIP_INSTALL=1
npm ci
npm run build
npm run test:unit
```

`npm run build` compiles `src` into `dist`. The WebdriverIO configurations load helpers from `dist`, so build before every device run.

## Running on Sauce Labs

Set the Sauce Labs credentials in your environment. Do not commit them.

```bash
export SAUCE_USERNAME=<your-sauce-username>
export SAUCE_ACCESS_KEY=<your-sauce-access-key>
```

Upload the application to Sauce Storage and keep the returned ID:

```bash
upload_response=$(curl --fail-with-body --silent --show-error \
  -F 'payload=@<path-to-ipa-or-apk>' \
  -F 'name=<app-file-name>' \
  -u "${SAUCE_USERNAME}:${SAUCE_ACCESS_KEY}" \
  'https://api.us-west-1.saucelabs.com/v1/storage/upload')
export APP_ID=$(jq -er '.item.id' <<< "$upload_response")
```

Run the daily suite. `--demo-url` is required; the harness adds `dev=1` (synthetic audio and video) and `fatal=1` (stop on demo errors) while preserving any query parameters you pass.

```bash
npm run cma -- --app-url sample.app --app-id "$APP_ID" --demo-url "<demo-url>" \
  --retry --platform-version 16 --tag "@common"
```

Use `--app-url sample.apk` for Android. Use a narrower tag such as `@video` to run a subset. Run `npm run cma -- --help` for all options.

## Running locally

Install Appium globally, connect a device or start a simulator, then run with `--dev`. For a physical iOS device, set `XCODE_ORG_ID` to your Apple Developer Team ID so Appium can sign WebDriverAgent.

```bash
npm run cma -- --app-url "<absolute-path-to-app>" --demo-url "<demo-url>" --dev --log-level debug
```

## Daily workflows

`.github/workflows/daily-test.yml` runs this harness against the published demo applications on iOS 15 and 16, for the default and no-video-codecs flavors, and publishes one pass/fail summary metric per matrix job. It needs the `HELPER_DEMO_URL` repository variable and these repository secrets: `SAUCE_USERNAME`, `SAUCE_ACCESS_KEY`, `DEMO_APP_DOWNLOAD_LINK`, `NO_VIDEO_CODECS_DEMO_APP_DOWNLOAD_LINK`, `SLACK_WEBHOOK_URL`, `ROLE_TO_ASSUME`, `METRIC_NAME`, and `METRIC_NAMESPACE`.

`.github/workflows/mobile-sdk-automation.yml` compiles the harness and runs its unit tests on pull requests and pushes that change this directory or that workflow. It uses no secrets.

## Optional harness metrics

`src/utils/CloudWatchUtils.ts` publishes per-feature metrics to Amazon CloudWatch only when `CLOUD_WATCH_METRIC` is set. The namespace is `<TEST_TYPE>/<feature name>`, taken from the `TEST_TYPE` environment variable, and credentials come from the standard AWS SDK credential chain. The GitHub daily workflows leave it disabled.

## Writing tests

A scenario needs a feature in `src/features/`, matching step definitions in `src/steps/`, and any new elements in `src/screens/` (mobile) or `src/pages/` (browser). Mobile elements are located by accessibility ID: set `accessibilityIdentifier` on iOS or `contentDescription` on Android, then query it with `this.browser.$('~<id>')`. Tag new scenarios with `@common` to include them in the daily run.

Before changing the browser page object, run the full `@common` suite on one Android and one iOS version. The page object drives both platforms, so an Android-only run does not validate it.
