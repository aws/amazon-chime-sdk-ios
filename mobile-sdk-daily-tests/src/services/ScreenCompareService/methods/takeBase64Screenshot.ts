/* eslint-disable no-console */
/**
 * Take a base64 screenshot
 *
 * @return string
 */
export function takeBase64Screenshot(
  currentBrowser: WebdriverIO.BrowserObject = browser
): string {
  return currentBrowser.takeScreenshot();
}
